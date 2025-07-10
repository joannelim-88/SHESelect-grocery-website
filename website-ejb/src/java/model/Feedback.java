package model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class Feedback implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long feedbackid;
    private String feedbacktitle;
    private String feedbackdetail;
    private int rating;
    private String sentiment;

    @ManyToOne
    @JoinColumn(name = "replyto_id")
    private Feedback replyTo;

    @ManyToOne
    @JoinColumn(name = "orderid", nullable = false)
    private MyOrder order;

    @ManyToOne
    @JoinColumn(name = "customerid", nullable = false)
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "orderitemid", nullable = false)
    private OrderItem item;

    public Feedback() {
    }

    public Feedback(Long feedbackid, String feedbacktitle, String feedbackdetail, int rating, String sentiment, Feedback replyTo, MyOrder order, Customer customer, OrderItem item) {
        this.feedbackid = feedbackid;
        this.feedbacktitle = feedbacktitle;
        this.feedbackdetail = feedbackdetail;
        this.rating = rating;
        this.sentiment = sentiment;
        this.replyTo = replyTo;
        this.order = order;
        this.customer = customer;
        this.item = item;
    }

    public Long getFeedbackid() {
        return feedbackid;
    }

    public void setFeedbackid(Long feedbackid) {
        this.feedbackid = feedbackid;
    }

    public String getFeedbackdetail() {
        return feedbackdetail;
    }

    public MyOrder getOrder() {
        return order;
    }

    public void setOrder(MyOrder order) {
        this.order = order;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public void setFeedbackdetail(String feedbackdetail) {
        this.feedbackdetail = feedbackdetail;
    }

    public String getFeedbacktitle() {
        return feedbacktitle;
    }

    public void setFeedbacktitle(String feedbacktitle) {
        this.feedbacktitle = feedbacktitle;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public OrderItem getItem() {
        return item;
    }

    public void setItem(OrderItem item) {
        this.item = item;
    }

    public String getSentiment() {
        return sentiment;
    }

    public void setSentiment(String sentiment) {
        this.sentiment = sentiment;
    }

    public Feedback getReplyTo() {
        return replyTo;
    }

    public void setReplyTo(Feedback replyTo) {
        this.replyTo = replyTo;
    }
    

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (feedbackid != null ? feedbackid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Feedback)) {
            return false;
        }
        Feedback other = (Feedback) object;
        if ((this.feedbackid == null && other.feedbackid != null) || (this.feedbackid != null && !this.feedbackid.equals(other.feedbackid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Feedback[ id=" + feedbackid + " ]";
    }

}
