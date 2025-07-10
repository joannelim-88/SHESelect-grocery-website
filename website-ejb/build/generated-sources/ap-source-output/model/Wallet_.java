package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Customer;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Wallet.class)
public class Wallet_ { 

    public static volatile SingularAttribute<Wallet, Double> balance;
    public static volatile SingularAttribute<Wallet, Long> id;
    public static volatile SingularAttribute<Wallet, Customer> customer;

}