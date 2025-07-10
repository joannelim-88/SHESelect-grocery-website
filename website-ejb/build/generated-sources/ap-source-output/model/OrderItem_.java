package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.MyOrder;
import model.Product;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(OrderItem.class)
public class OrderItem_ { 

    public static volatile SingularAttribute<OrderItem, Product> product;
    public static volatile SingularAttribute<OrderItem, Integer> quantity;
    public static volatile SingularAttribute<OrderItem, Double> totalamount;
    public static volatile SingularAttribute<OrderItem, Double> price;
    public static volatile SingularAttribute<OrderItem, String> productname;
    public static volatile SingularAttribute<OrderItem, Long> id;
    public static volatile SingularAttribute<OrderItem, String> status;
    public static volatile SingularAttribute<OrderItem, MyOrder> order;

}