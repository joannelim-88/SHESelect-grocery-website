package model;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
public class GrocerFacade extends AbstractFacade<Grocer> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public GrocerFacade() {
        super(Grocer.class);
    }

    public Grocer findGrocerByUserId(String userId) {
        try {
            // Directly use the userId to find the grocer based on grocerid
            return em.createQuery("SELECT g FROM Grocer g WHERE g.grocerid = :userId", Grocer.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Handle case where no Grocer is found for the user
        }
    }

}
