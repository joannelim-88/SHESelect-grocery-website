package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Grocer;
import model.GrocerFacade;
import model.MyUser;
import model.Product;
import model.ProductFacade;
import model.Store;
import model.StoreFacade;

@WebServlet(name = "ManageProduct", urlPatterns = {"/ManageProduct"})
public class ManageProduct extends HttpServlet {

    @EJB
    private GrocerFacade grocerFacade;

    @EJB
    private StoreFacade storeFacade;

    @EJB
    private ProductFacade productFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        MyUser myUser = (MyUser) session.getAttribute("user");  

        if (myUser == null) {
            response.sendRedirect("login.jsp"); 
            return;
        }

        Grocer grocer = grocerFacade.findGrocerByUserId(myUser.getId()); 
        if (grocer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        List<Store> stores = storeFacade.findStoresByGrocer(grocer.getGrocerid());
        request.setAttribute("stores", stores);

        
        List<Product> allProducts = productFacade.findAll();
        Set<String> allCategories = new HashSet<>();
        for (Product p : allProducts) {
            allCategories.add(p.getCategory());
        }
        System.out.println("All categories found in DB:");
        for (Product p : allProducts) {
            System.out.println("Product ID: " + p.getProductid() + ", StoreID: " + p.getStore().getStoreid() + ", Category: " + p.getCategory());
        }

        for (String cat : allCategories) {
            System.out.println(" - " + cat);
        }

        
        String storeIdParam = request.getParameter("storeId");
        String category = request.getParameter("category");

        Store selectedStore = null;
        List<Product> products = new ArrayList<>();

        System.out.println("Selected storeId: " + storeIdParam);
        System.out.println("Selected category: " + category);
        System.out.println("Product list size: " + products.size());

        if (storeIdParam != null && !storeIdParam.isEmpty()) {
            try {
                selectedStore = storeFacade.find(storeIdParam);

                if (selectedStore != null) {
                    if (category == null || category.equals("All")) {
                        products = productFacade.findByStoreId(storeIdParam);
                    } else {
                        products = productFacade.findByStoreIdAndCategory(storeIdParam, category);
                    }
                }
            } catch (NumberFormatException e) {
                
            }
        }

        if (category == null) {
            category = "All";
        }

        request.setAttribute("products", products);
        request.setAttribute("category", category);
        request.setAttribute("selectedStoreId", storeIdParam);

        
        request.getRequestDispatcher("manageproduct.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
