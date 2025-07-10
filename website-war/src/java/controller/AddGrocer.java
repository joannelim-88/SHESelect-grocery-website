package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
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
import model.Store;

@WebServlet(name = "AddGrocer", urlPatterns = {"/AddGrocer"})
public class AddGrocer extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private GrocerFacade grocerFacade;
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String age = request.getParameter("age");
        String email = request.getParameter("email");
        String phoneno = request.getParameter("phoneno");
        String address = request.getParameter("address");

        try (PrintWriter out = response.getWriter()) {
            try {
                
                if (password == null || password.trim().isEmpty()
                        || name == null || name.trim().isEmpty()
                        || age == null || age.trim().isEmpty()
                        || email == null || email.trim().isEmpty()
                        || phoneno == null || phoneno.trim().isEmpty()
                        || address == null || address.trim().isEmpty()) {
                    throw new Exception("Please fill in all required fields correctly.");
                }

                
                if ((password == null || password.trim().isEmpty())
                        && (name == null || name.trim().isEmpty())
                        && (age == null || age.trim().isEmpty())
                        && (email == null || email.trim().isEmpty())
                        && (phoneno == null || phoneno.trim().isEmpty())
                        && (address == null || address.trim().isEmpty())) {
                    throw new Exception("Please fill in all required fields correctly.");
                }

                password = password.trim();

                
                if (!password.matches("^(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
                    throw new Exception("Password must be at least 8 characters long, with uppercase and lowercase letters.");
                }

                
                int ag;
                int phone;

                try {
                    ag = Integer.parseInt(age.trim());
                    if (ag <= 0) {
                        throw new Exception("Age must be greater than 0.");
                    }

                    phone = Integer.parseInt(phoneno.trim());
                } catch (NumberFormatException ex) {
                    throw new Exception("Age and phone number must be valid numbers.");
                }

                if (id == null || id.trim().isEmpty()) {
                    id = "GROCER-" + UUID.randomUUID().toString().substring(0, 4);
                }

                List<Store> emptyStores = new ArrayList<>();
                myUserFacade.create(new MyUser(id, password, "grocer")); //create new user
                Grocer grocer = new Grocer(id, password, name, ag, email, phone, address, emptyStores);
                grocerFacade.create(grocer);

                request.getRequestDispatcher("RegisterGrocer").include(request, response);
                out.println("<br><br><br><span style='color:green;'>Grocer successfully registered.</span>");
            } catch (Exception e) {
                e.printStackTrace();
                request.getRequestDispatcher("addgrocer.jsp").include(request, response);
                out.println("<br><br><br><span style='color:red;'>Error: " + e.getMessage() + "</span>");
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
