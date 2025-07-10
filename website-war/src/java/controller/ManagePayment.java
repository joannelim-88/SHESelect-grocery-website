package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MyOrder;
import model.MyOrderFacade;
import model.OrderItem;
import model.OrderItemFacade;
import model.Product;
import model.ProductFacade;

@WebServlet(name = "ManagePayment", urlPatterns = {"/ManagePayment"})
public class ManagePayment extends HttpServlet {

    @EJB
    private ProductFacade productFacade;

    @EJB
    private OrderItemFacade orderItemFacade;

    @EJB
    private MyOrderFacade myOrderFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        try {
            if ("sendPayment".equals(action)) {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                BigDecimal submittedAmount = new BigDecimal(request.getParameter("amount"));

                MyOrder order = myOrderFacade.find(orderId);
                if (order == null) {
                    request.setAttribute("error", "Order not found.");
                } else {
                    BigDecimal expectedAmount = BigDecimal.ZERO;
                    List<OrderItem> items = orderItemFacade.findByOrderId(orderId); 

                    for (OrderItem item : items) {
                        Product product = item.getProduct();
                        BigDecimal price = BigDecimal.valueOf(product.getPrice());
                        int quantity = item.getQuantity();
                        expectedAmount = expectedAmount.add(price.multiply(BigDecimal.valueOf(quantity)));
                    }

                    if (expectedAmount.compareTo(submittedAmount) == 0) {
                        order.setOrderstatus("pending review");
                        myOrderFacade.edit(order);
                        request.setAttribute("message", "Payment successful. Order marked as Pending Review.");
                    } else {
                        request.setAttribute("error", "Submitted amount does not match expected (RM" + expectedAmount + ").");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
        }

        
        List<MyOrder> doneOrders = myOrderFacade.findByOrderStatus("done");
        
        for (MyOrder doneOrder : doneOrders) {
            List<OrderItem> items = orderItemFacade.findByOrderId(doneOrder.getOrderid());
            doneOrder.setOrderItems(items); 
        }
        request.setAttribute("done", doneOrders);
        request.getRequestDispatcher("managepayment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
