package controller;

import java.io.IOException;
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
import model.MyOrder;
import model.MyOrderFacade;
import model.MyUser;
import model.OrderItem;
import model.OrderItemFacade;

@WebServlet(name = "CustomerTrack", urlPatterns = {"/CustomerTrack"})
public class CustomerTrack extends HttpServlet {

    @EJB
    private MyOrderFacade myOrderFacade;

    @EJB
    private OrderItemFacade orderItemFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        MyUser user = (MyUser) session.getAttribute("user");

        String customerId = user.getId();
        System.out.println("user.getId(): " + customerId);

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String method = request.getMethod();

        if ("POST".equalsIgnoreCase(method)) {
            String action = request.getParameter("action");

            if ("Cancel Order".equals(action)) {
                String orderIdParam = request.getParameter("orderId"); 
                Long orderId = Long.parseLong(orderIdParam);
                orderItemFacade.deleteByOrderId(orderId);

                MyOrder order = myOrderFacade.find(orderId);
                if (order != null) {
                    myOrderFacade.remove(order);
                }

                response.sendRedirect("CustomerTrack");
                return;

            } else if ("Review".equals(action)) {
                String orderIdParam = request.getParameter("orderId");
                Long orderId = Long.parseLong(orderIdParam);
                
                response.sendRedirect("CustomerReview?orderId=" + orderId);
                return;
            }
        }

        
        List<MyOrder> customerOrders = myOrderFacade.findByCustomerId(customerId);
        System.out.println("Found " + customerOrders.size() + " orders for customer ID: " + customerId);

        
        Map<Long, List<OrderItem>> orderItemsMap = new HashMap<>();
        for (MyOrder order : customerOrders) {
            List<OrderItem> items = orderItemFacade.findByOrderId(order.getOrderid());
            orderItemsMap.put(order.getOrderid(), items);
        }

        request.setAttribute("customerOrders", customerOrders);
        request.setAttribute("orderItems", orderItemsMap);
        request.getRequestDispatcher("customertrack.jsp").forward(request, response);

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
