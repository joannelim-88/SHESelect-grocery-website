package model;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
public class WalletFacade extends AbstractFacade<Wallet> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public WalletFacade() {
        super(Wallet.class);
    }

    public Wallet findByCustomerId(String customerId) {
        try {
            return em.createQuery("SELECT w FROM Wallet w WHERE w.customer.customerid = :cid", Wallet.class)
                    .setParameter("cid", customerId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

}
