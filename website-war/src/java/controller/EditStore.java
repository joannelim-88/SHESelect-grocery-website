package controller;

import java.io.IOException;
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
import model.Store;
import model.StoreFacade;

@WebServlet(name = "EditStore", urlPatterns = {"/EditStore"})
public class EditStore extends HttpServlet {

    @EJB
    private GrocerFacade grocerFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser user = (MyUser) session.getAttribute("user");

        if (user != null && "grocer".equals(user.getRole())) {

            String method = request.getMethod(); 

            if ("GET".equalsIgnoreCase(method)) {
                String storeid = request.getParameter("storeid");
                System.out.println("Incoming storeid: " + storeid);

                if (storeid == null || storeid.trim().isEmpty()) {
                    System.out.println("Storeid is null or empty.");
                    session.setAttribute("error", "Invalid store ID. Please try again.");
                    response.sendRedirect("ManageStore");
                    return;
                }

                
                Store store = storeFacade.find(storeid);

                if (store != null) {
                    request.setAttribute("store", store);  
                    request.getRequestDispatcher("editstore.jsp").forward(request, response);
                } else {
                    session.setAttribute("error", "Store not found.");
                    response.sendRedirect("ManageStore");
                }

                return;
            }

            if ("POST".equalsIgnoreCase(method)) {
                String storeid = request.getParameter("storeid");
                System.out.println("Incoming storeid: " + storeid);
                String name = request.getParameter("storename");
                String description = request.getParameter("description");
                String address = request.getParameter("address");
                String status = request.getParameter("status");

                if (storeid == null || storeid.trim().isEmpty()) {
                    session.setAttribute("error", "Store ID cannot be empty.");
                    response.sendRedirect("ManageStore");
                    return;
                }

                
                Store store = storeFacade.find(storeid);
                Grocer grocer = grocerFacade.find(user.getId());

                System.out.println("Store: " + store);
                System.out.println("Store Grocer: " + (store != null ? store.getGrocer() : "store is null"));
                System.out.println("Logged-in Grocer: " + grocer);

                if (store != null && store.getGrocer() != null
                        && store.getGrocer().getGrocerid().equals(grocer.getGrocerid())) {
                    
                    store.setStorename(name);
                    store.setDescription(description);
                    store.setAddress(address);
                    store.setStatus(status);

                    storeFacade.edit(store); 
                    session.setAttribute("message", "Store updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update store. Please try again.");
                }

                response.sendRedirect("ManageStore");
            }

        } else {
            session.setAttribute("error", "Login as grocer to edit store.");
            response.sendRedirect("login.jsp");
        }
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
