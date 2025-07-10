package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.Customer;
import model.CustomerFacade;
import model.MyUser;
import model.Product;
import model.ProductFacade;
import model.Wallet;
import model.WalletFacade;

@WebServlet(name = "CheckOut", urlPatterns = {"/CheckOut"})
public class CheckOut extends HttpServlet {

    @EJB
    private WalletFacade walletFacade;

    @EJB
    private ProductFacade productFacade;

    @EJB
    private CustomerFacade customerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        MyUser user = (MyUser) session.getAttribute("user");
        Customer customer = customerFacade.find(user.getId()); 

        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");

        List<Map<String, Object>> itemDetails = new ArrayList<>();
        double grandTotal = 0.0;

        if (cartItems != null && !cartItems.isEmpty()) {
            for (Cart cart : cartItems) {
                Product product = productFacade.find(cart.getProduct().getProductid());
                cart.setProduct(product); 

                double total = cart.getQuantity() * product.getPrice();
                grandTotal += total;
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("customer", customer);

        Wallet wallet = walletFacade.findByCustomerId(customer.getCustomerid());
        session.setAttribute("wallet", wallet);

        request.getRequestDispatcher("checkout.jsp").forward(request, response);

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
