package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Grocer;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Store.class)
public class Store_ { 

    public static volatile SingularAttribute<Store, Grocer> grocer;
    public static volatile SingularAttribute<Store, String> address;
    public static volatile SingularAttribute<Store, String> storename;
    public static volatile SingularAttribute<Store, String> description;
    public static volatile SingularAttribute<Store, String> storeid;
    public static volatile SingularAttribute<Store, String> status;

}