package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Customer;
import model.CustomerFacade;
import model.MyUser;
import model.MyUserFacade;

@WebServlet(name = "Profile", urlPatterns = {"/Profile"})
public class Profile extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private CustomerFacade customerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

       String action = request.getParameter("action");

        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            MyUser a = (MyUser) session.getAttribute("user");

            if (a == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String username = a.getId(); 

            if (action == null || action.equals("view")) {
                
                Customer c = customerFacade.find(username);

                if (c != null) {
                    request.setAttribute("customer", c);
                    request.setAttribute("user", a);
                }

                
                request.getRequestDispatcher("profile.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                
                Customer c = customerFacade.find(username); 

                if (c != null) {
                    try {
                        
                        String pass = request.getParameter("password");
                        String name = request.getParameter("name");
                        String age = request.getParameter("age");
                        String email = request.getParameter("email");
                        String phonenumber = request.getParameter("phoneno");
                        String address = request.getParameter("address");

                        
                        if (name == null || pass == null || age == null || email == null || phonenumber == null || address == null) {
                            request.setAttribute("error", "All fields are required.");
                            request.getRequestDispatcher("profile.jsp").forward(request, response);
                            return;
                        }

                       
                        int phoneno = Integer.parseInt(phonenumber);
                        int Age = Integer.parseInt(age);
                        if (Age < 0) {
                            throw new Exception();
                        }

                        
                        c.setPassword(pass);
                        a.setPassword(pass);
                        c.setName(name);
                        c.setAge(Age);
                        c.setEmail(email);
                        c.setPhoneno(phoneno);
                        c.setAddress(address);

                        
                        myUserFacade.edit(a);    
                        customerFacade.edit(c);    

                        
                        request.setAttribute("success", "Profile updated.");

                        Customer updatedC = customerFacade.find(username);
                        MyUser updatedUser = myUserFacade.find(username);

                        request.setAttribute("customer", updatedC);
                        request.setAttribute("user", updatedUser);
                        
                        response.sendRedirect("Profile?action=view");
                        

                    } catch (Exception e) {
                        request.setAttribute("error", "Failed to update profile.");
                        request.getRequestDispatcher("profile.jsp").forward(request, response);
                    }

                }

            }

        } catch (Exception e) {

            request.setAttribute("error", "Failed to process your profile.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }

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
