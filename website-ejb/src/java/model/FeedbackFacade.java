package model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

@Stateless
public class FeedbackFacade extends AbstractFacade<Feedback> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public FeedbackFacade() {
        super(Feedback.class);
    }

    public Feedback findByOrderItem(Long itemId) {
        try {
            return em.createQuery(
                    "SELECT r FROM Feedback r WHERE r.item.id = :itemId AND r.replyTo IS NULL", Feedback.class)
                    .setParameter("itemId", itemId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public Feedback findOriginalByOrderItem(Long itemId) {
        try {
            return em.createQuery(
                    "SELECT r FROM Feedback r WHERE r.item.id = :itemId AND r.replyTo IS NULL", Feedback.class)
                    .setParameter("itemId", itemId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Feedback> getFilteredFeedback(String ratingFilter, String sentimentFilter) {
        String jpql = "SELECT f FROM Feedback f WHERE 1=1";
        Map<String, Object> parameters = new HashMap<>();

        if (ratingFilter != null && !ratingFilter.isEmpty()) {
            jpql += " AND f.rating = :rating";
            parameters.put("rating", Integer.parseInt(ratingFilter));
        }

        if (sentimentFilter != null && !sentimentFilter.isEmpty()) {
            jpql += " AND LOWER(f.sentiment) = :sentiment";
            parameters.put("sentiment", sentimentFilter.toLowerCase());
        }

        TypedQuery<Feedback> query = em.createQuery(jpql, Feedback.class);
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
            query.setParameter(entry.getKey(), entry.getValue());
        }

        return query.getResultList();
    }

    public List<Feedback> findReplies(Long parentId) {
        try {
            Query query = em.createQuery("SELECT f FROM Feedback f WHERE f.replyTo.feedbackid = :parentId");
            query.setParameter("parentId", parentId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
