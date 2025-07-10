package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class StoreFacade extends AbstractFacade<Store> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public StoreFacade() {
        super(Store.class);
    }

    public List<Store> findAll() {
        return em.createQuery("SELECT s FROM Store s", Store.class).getResultList();
    }

    public List<Store> findStoresByGrocer(String grocerid) {
        return em.createQuery("SELECT s FROM Store s WHERE s.grocer.grocerid = :grocerid", Store.class)
                .setParameter("grocerid", grocerid)
                .getResultList();
    }

}
