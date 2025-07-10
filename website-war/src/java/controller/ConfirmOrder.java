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
import model.MyOrder;
import model.MyOrderFacade;
import model.MyUser;
import model.OrderItem;
import model.OrderItemFacade;
import model.Product;
import model.ProductFacade;
import model.Wallet;
import model.WalletFacade;

@WebServlet(name = "ConfirmOrder", urlPatterns = {"/ConfirmOrder"})
public class ConfirmOrder extends HttpServlet {

    @EJB
    private CartFacade cartFacade;

    @EJB
    private WalletFacade walletFacade;

    @EJB
    private ProductFacade productFacade;

    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private OrderItemFacade orderItemFacade;

    @EJB
    private MyOrderFacade myOrderFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser user = (MyUser) session.getAttribute("user");
        List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");

        if (user == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        Customer customer = customerFacade.find(user.getId());
        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        session.setAttribute("customer", customer);

        
        double totalAmount = 0.0;
        for (Cart cart : cartItems) {
            Product product = productFacade.find(cart.getProduct().getProductid());
            if (product != null) {
                totalAmount += product.getPrice() * cart.getQuantity();
            }
        }

        
        Wallet wallet = walletFacade.findByCustomerId(customer.getCustomerid());
        
        if (wallet == null) {
            for (Cart cart : cartItems) {
                Product product = productFacade.find(cart.getProduct().getProductid());
                cart.setProduct(product);
            }
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("grandTotal", totalAmount);
            request.setAttribute("error", "Please top up wallet.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        
        if (wallet.getBalance() < totalAmount) {
            for (Cart cart : cartItems) {
                Product product = productFacade.find(cart.getProduct().getProductid());
                cart.setProduct(product);
            }
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("grandTotal", totalAmount);
            request.setAttribute("error", "Insufficient wallet balance.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        
        StringBuilder orderNames = new StringBuilder();
        double totalProductPrice = 0.0;

        
        MyOrder order = new MyOrder();
        order.setOrdername(orderNames.toString());
        order.setOrderstatus("pending");
        order.setPrice(totalProductPrice); 
        order.setTotalamount(totalAmount);
        order.setCustomer(customer);

        int totalQuantity = 0;
        order.setQuantity(totalQuantity);

        myOrderFacade.create(order);

        for (Cart cart : cartItems) {
            Product product = productFacade.find(cart.getProduct().getProductid());

            if (product != null && product.getStockquantity() >= cart.getQuantity()) {
                int qty = cart.getQuantity();
                double price = product.getPrice();
                double itemTotal = qty * price;

                if (orderNames.length() > 0) {
                    orderNames.append(", ");
                }
                orderNames.append(product.getProductname());

                totalProductPrice += price;
                totalAmount += itemTotal;

                
                OrderItem orderItem = new OrderItem();
                orderItem.setPrice(price);
                orderItem.setQuantity(qty);
                orderItem.setTotalamount(itemTotal);
                orderItem.setProduct(product);
                orderItem.setProductname(product.getProductname());
                orderItem.setOrder(order);

                orderItemFacade.create(orderItem);

                
                totalQuantity += qty;

               
                product.setStockquantity(product.getStockquantity() - qty);
                productFacade.edit(product);
            }
        }

        
        order.setOrdername(orderNames.toString());
        order.setPrice(totalProductPrice);
        order.setTotalamount(totalAmount);
        order.setQuantity(totalQuantity);
        myOrderFacade.edit(order);  

        
        wallet.setBalance(wallet.getBalance() - totalAmount);
        walletFacade.edit(wallet);
        session.setAttribute("wallet", wallet);

        
        session.removeAttribute("cartItems");

        List<Cart> customerCartItems = cartFacade.findByCustomer(customer);
        for (Cart cart : customerCartItems) {
            cartFacade.remove(cart);
        }

        response.sendRedirect("CustomerTrack"); 
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
