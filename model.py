from flask import Flask, request, jsonify
import joblib
import numpy as np
import pandas as pd
import tensorflow as tf
import sys
import types
from types import ModuleType
import collections
from collections import defaultdict
import random
from transformers import TFAutoModelForSequenceClassification, AutoTokenizer
from sklearn.feature_extraction.text import TfidfVectorizer

app = Flask(__name__)

# --- Hybrid Recommender Class ---
class HybridRecommender:
    def __init__(self, svd_model, lightfm_model, alpha):
        self.svd = svd_model
        self.lightfm = lightfm_model
        self.alpha = alpha
        self.user_map = {}  
        self.item_map = {}  
        self.default_score = 0  

    def update_user_map(self, user_id):
        if user_id not in self.user_map:
            new_index = len(self.user_map)
            self.user_map[user_id] = new_index
            print(f"User '{user_id}' added to user_map with index {new_index}")

    def update_item_map(self, item_id):
        if item_id not in self.item_map:
            new_index = len(self.item_map)
            self.item_map[item_id] = new_index
            print(f"Item '{item_id}' added to item_map with index {new_index}")

    def predict(self, user_id, item_id):
        self.update_user_map(user_id)
        self.update_item_map(item_id)

        user_idx = self.user_map.get(user_id)
        item_idx = self.item_map.get(item_id)

        if item_idx is None:
            print(f"Item '{item_id}' not in training data. Using default score.")
            return self.default_score  # Use default score for unseen items

        if user_idx is None:
            print(f"User '{user_id}' unknown to model. Using default score.")
            svd_pred = self.default_score  # Default score for unknown user
            lfm_pred = self.default_score  # Default score for unknown user
        else:
            try:
                svd_pred = self.svd.predict(user_id, item_id).est
            except Exception as e:
                print(f"SVD failed for user {user_id}, item {item_id}: {e}")
                svd_pred = self.default_score

            try:
                lfm_pred = self.lightfm.predict(np.array([user_idx]), np.array([item_idx]))[0]
            except Exception as e:
                print(f"LightFM failed for user {user_id}, item {item_id}: {e}")
                lfm_pred = self.default_score

        hybrid_score = self.alpha * svd_pred + (1 - self.alpha) * lfm_pred
        print(f"Score for user '{user_id}' and item '{item_id}': {hybrid_score}")
        return hybrid_score
    
# Load recommendation model 
with open('hybrid_recommender_model.pkl', 'rb') as f:
    recommender = joblib.load(f)
    print("Recommendation Model loaded successfully with joblib!")

#Extract item map
item_map = recommender.item_map 

@app.route('/get-recommendations', methods=['POST'])
def get_recommendations():
    data = request.json
    user_id = data.get('user_id')
    product_ids = data.get('product_ids', [])

    print(f" Received user_id = {user_id}")
    print(f" Received product_ids = {product_ids}")

    if not user_id or not product_ids:
        return jsonify({'error': 'Missing user_id or product_ids'}), 400

    try:
        scored_items = []
        for item_id in product_ids:
            score = recommender.predict(user_id, item_id)
            scored_items.append((item_id, score))

        # Sort items by score
        scored_items.sort(key=lambda x: x[1], reverse=True)
        top_5 = [item[0] for item in scored_items[:5]]

        print(f"Top 5 Recommendations: {top_5}")
        return jsonify({'recommended_product_ids': top_5})

    except Exception as e:
        print(f"ERROR during recommendation: {e}")
        return jsonify({'error': str(e)}), 500
    

# Load sentiment analysis model
with open('hybrid_sentimentmodels.pkl', 'rb') as f:
    sentiment_model = joblib.load(f)
    # Extract components
    naive_bayes_model = sentiment_model['naive_bayes_model']
    tfidf_vectorizer = sentiment_model['tfidf_vectorizer']

# Load BERT components properly from disk
bert_model_path = "./bert-sentiment-models"  
bert_model = TFAutoModelForSequenceClassification.from_pretrained(bert_model_path)
bert_tokenizer = AutoTokenizer.from_pretrained(bert_model_path)


# Inference function
def predict_sentiment(text):
    try:
        text = text.lower().strip()

        # Naive Bayes prediction
        tfidf_input = tfidf_vectorizer.transform([text])
        nb_pred = naive_bayes_model.predict(tfidf_input)[0]
        nb_label = "positive" if nb_pred == 1 else "negative"

        # BERT prediction
        inputs = bert_tokenizer(text, return_tensors="tf", truncation=True, padding=True)
        outputs = bert_model(**inputs)
        logits = outputs.logits.numpy()[0]
        bert_pred = np.argmax(logits)
        bert_label = ['positive', 'neutral', 'negative'][bert_pred]


        print(f"\nText: {text}")
        print(f"BERT logits: {logits}, Predicted class: {bert_pred} ({bert_label})")
        print(f"Naive Bayes prediction: {nb_pred} ({nb_label})")

        # Combine with weight (BERT is primary)
        if bert_label == nb_label:
            return bert_label
        elif bert_label == "neutral":
            # If BERT is unsure, go with Naive Bayes
            return nb_label
        else:
            # If they disagree, trust BERT more
            return bert_label

    except Exception as e:
        print("Error during prediction:", e)
        return "neutral"

print("Sentiment Model loaded successfully with joblib!")


@app.route('/analyse_sentiment', methods=['POST'])
def analyse_sentiment():
    data = request.get_json()
    text = data.get('text', '')
    
    try:
        sentiment = predict_sentiment(text)
        return jsonify({"sentiment": sentiment})

    except Exception as e:
        print("Error during prediction:", e)
        return jsonify({"sentiment": "neutral"})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)