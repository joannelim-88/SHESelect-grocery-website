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
import model.Wallet;
import model.WalletFacade;

@WebServlet(name = "CustomerSetting", urlPatterns = {"/CustomerSetting"})
public class CustomerSetting extends HttpServlet {

    @EJB
    private WalletFacade walletFacade;

    @EJB
    private CustomerFacade customerFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        MyUser currentUser = (MyUser) session.getAttribute("user");

        if (currentUser == null) {
            response.getWriter().write("ERROR:User not logged in");
            response.sendRedirect("login.jsp");
            return;
        }

        String username = currentUser.getId();
        Customer customer = customerFacade.findByUsername(username);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                double amount = Double.parseDouble(request.getParameter("amount"));

                if (amount > 0) {
                    Wallet wallet = walletFacade.findByCustomerId(customer.getCustomerid());

                    if (wallet == null) {
                        wallet = new Wallet();
                        wallet.setCustomer(customer);
                        wallet.setBalance(amount);
                        walletFacade.create(wallet);
                    } else {
                        wallet.setBalance(wallet.getBalance() + amount);
                        walletFacade.edit(wallet);
                    }
                    
                    double updatedAmount = wallet.getBalance(); // call the updated amount
                    
                    response.getWriter().write("SUCCESS: RM " + updatedAmount);
                } else {
                    response.getWriter().write("ERROR: Invalid amount");
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("ERROR: Invalid input");
            }
        } else {
            response.getWriter().write("ERROR: Invalid request method");
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        MyUser currentUser = (MyUser) session.getAttribute("user");

        if (currentUser == null) {
            response.getWriter().write("ERROR:User not logged in");
            return;
        }

        String username = currentUser.getId();
        Customer customer = customerFacade.findByUsername(username);
        Wallet wallet = walletFacade.findByCustomerId(customer.getCustomerid());

        if (wallet != null) {
            response.getWriter().write(String.valueOf(wallet.getBalance()));
        } else {
            response.getWriter().write("0.00");
        }
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
