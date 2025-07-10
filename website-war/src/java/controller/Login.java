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
import model.MyUser;
import model.MyUserFacade;

@WebServlet(name = "Login", urlPatterns = {"/Login"})
public class Login extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (PrintWriter out = response.getWriter()) {
            try {
                MyUser found = myUserFacade.find(username);
                if (found == null) { 
                    throw new Exception();
                }
                
                if (found.getPassword() == null || !found.getPassword().equals(password)) {
                    throw new Exception();
                }
                
                
                HttpSession a = request.getSession();
                a.setAttribute("user", found);
                
                
                String role = found.getRole();
                switch (role) {
                    case "admin":
                        request.getRequestDispatcher("adminhome.jsp").include(request,response);
                        out.println("<br><br><br>Hello " + username + ", welcome to SHESelect Online Grocery Store!");

                        break;
                    case "customer":
                        response.sendRedirect("CustomerHome");
                        out.println("<br><br><br>Hello " + username + ", welcome to SHESelect Online Grocery Store!");

                        break;
                    case "grocer":
                        request.getRequestDispatcher("grocerhome.jsp").include(request,response);
                        out.println("<br><br><br>Hello " + username + ", welcome to SHESelect Online Grocery Store!");

                        break;
                }
            } catch (Exception e) {
                request.setAttribute("loginError", "Sorry " + username + ", failed to login.");
                request.getRequestDispatcher("login.jsp").include(request, response);
                
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
