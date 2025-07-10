package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Store;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Product.class)
public class Product_ { 

    public static volatile SingularAttribute<Product, String> productid;
    public static volatile SingularAttribute<Product, String> imagepath;
    public static volatile SingularAttribute<Product, Double> price;
    public static volatile SingularAttribute<Product, String> productname;
    public static volatile SingularAttribute<Product, String> description;
    public static volatile SingularAttribute<Product, Store> store;
    public static volatile SingularAttribute<Product, String> category;
    public static volatile SingularAttribute<Product, Integer> stockquantity;

}