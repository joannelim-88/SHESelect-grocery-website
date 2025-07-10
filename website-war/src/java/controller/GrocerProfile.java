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
import model.Grocer;
import model.GrocerFacade;
import model.MyUser;
import model.MyUserFacade;

@WebServlet(name = "GrocerProfile", urlPatterns = {"/GrocerProfile"})
public class GrocerProfile extends HttpServlet {

    @EJB
    private GrocerFacade grocerFacade;

    @EJB
    private MyUserFacade myUserFacade;

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
                
                Grocer g = grocerFacade.find(username);

                if (g != null) {
                    request.setAttribute("grocer", g);
                    request.setAttribute("user", a);
                }

                
                request.getRequestDispatcher("grocerprofile.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                
                Grocer g = grocerFacade.find(username); 

                if (g != null) {
                    try {
                        
                        String pass = request.getParameter("password");
                        String name = request.getParameter("name");
                        String age = request.getParameter("age");
                        String email = request.getParameter("email");
                        String phonenumber = request.getParameter("phoneno");
                        String address = request.getParameter("address");

                        
                        if (name == null || pass == null || age == null || email == null || phonenumber == null || address == null) {
                            request.setAttribute("error", "All fields are required.");
                            request.getRequestDispatcher("grocerprofile.jsp").forward(request, response);
                            return;
                        }

                        
                        int phoneno = Integer.parseInt(phonenumber);
                        int Age = Integer.parseInt(age);
                        if (Age < 0) {
                            throw new Exception();
                        }

                        
                        g.setPassword(pass);
                        a.setPassword(pass);
                        g.setName(name);
                        g.setAge(Age);
                        g.setEmail(email);
                        g.setPhoneno(phoneno);
                        g.setAddress(address);

                        
                        myUserFacade.edit(a);    
                        grocerFacade.edit(g);    

                        
                        request.setAttribute("success", "Profile updated.");

                        Grocer updatedG = grocerFacade.find(username);
                        MyUser updatedUser = myUserFacade.find(username);

                        request.setAttribute("grocer", updatedG);
                        request.setAttribute("user", updatedUser);

                        response.sendRedirect("GrocerProfile?action=view");

                    } catch (Exception e) {
                        request.setAttribute("error", "Failed to update profile.");
                        request.getRequestDispatcher("grocerprofile.jsp").forward(request, response);
                    }

                }

            }

        } catch (Exception e) {

            request.setAttribute("error", "Failed to process your profile.");
            request.getRequestDispatcher("grocerprofile.jsp").forward(request, response);
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
