package controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import model.Customer;
import model.CustomerFacade;
import model.Feedback;
import model.FeedbackFacade;
import model.MyOrder;
import model.MyOrderFacade;
import model.MyUser;
import model.OrderItem;

@WebServlet(name = "CustomerReview", urlPatterns = {"/CustomerReview"})
public class CustomerReview extends HttpServlet {

    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private FeedbackFacade feedbackFacade;

    @EJB
    private MyOrderFacade myOrderFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser a = (MyUser) session.getAttribute("user");

        if (a == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String customer = a.getId();
        Customer customerid = customerFacade.find(customer);

        String method = request.getMethod();
        String orderId = request.getParameter("orderId");

        if (orderId == null) {
            response.sendRedirect("CustomerTrack");
            return;
        }

        Long orderid = Long.parseLong(orderId);
        MyOrder order = myOrderFacade.find(orderid);
        List<OrderItem> items = order.getOrderItems();

        
        System.out.println("Order ID: " + orderid);
        System.out.println("Items in the order: ");
        for (OrderItem item : items) {
            System.out.println("Product Name: " + item.getProductname() + ", Quantity: " + item.getQuantity() + ", Amount: " + item.getTotalamount());
        }

        for (OrderItem item : items) {
            if (item.getProduct() != null && item.getProduct().getProductname() != null) {
                System.out.println("Product Name: " + item.getProduct().getProductname());
            } else {
                System.out.println("Product Name is null for Item ID " + item.getId());
            }
        }

        if ("POST".equalsIgnoreCase(method)) {
            String action = request.getParameter("action");
            if (action != null && action.contains("_")) {
                String[] parts = action.split("_");
                String actionType = parts[0];
                Long itemId = Long.parseLong(parts[1]);

                String title = request.getParameter("title_" + itemId);
                String rateStr = request.getParameter("rate_" + itemId);
                String detail = request.getParameter("detail_" + itemId);

                int rating = 0;
                try {
                    rating = Integer.parseInt(rateStr);
                } catch (NumberFormatException e) {
                    rating = 0; 
                }

                Feedback existing = feedbackFacade.findByOrderItem(itemId);

                OrderItem selectedItem = null;
                for (OrderItem i : items) {
                    if (i.getId().equals(itemId)) {
                        selectedItem = i;
                        break;
                    }
                }

                if (selectedItem != null) {
                    switch (actionType) {
                        case "add":
                            if (existing == null && title != null && detail != null && rating > 0) {
                                Feedback newFeedback = new Feedback();
                                newFeedback.setFeedbacktitle(title);
                                newFeedback.setFeedbackdetail(detail);
                                newFeedback.setRating(rating);
                                newFeedback.setOrder(order);
                                newFeedback.setCustomer(customerid);
                                newFeedback.setItem(selectedItem);
                                feedbackFacade.create(newFeedback);
                            }
                            break;

                        case "edit":
                            if (existing != null && title != null && detail != null && rating > 0) {
                                existing.setFeedbacktitle(title);
                                existing.setFeedbackdetail(detail);
                                existing.setRating(rating);
                                feedbackFacade.edit(existing);
                            }
                            break;

                        case "remove":
                            if (existing != null) {
                                try {
                                    Long feedbackId = existing.getFeedbackid();
                                    if (feedbackId == null) {
                                        request.setAttribute("error", "Invalid feedback entry.");
                                        break;
                                    }

                                    
                                    List<Feedback> replies = feedbackFacade.findReplies(feedbackId);

                                    
                                    if (replies != null && !replies.isEmpty()) {
                                        request.setAttribute("error", "You cannot delete this feedback because it has replies.");
                                        System.out.println("Found " + replies.size() + " replies for feedback ID: " + feedbackId);
                                    } else {
                                        
                                        feedbackFacade.remove(existing);
                                        System.out.println("Feedback ID: " + feedbackId + " has no replies, deletion allowed.");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace(); 
                                    request.setAttribute("error", "An unexpected error occurred while removing feedback.");
                                }
                            }
                            break;

                    }
                }
            }
        }

        
        Map<Long, Feedback> reviewsMap = new HashMap<>();
        boolean allItemsReviewed = true;

        for (OrderItem item : items) {
            Feedback review = feedbackFacade.findOriginalByOrderItem(item.getId());
            if (review != null) {
                item.setStatus("reviewed");
                reviewsMap.put(item.getId(), review);
            } else {
                item.setStatus("pending review");
                allItemsReviewed = false; 
            }
        }

        
        if (allItemsReviewed) {
            order.setOrderstatus("reviewed");
        } else {
            order.setOrderstatus("pending review");
        }
        myOrderFacade.edit(order); 

        
        System.out.println("Reviews map size: " + reviewsMap.size());
        for (Long itemId : reviewsMap.keySet()) {
            Feedback review = reviewsMap.get(itemId);
            System.out.println("Feedback for Item ID " + itemId + ": Title = " + review.getFeedbacktitle() + ", Rating = " + review.getRating());
        }

        request.setAttribute("orderId", orderid);
        request.setAttribute("orderStatus", order.getOrderstatus());
        request.setAttribute("items", items);
        request.setAttribute("reviews", reviewsMap);
        request.getRequestDispatcher("customerreview.jsp").forward(request, response);
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
