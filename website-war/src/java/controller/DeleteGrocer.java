
package controller;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Grocer;
import model.GrocerFacade;
import model.MyUser;
import model.MyUserFacade;


@WebServlet(name = "DeleteGrocer", urlPatterns = {"/DeleteGrocer"})
public class DeleteGrocer extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private GrocerFacade grocerFacade;

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String grocerid = request.getParameter("grocerid");

        try {
            Grocer grocer = grocerFacade.find(grocerid);

            if (grocerid == null || grocerid.isEmpty()) {
                
                request.setAttribute("message","Grocer ID is missing or invalid.");
                request.setAttribute("messageType", "error");
                response.sendRedirect("ManageGrocer");
                return;
            }

            if (grocer != null) {

                String username = grocer.getGrocerid();

                if (username != null && !username.isEmpty()) {
                    
                    MyUser user = myUserFacade.find(username);

                    if (user != null) {
                        
                        myUserFacade.remove(user);
                    } else {
                        request.setAttribute("message", "No user found for this grocer.");
                        request.setAttribute("messageType", "error");
                        response.sendRedirect("ManageGrocer");
                        return;
                    }
                } else {
                    request.setAttribute("message", "Grocer has no associated user.");
                    request.setAttribute("messageType", "error");
                    response.sendRedirect("ManageGrocer");
                    return;
                }

                
                grocerFacade.remove(grocer);

                request.setAttribute("message","Successfully deleted grocer.");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Grocer not found.");
                request.setAttribute("messageType", "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message","Error. Failed to process.");
            request.setAttribute("messageType", "error");
        }

        response.sendRedirect("ManageGrocer");
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
