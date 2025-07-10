package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class OrderItemFacade extends AbstractFacade<OrderItem> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public OrderItemFacade() {
        super(OrderItem.class);
    }

    public List<OrderItem> findByOrderId(Long orderId) {
        return em.createQuery("SELECT o FROM OrderItem o WHERE o.order.orderid = :orderId", OrderItem.class)
                .setParameter("orderId", orderId)
                .getResultList();
    }

    public void deleteByOrderId(Long orderId) {
        List<OrderItem> items = findByOrderId(orderId);
        for (OrderItem item : items) {
            em.remove(em.merge(item));
        }
    }

}
