package model;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
public class ProductFacade extends AbstractFacade<Product> {

    @PersistenceContext(unitName = "FYP_SHESelectwebsite-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ProductFacade() {
        super(Product.class);
    }

    public List<Product> findAll() {
        // Query to fetch all products from the database
        return em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
    }

    public List<Product> findByCategory(String category) {
        // Query to fetch products based on category
        return em.createQuery("SELECT p FROM Product p WHERE p.category = :category", Product.class)
                .setParameter("category", category)
                .getResultList();
    }

    public List<Product> findByCategory1(String category) {
        return em.createQuery("SELECT p FROM Product p WHERE LOWER(p.category) = LOWER(:category)", Product.class)
                .setParameter("category", category)
                .getResultList();
    }

    public boolean deleteProduct(String productId) {
        try {
            Product product = em.find(Product.class, productId);
            if (product != null) {
                em.remove(product);
                return true; // Product deleted successfully
            }
            return false; // Product not found
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Error during deletion
        }
    }

    public List<Product> findByStoreId(String storeId) {
        return em.createQuery("SELECT p FROM Product p WHERE p.store.storeid = :storeId", Product.class)
                .setParameter("storeId", storeId)
                .getResultList();
    }

    public List<Product> findByStoreIdAndCategory(String storeId, String category) {
        return em.createQuery("SELECT p FROM Product p WHERE p.store.storeid = :storeId AND LOWER(p.category) = LOWER(:category)", Product.class)
                .setParameter("storeId", storeId)
                .setParameter("category", category)
                .getResultList();
    }

    public Product findByProductAndStore(String productId, String storeId) {
        try {
            return em.createQuery(
                    "SELECT p FROM Product p WHERE p.productid = :productId AND p.store.storeid = :storeId", Product.class)
                    .setParameter("productId", productId) // must match String
                    .setParameter("storeId", storeId) // must match String
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

}
