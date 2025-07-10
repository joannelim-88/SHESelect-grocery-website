package controller;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerFacade;
import model.MyUser;
import model.MyUserFacade;

@WebServlet(name = "DeleteCustomer", urlPatterns = {"/DeleteCustomer"})
public class DeleteCustomer extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private CustomerFacade customerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String customerid = request.getParameter("customerid");

        try {
            Customer customer = customerFacade.find(customerid);

            if (customerid == null || customerid.isEmpty()) {
                
                request.setAttribute("message", "Customer ID is missing or invalid.");
                request.setAttribute("messageType", "error");
                response.sendRedirect("ManageCustomer");
                return;
            }

            if (customer != null) {

                String username = customer.getCustomerid();

                if (username != null && !username.isEmpty()) {
                    
                    MyUser user = myUserFacade.find(username);

                    if (user != null) {
                        
                        myUserFacade.remove(user);
                    } else {
                        request.setAttribute("message", "No user found for this customer.");
                        request.setAttribute("messageType", "error");
                        response.sendRedirect("ManageCustomer");
                        return;
                    }
                } else {
                    request.setAttribute("message", "Customer has no associated user.");
                    request.setAttribute("messageType", "error");
                    response.sendRedirect("ManageCustomer");
                    return;
                }

                
                customerFacade.remove(customer);

                request.setAttribute("message","Successfully deleted customer.");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Customer not found.");
                request.setAttribute("messageType", "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error. Failed to process.");
            request.setAttribute("messageType", "error");
        }

        response.sendRedirect("ManageCustomer");
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
