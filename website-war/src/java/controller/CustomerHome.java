package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.CartFacade;
import model.Customer;
import model.CustomerFacade;
import model.MyUser;
import model.Store;
import model.StoreFacade;

@WebServlet(name = "CustomerHome", urlPatterns = {"/CustomerHome"})
public class CustomerHome extends HttpServlet {

    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private CartFacade cartFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Store> stores = storeFacade.findAll();  
        request.setAttribute("stores", stores);

        HttpSession session = request.getSession(false);
        
        MyUser a = (MyUser) session.getAttribute("user");

        if (a == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (a != null) {
            String username = a.getId(); 

            
            Customer customer = customerFacade.find(username);

            
            List<Cart> cartItems = cartFacade.findByCustomer(customer);

            
            session.setAttribute("cartItems", cartItems);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("customerhome.jsp");
        dispatcher.forward(request, response);
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
