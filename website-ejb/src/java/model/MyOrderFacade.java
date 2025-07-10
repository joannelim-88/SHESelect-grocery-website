package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class MyOrderFacade extends AbstractFacade<MyOrder> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public MyOrderFacade() {
        super(MyOrder.class);
    }

    public List<MyOrder> findByCustomerId(String customerId) {
        return em.createQuery("SELECT o FROM MyOrder o WHERE o.customer.customerid = :customerId", MyOrder.class)
                .setParameter("customerId", customerId)
                .getResultList();
    }

    public List<MyOrder> findByOrderStatus(String status) {
        return em.createQuery("SELECT o FROM MyOrder o WHERE o.orderstatus = :status", MyOrder.class)
                .setParameter("status", status)
                .getResultList();
    }

}
