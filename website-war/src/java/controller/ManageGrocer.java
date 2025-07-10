package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Grocer;
import model.GrocerFacade;

@WebServlet(name = "ManageGrocer", urlPatterns = {"/ManageGrocer"})
public class ManageGrocer extends HttpServlet {

    @EJB
    private GrocerFacade grocerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getMethod(); 

        if (method.equalsIgnoreCase("POST")) {
            String grocerid = request.getParameter("grocerid");
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

                Grocer grocer = grocerFacade.find(grocerid);

                if (grocer != null) {
                    grocer.setName(name);
                    grocer.setAge(Age);
                    grocer.setEmail(email);
                    grocer.setPhoneno(phone);
                    grocer.setAddress(address);
                    grocerFacade.edit(grocer);

                    request.getSession().setAttribute("message", "Grocer updated successfully!");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Grocer not found.");
                    request.getSession().setAttribute("messageType", "error");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Error. Failed to edit.");
                request.getSession().setAttribute("messageType", "error");
            }

            
            response.sendRedirect("ManageGrocer");
            return;
        }

        
        List<Grocer> grocers = grocerFacade.findAll();
        request.setAttribute("grocerList", grocers);

        
        String message = (String) request.getSession().getAttribute("message");
        String messageType = (String) request.getSession().getAttribute("messageType");
        request.getSession().removeAttribute("message");
        request.getSession().removeAttribute("messageType");

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);

        request.getRequestDispatcher("managegrocerinfo.jsp").forward(request, response);

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
