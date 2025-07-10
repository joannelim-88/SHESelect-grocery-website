package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Customer;
import model.Feedback;
import model.MyOrder;
import model.OrderItem;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Feedback.class)
public class Feedback_ { 

    public static volatile SingularAttribute<Feedback, String> sentiment;
    public static volatile SingularAttribute<Feedback, OrderItem> item;
    public static volatile SingularAttribute<Feedback, String> feedbackdetail;
    public static volatile SingularAttribute<Feedback, Integer> rating;
    public static volatile SingularAttribute<Feedback, Feedback> replyTo;
    public static volatile SingularAttribute<Feedback, Long> feedbackid;
    public static volatile SingularAttribute<Feedback, String> feedbacktitle;
    public static volatile SingularAttribute<Feedback, MyOrder> order;
    public static volatile SingularAttribute<Feedback, Customer> customer;

}