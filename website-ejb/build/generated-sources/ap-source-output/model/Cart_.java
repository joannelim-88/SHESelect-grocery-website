package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Customer;
import model.Product;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Cart.class)
public class Cart_ { 

    public static volatile SingularAttribute<Cart, Product> product;
    public static volatile SingularAttribute<Cart, Integer> quantity;
    public static volatile SingularAttribute<Cart, Long> cartid;
    public static volatile SingularAttribute<Cart, Customer> customer;

}