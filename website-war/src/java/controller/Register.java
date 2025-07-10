package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Admin;
import model.AdminFacade;
import model.Customer;
import model.CustomerFacade;
import model.MyUser;
import model.MyUserFacade;

@WebServlet(name = "Register", urlPatterns = {"/Register"})
public class Register extends HttpServlet {


    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private MyUserFacade myUserFacade;
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String age = request.getParameter("age");
        String email = request.getParameter("email");
        String phoneno = request.getParameter("phoneno");
        String address = request.getParameter("address");

        
        System.out.println("Entered password: " + password);
        System.out.println("Password matches regex: " + password.matches("^(?=.*[a-z])(?=.*[A-Z]).{8,}$"));

       
        boolean usernameInvalid = false;
        boolean passwordInvalid = false;
        boolean nameInvalid = false;
        boolean ageInvalid = false;
        boolean emailInvalid = false;
        boolean phonenoInvalid = false;
        boolean addressInvalid = false;

        try (PrintWriter out = response.getWriter()) {
            try {
                MyUser found = myUserFacade.find(username);
                if (found != null) {
                    usernameInvalid = true;
                    throw new Exception("username already taken.");
                }

                
                password = password.trim();

                
                if (!password.matches("^(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
                    passwordInvalid = true;
                    throw new Exception("Password must be at least 8 characters long, with uppercase and lowercase letters.");
                }

               
                if (username.isEmpty()) {
                    usernameInvalid = true;
                }
                if (name.isEmpty()) {
                    nameInvalid = true;
                }
                if (age.isEmpty() || !age.matches("\\d+")) {
                    ageInvalid = true;
                }
                if (email.isEmpty()) {
                    emailInvalid = true;
                }
                if (phoneno.isEmpty() || !phoneno.matches("\\d{10}")) { 
                    phonenoInvalid = true;
                }
                if (address.isEmpty()) {
                    addressInvalid = true;
                }

                
                int phone = Integer.parseInt(phoneno); 
                int ag = Integer.parseInt(age); 
                if (ag < 0) { 
                    ageInvalid = true;
                    throw new Exception();
                }

                myUserFacade.create(new MyUser(username, password, "customer")); 
                customerFacade.create(new Customer(username, password, name, ag, email, phone, address));
    
                request.setAttribute("registrationSuccess", "Congratulations " + username + ", registration done!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                
            } catch (Exception e) {
                
                request.setAttribute("usernameInvalid", usernameInvalid);
                request.setAttribute("passwordInvalid", passwordInvalid);
                request.setAttribute("nameInvalid", nameInvalid);
                request.setAttribute("ageInvalid", ageInvalid);
                request.setAttribute("emailInvalid", emailInvalid);
                request.setAttribute("phonenoInvalid", phonenoInvalid);
                request.setAttribute("addressInvalid", addressInvalid);
                request.setAttribute("errorMessage", e.getMessage());

                
                request.setAttribute("username", username);
                request.setAttribute("name", name);
                request.setAttribute("age", age);
                request.setAttribute("email", email);
                request.setAttribute("phoneno", phoneno);
                request.setAttribute("address", address);
                
                request.setAttribute("registrationFailed", "Sorry " + username + ", failed to register.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
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
