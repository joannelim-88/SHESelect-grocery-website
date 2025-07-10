package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
public class CartFacade extends AbstractFacade<Cart> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CartFacade() {
        super(Cart.class);
    }

    public List<Cart> findByCustomer(Customer customer) {
        return em.createQuery("SELECT c FROM Cart c WHERE c.customer = :customer", Cart.class)
                .setParameter("customer", customer)
                .getResultList();
    }

    public Cart findByCustomerAndProduct(Customer customer, Product product) {
        try {
            return em.createQuery("SELECT c FROM Cart c WHERE c.customer = :customer AND c.product = :product", Cart.class)
                    .setParameter("customer", customer)
                    .setParameter("product", product)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

}
