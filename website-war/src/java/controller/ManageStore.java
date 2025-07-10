package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.MyUser;
import model.MyUserFacade;
import model.Store;
import model.StoreFacade;

@WebServlet(name = "ManageStore", urlPatterns = {"/ManageStore"})
public class ManageStore extends HttpServlet {

    @EJB
    private MyUserFacade myUserFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        MyUser user = (MyUser) session.getAttribute("user");

        if (user != null && "grocer".equals(user.getRole())) {
            
            List<Store> storeList = storeFacade.findStoresByGrocer(user.getId());

            request.setAttribute("storeList", storeList);
        } else {
            request.setAttribute("storeList", null);
        }

        request.getRequestDispatcher("managestore.jsp").forward(request, response);
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
