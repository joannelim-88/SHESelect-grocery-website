<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="model.OrderItem"%>
<%@page import="model.MyUser"%>
<%@page import="model.Feedback"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback forum | SHESelect</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <%-- Website CSS layout design --%>
        <style>
            body {
                background-color: #e0ffe0; 
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
            }

            header {
                background-color: #f8c8d3; 
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 30px; 
                width: 100vw; 
                box-sizing: border-box;
                position: relative;
                z-index: 1;
            }
            header img {
                height: 55px; 
            }
            .header-icons {
                display: flex;
                align-items: center;
                gap: 25px; 
            }
            .header-icons img {
                width: 50px;
                height: 50px;
                object-fit: contain;
                cursor: pointer;
            }


            @media (max-width: 600px) {
                header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .header-icons {
                    margin-top: 10px;
                }
            }
            @media (max-width: 768px) {
                .carousel {
                    height: 300px; 
                }
            }

            #side-menu {
                position: absolute;
                top: 60px; 
                right: 10px;
                width: 270px;
                background-color: #eeeeee;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                border-radius: 10px;
                display: none;
                z-index: 999;
                transition: all 0.3s ease;
                padding: 12px;
            }

            #side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            #side-menu ul li {
                padding: 12px;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                font-size: 15px;
                border-bottom: 0.7px solid #ccc;
            }

            .logout-btn {
                display: inline-block;
                text-align: center;
                background-color: orange;
                color: white;
                border-radius: 20px;
                padding: 8px;
                text-decoration: none;
            }

            .back-button {
                background-color: orange;
                color: white;
                padding: 10px 25px;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                border-radius: 10px;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .back-button:hover {
                background-color: #ffb84d; 
            }

            .content-wrapper { 
                padding: 20px;
            }

            .feedback-container {
                display: flex;
                flex-wrap: wrap;
                gap: 1.5rem;
                padding: 1rem;
            }
            .feedback-card {
                background-color: #fce4ec;
                border-radius: 10px;
                padding: 1rem;
                width: 300px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            .feedback-header h3 {
                margin: 0;
            }
            .rating-tag {
                background: #ffe0b2;
                padding: 4px 8px;
                border-radius: 5px;
                margin-right: 5px;
            }
            .sentiment-tag {
                padding: 4px 8px;
                border-radius: 5px;
                font-weight: bold;
            }
            .sentiment-tag.positive {
                background: #c8e6c9;
                color: #2e7d32;
            }
            .sentiment-tag.neutral {
                background: #fff9c4;
                color: #fbc02d;
            }
            .sentiment-tag.negative {
                background: #ffcdd2;
                color: #c62828;
            }

            .feedback-icon {
                text-align: center;
                font-size: 2rem;
                color: #6a1b9a;
                margin-bottom: 0.5rem;
            }

            .tags {
                margin: 0.5rem 0;
            }

            .tag {
                background-color: #d1c4e9;
                color: #4a148c;
                padding: 4px 8px;
                border-radius: 10px;
                font-size: 0.75rem;
                margin-right: 5px;
                display: inline-block;
            }
            .sentiment-tag.positive { 
                color: green; 
            }
            .sentiment-tag.negative { 
                color: red; 
            }
            .sentiment-tag.neutral { 
                color: orange; 
            }
        </style>
        <script>
            function toggleMenu() {
                const menu = document.getElementById("side-menu");
                menu.style.display = (menu.style.display === "block") ? "none" : "block";
            }

            function logout() {
                const confirmed = confirm("Are you sure you want to logout?");
                if (confirmed) {
                    window.location.href = "Logout";
                }
            }
        </script>
    </head>
    <body>
        <%-- Home page Header --%> 
        <header>
            <img src="images/home page icon.png" alt="Logo"> 
            <div class="header-icons">
                <a href="GrocerProfile"><img src="images/profile icon1.png" alt="Profile"></a> 
                <img src="images/menu icon.png" alt="Menu" id="menu-icon" onclick="toggleMenu()"> 
            </div>

            <div id="side-menu">
                <ul>
                    <li>
                        <a href="CustomerOrders">
                            <img src="images/cart icon.png"> Customer orders
                        </a>
                    </li>
                    <li>
                        <a href="GFeedbackForum">
                            <img src="images/star icon.png"> Feedback forum
                        </a>
                    </li>
                    <li>
                        <button onclick="logout()" class="logout-btn">Logout</button>
                    </li>
                </ul>
            </div>
        </header>
        <%
            List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
        %>
        <div class="content-wrapper">
            <a href="grocerhome.jsp" class="back-button">Back</a>
            <br><br><br>
            <h1>Feedback Forum</h1>

            <%-- Feedback Filter --%>
            <div class="feedback-filter">
                <form action="GFeedbackForum" method="GET">
                    <label for="ratingFilter">Filter by Rating:</label>
                    <select name="ratingFilter">
                        <option value="" <%= request.getParameter("ratingFilter") == null ? "selected" : ""%>>All Ratings</option>
                        <option value="5" <%= "5".equals(request.getParameter("ratingFilter")) ? "selected" : ""%>>5</option>
                        <option value="4" <%= "4".equals(request.getParameter("ratingFilter")) ? "selected" : ""%>>4</option>
                        <option value="3" <%= "3".equals(request.getParameter("ratingFilter")) ? "selected" : ""%>>3</option>
                        <option value="2" <%= "2".equals(request.getParameter("ratingFilter")) ? "selected" : ""%>>2</option>
                        <option value="1" <%= "1".equals(request.getParameter("ratingFilter")) ? "selected" : ""%>>1</option>
                    </select>


                    <label for="sentimentFilter">Filter by Sentiment:</label>
                    <select name="sentimentFilter">
                        <option value="" <%= request.getParameter("sentimentFilter") == null ? "selected" : ""%>>All Sentiments</option>
                        <option value="positive" <%= "positive".equalsIgnoreCase(request.getParameter("sentimentFilter")) ? "selected" : ""%>>Positive</option>
                        <option value="neutral" <%= "neutral".equalsIgnoreCase(request.getParameter("sentimentFilter")) ? "selected" : ""%>>Neutral</option>
                        <option value="negative" <%= "negative".equalsIgnoreCase(request.getParameter("sentimentFilter")) ? "selected" : ""%>>Negative</option>
                    </select>

                    <button type="submit">Apply Filter</button>
                </form>
            </div>

            <%-- Display all feedback --%>
            <div class="feedback-container">
                <%
                    if (feedbackList != null && !feedbackList.isEmpty()) {
                        for (Feedback fb : feedbackList) {
                            if (fb.getReplyTo() == null) {
                %>
                <div class="feedback-card">
                    <div class="feedback-icon">
                        <i class="fas fa-comment-dots"></i>
                    </div>

                    <div class="feedback-header">
                        <h3><%= fb.getFeedbacktitle() != null ? fb.getFeedbacktitle() : "Feedback"%></h3>
                        <div class="tags">
                            <%
                                String[] tags = fb.getItem().getProduct().getCategory().split(",");
                                for (String tag : tags) {
                            %>
                            <span class="tag"><%= tag.trim()%></span>
                            <%
                                }
                            %>
                        </div>
                        <span class="rating-tag">Rating: <%= fb.getRating()%> / 5</span>
                        <% if (fb.getSentiment() != null) {%>
                        <p><strong>Sentiment:</strong>
                            <span class="sentiment-tag <%= fb.getSentiment().toLowerCase()%>">
                                <%= fb.getSentiment()%>
                            </span>
                        </p>
                        <% }%>
                    </div>

                    <p><%= fb.getFeedbackdetail()%></p>

                    <div class="feedback-meta">
                        <p><strong>Customer:</strong> <%= fb.getCustomer().getCustomerid()%></p>
                        <p><strong>Product:</strong> <%= fb.getItem().getProductname()%></p>
                        <p><strong>Store:</strong> <%= fb.getItem().getProduct().getStore().getStorename()%></p>
                    </div>

                    <%-- Replies --%>
                    <div class="feedback-replies">
                        <%
                            for (Feedback reply : feedbackList) {
                                if (reply.getReplyTo() != null
                                        && reply.getReplyTo().getFeedbackid() == fb.getFeedbackid()) {
                        %>
                        <div class="reply-card" style="margin-left: 30px; padding: 10px; border-left: 2px solid #ccc;">
                            <p><strong><%= reply.getCustomer().getCustomerid()%> replied:</strong> <%= reply.getFeedbackdetail()%></p>
                            <p style="font-size: small;">Rating: <%= reply.getRating()%> | Product: <%= reply.getItem().getProductname()%></p>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <%
                        }
                    }
                } else {
                %>
                <p>No feedback available yet.</p>
                <%
                    }
                %>
            </div>

            <%
                MyUser currentUser = (MyUser) session.getAttribute("user");
                if (currentUser != null && "customer".equalsIgnoreCase(currentUser.getRole())) {
            %>

            <button id="showFormBtn" onclick="toggleFeedbackForm()">Add New Feedback</button>

            <!-- Hidden feedback form -->
            <div class="add-feedback-form" id="addFeedbackForm" style="display: none;">
                <form action="GFeedbackForum" method="POST">
                    <input type="hidden" name="action" value="addFeedback">
                    <h2>Post New Feedback</h2>

                    <textarea name="feedbackDetail" placeholder="Write your feedback..." required></textarea>
                    <input type="number" name="rating" min="1" max="5" placeholder="Rating (1-5)" required>

                    <!-- Item Dropdown -->
                    <label for="itemId">Select Item:</label>
                    <select name="itemId" required>
                        <%
                            List<OrderItem> itemList = (List<OrderItem>) request.getAttribute("itemList");
                            if (itemList != null) {
                                for (OrderItem item : itemList) {
                        %>
                        <option value="<%= item.getId()%>">
                            <%= item.getProductname()%> (Store: <%= item.getProduct().getStore().getStorename()%>)
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>


                    <label for="replyToCustomer">Reply To (Customer ID):</label>
                    <select name="replyToId">
                        <option value="">None (New Feedback)</option>
                        <%
                            Set<String> customerIds = new HashSet<String>();
                            if (feedbackList != null) {
                                for (Feedback f : feedbackList) {
                                    String customerId = f.getCustomer().getCustomerid();
                                    if (!customerIds.contains(customerId)) {
                                        customerIds.add(customerId);
                        %>
                        <option value="<%= f.getFeedbackid()%>">
                            Feedback ID: <%= f.getFeedbackid()%> - User: <%= f.getCustomer().getCustomerid()%>
                        </option>
                        <%
                                    }
                                }
                            }
                        %>
                    </select>

                    <button type="submit">Submit Feedback</button>
                </form>
            </div>
            <%
                }
            %>
        </div>
    </body>
</html>
