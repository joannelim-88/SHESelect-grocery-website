package controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
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
import model.ProductFacade;
import model.Store;
import model.StoreFacade;

@WebServlet(name = "CustomerOrders", urlPatterns = {"/CustomerOrders"})
public class CustomerOrders extends HttpServlet {

    @EJB
    private OrderItemFacade orderItemFacade;

    @EJB
    private MyOrderFacade myOrderFacade;

    @EJB
    private ProductFacade productFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        MyUser user = (MyUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String method = request.getMethod(); 
        String grocer = user.getId(); 

        String selectedStoreId = request.getParameter("storeid");

        if ("POST".equalsIgnoreCase(method)) {
            
            String orderIdParam = request.getParameter("orderId");
            String newStatus = request.getParameter("newStatus");

            if (orderIdParam != null && newStatus != null && !newStatus.trim().isEmpty()) {
                try {
                    Long orderId = Long.parseLong(orderIdParam);
                    MyOrder order = myOrderFacade.find(orderId);
                    if (order != null) {
                        List<OrderItem> items = orderItemFacade.findByOrderId(orderId);
                        
                        for (OrderItem item : items) {
                            if (item.getProduct().getStore().getStoreid().equals(selectedStoreId)) {
                                item.setStatus(newStatus);
                                orderItemFacade.edit(item);
                            }
                        }

                        
                        boolean allDone = true;
                        for (OrderItem item : items) {
                            if (!"done".equalsIgnoreCase(item.getStatus())) {
                                allDone = false;
                                break;
                            }
                        }

                        
                        if (allDone) {
                            order.setOrderstatus("done");
                        } else {
                            order.setOrderstatus("pending");
                        }
                        myOrderFacade.edit(order);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            
            response.sendRedirect("CustomerOrders?storeid=" + selectedStoreId);
            return;
        }

        
        List<Store> grocerStores = storeFacade.findStoresByGrocer(grocer);
        request.setAttribute("stores", grocerStores);

        
        if (selectedStoreId != null && !selectedStoreId.isEmpty()) {
            try {
                String storeId = selectedStoreId;
                List<MyOrder> allOrders = myOrderFacade.findAll();
                Set<MyOrder> matchedOrders = new HashSet<>();

                for (MyOrder order : allOrders) {
                    
                    if (!"pending".equalsIgnoreCase(order.getOrderstatus())) {
                        continue;
                    }

                    List<OrderItem> orderItems = orderItemFacade.findByOrderId(order.getOrderid());
                    for (OrderItem item : orderItems) {
                        if (item.getProduct().getStore().getStoreid().equals(storeId)) {
                            matchedOrders.add(order);
                            break;
                        }
                    }
                }

                request.setAttribute("orders", matchedOrders);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("customerorders.jsp");
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
