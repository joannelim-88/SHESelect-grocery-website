package controller;

import java.io.IOException;
import java.util.UUID;
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

@WebServlet(name = "AddStore", urlPatterns = {"/AddStore"})
public class AddStore extends HttpServlet {

    @EJB
    private GrocerFacade grocerFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser user = (MyUser) session.getAttribute("user");

        if (user != null && user.getRole().equals("grocer")) {
            
            String name = request.getParameter("storename");
            String description = request.getParameter("description");
            String address = request.getParameter("address");
            String status = request.getParameter("status");

            
            String storeId = "STORE-" + UUID.randomUUID().toString().substring(0, 4);

            
            Grocer grocer = grocerFacade.find(user.getId());

            
            Store newStore = new Store();
            newStore.setStoreid(storeId);
            newStore.setStorename(name);
            newStore.setDescription(description);
            newStore.setAddress(address);
            newStore.setStatus(status);
            newStore.setGrocer(grocer);

           
            storeFacade.create(newStore);

            session.setAttribute("message", "Store added successfully!");

            
            response.sendRedirect("ManageStore");
        } else {
            session.setAttribute("error", "Failed to add store. Please retry.");
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
