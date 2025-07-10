package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Store;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2025-05-14T11:26:24")
@StaticMetamodel(Grocer.class)
public class Grocer_ { 

    public static volatile SingularAttribute<Grocer, String> password;
    public static volatile SingularAttribute<Grocer, String> address;
    public static volatile ListAttribute<Grocer, Store> stores;
    public static volatile SingularAttribute<Grocer, String> name;
    public static volatile SingularAttribute<Grocer, String> grocerid;
    public static volatile SingularAttribute<Grocer, Integer> age;
    public static volatile SingularAttribute<Grocer, String> email;
    public static volatile SingularAttribute<Grocer, Integer> phoneno;

}