package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerFacade;

@WebServlet(name = "ManageCustomer", urlPatterns = {"/ManageCustomer"})
public class ManageCustomer extends HttpServlet {

    @EJB
    private CustomerFacade customerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String method = request.getMethod();
        
        if (method.equalsIgnoreCase("POST")) {
            String customerid = request.getParameter("customerid");
            String name = request.getParameter("name");
            String age = request.getParameter("age");
            String email = request.getParameter("email");
            String phoneno = request.getParameter("phoneno");
            String address = request.getParameter("address");

            try {
                
                int Age = Integer.parseInt(age);

                if (Age < 0) {
                    throw new Exception("Invalid age.");
                }

                int phone = Integer.parseInt(phoneno);

                
                Customer customer = customerFacade.find(customerid);

                if (customer != null) {
                    customer.setName(name);
                    customer.setAge(Age);
                    customer.setEmail(email);
                    customer.setPhoneno(phone);  
                    customer.setAddress(address);
                    customerFacade.edit(customer);

                    request.getSession().setAttribute("message", "Customer updated successfully!");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Customer not found.");
                    request.getSession().setAttribute("messageType", "error");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Error. Failed to edit.");
                request.getSession().setAttribute("messageType", "error");
            }

            
            response.sendRedirect("ManageCustomer");
            return; 
        }

        
        List<Customer> customers = customerFacade.findAll();
        request.setAttribute("customerList", customers);

        
        String message = (String) request.getSession().getAttribute("message");
        String messageType = (String) request.getSession().getAttribute("messageType");
        request.getSession().removeAttribute("message");
        request.getSession().removeAttribute("messageType");

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);

        request.getRequestDispatcher("managecustomerinfo.jsp").forward(request, response);

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
