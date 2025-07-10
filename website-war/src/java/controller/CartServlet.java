package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
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
import model.MyUserFacade;
import model.Product;
import model.ProductFacade;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    @EJB
    private CartFacade cartFacade;

    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private ProductFacade productFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser user = (MyUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        Customer customer = customerFacade.find(user.getId());

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        session.setAttribute("customer", customer);

        
        String action = request.getParameter("action");
        String cartIdStr = request.getParameter("cartId");
        String quantityStr = request.getParameter("quantity");
        String productId = request.getParameter("productId");;

        if (action != null && (cartIdStr != null && !cartIdStr.isEmpty())) {
            
            Long cartId = Long.parseLong(cartIdStr);
            Cart cartItem = cartFacade.find(cartId);

            if (cartItem == null) {
                response.sendRedirect("cart.jsp?msg=Cart+item+not+found");
                return;
            }

            if ("increase".equals(action)) {
                cartItem.setQuantity(cartItem.getQuantity() + 1);
                cartFacade.edit(cartItem);
            } else if ("decrease".equals(action)) {
                int currentQty = cartItem.getQuantity();
                if (currentQty > 1) {
                    cartItem.setQuantity(currentQty - 1);
                    cartFacade.edit(cartItem);
                }
            } else if ("update".equals(action)) {
                try {
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity < 1) {
                        quantity = 1;
                    }
                    cartItem.setQuantity(quantity);
                    cartFacade.edit(cartItem);
                } catch (NumberFormatException e) {
                    
                }
            } else if ("remove".equals(action)) {
                cartFacade.remove(cartItem);
            }
        } else if (productId != null && !productId.isEmpty()) {
            
            Product product = productFacade.find(productId);

            if (product == null) {
                response.sendRedirect("cart.jsp?msg=Product+not+found");
                return;
            }

            
            Cart existingCartItem = cartFacade.findByCustomerAndProduct(customer, product);

            if (existingCartItem != null) {
                
                existingCartItem.setQuantity(existingCartItem.getQuantity() + 1);
                cartFacade.edit(existingCartItem);
            } else {
                
                Cart newCartItem = new Cart();
                newCartItem.setProduct(product);
                newCartItem.setQuantity(1);
                newCartItem.setCustomer(customer);
                cartFacade.create(newCartItem);
            }
        }

        List<Cart> cartItems = cartFacade.findByCustomer(customer);
        session.setAttribute("cartItems", cartItems);

        response.sendRedirect("cart.jsp");

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
