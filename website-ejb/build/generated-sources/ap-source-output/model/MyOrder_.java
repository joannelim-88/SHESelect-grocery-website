package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Customer;
import model.OrderItem;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(MyOrder.class)
public class MyOrder_ { 

    public static volatile SingularAttribute<MyOrder, Integer> quantity;
    public static volatile SingularAttribute<MyOrder, Double> totalamount;
    public static volatile SingularAttribute<MyOrder, String> orderstatus;
    public static volatile SingularAttribute<MyOrder, Long> orderid;
    public static volatile SingularAttribute<MyOrder, Double> price;
    public static volatile SingularAttribute<MyOrder, String> ordername;
    public static volatile ListAttribute<MyOrder, OrderItem> orderItems;
    public static volatile SingularAttribute<MyOrder, Customer> customer;

}