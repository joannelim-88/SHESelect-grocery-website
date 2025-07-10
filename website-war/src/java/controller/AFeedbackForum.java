
package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Customer;
import model.CustomerFacade;
import model.Feedback;
import model.FeedbackFacade;
import model.MyUser;
import model.OrderItem;
import model.OrderItemFacade;
import org.json.JSONObject;


@WebServlet(name = "AFeedbackForum", urlPatterns = {"/AFeedbackForum"})
public class AFeedbackForum extends HttpServlet {

    @EJB
    private CustomerFacade customerFacade;

    @EJB
    private FeedbackFacade feedbackFacade;

    @EJB
    private OrderItemFacade orderItemFacade;
    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if ("addFeedback".equals(action)) {
            
            String detail = request.getParameter("feedbackDetail");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String itemId = request.getParameter("itemId");
            String replyToId = request.getParameter("replyToId");

            HttpSession session = request.getSession();
            MyUser a = (MyUser) session.getAttribute("user");

            if (a == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String customer = a.getId();
            Customer customerid = customerFacade.find(customer);

            Feedback newFeedback = new Feedback();
            newFeedback.setFeedbackdetail(detail);
            newFeedback.setRating(rating);

            OrderItem selectedItem = orderItemFacade.find(Long.parseLong(itemId));
            if (selectedItem == null) {
                
                request.setAttribute("error", "Selected item not found.");
                request.getRequestDispatcher("adminfeedbackforum.jsp").forward(request, response);
                return;
            }
            newFeedback.setItem(selectedItem);
            newFeedback.setOrder(selectedItem.getOrder());
            newFeedback.setItem(orderItemFacade.find(Long.parseLong(itemId)));
            newFeedback.setCustomer(customerid);

            
            if (replyToId != null && !replyToId.isEmpty()) {
                
                Long parentId = Long.parseLong(replyToId);
                Feedback parent = feedbackFacade.find(parentId);
                newFeedback.setReplyTo(parent);

                
                newFeedback.setItem(parent.getItem());
                newFeedback.setOrder(parent.getOrder());
            } else {
                
                if (selectedItem == null) {
                    request.setAttribute("error", "Selected item not found.");
                    request.getRequestDispatcher("adminfeedbackforum.jsp").forward(request, response);
                    return;
                }
                newFeedback.setItem(selectedItem);
                newFeedback.setOrder(selectedItem.getOrder());
            }

            
            String sentiment = callSentimentServlet(detail);
            newFeedback.setSentiment(sentiment);

            feedbackFacade.create(newFeedback);

            
            response.sendRedirect("AFeedbackForum");
            return;
        }

        
        String ratingFilter = request.getParameter("ratingFilter");
        String sentimentFilter = request.getParameter("sentimentFilter");

        List<Feedback> allFeedback = feedbackFacade.findAll(); 

        
        for (Feedback fb : allFeedback) {
            if (fb.getSentiment() == null || fb.getSentiment().trim().isEmpty()) {
                String combinedText = "";

                if (fb.getFeedbacktitle() != null) {
                    combinedText += fb.getFeedbacktitle() + " ";
                }
                combinedText += fb.getFeedbackdetail();

                String predictedSentiment = callSentimentServlet(combinedText);

                fb.setSentiment(predictedSentiment);
                feedbackFacade.edit(fb);
            }
        }
        List<Feedback> filtered = new ArrayList<Feedback>();

        for (Feedback fb : allFeedback) {
            boolean matchRating = true;
            boolean matchSentiment = true;

            if (ratingFilter != null && !ratingFilter.isEmpty()) {
                matchRating = String.valueOf(fb.getRating()).equals(ratingFilter);
            }

            if (sentimentFilter != null && !sentimentFilter.isEmpty()) {
                matchSentiment = sentimentFilter.equalsIgnoreCase(fb.getSentiment());
            }

            if (matchRating && matchSentiment) {
                filtered.add(fb);
            }
        }

        request.setAttribute("feedbackList", filtered);
        List<OrderItem> itemList = orderItemFacade.findAll(); 
        request.setAttribute("itemList", itemList);
        request.getRequestDispatcher("adminfeedbackforum.jsp").forward(request, response);

    }

    public static String callSentimentServlet(String feedbackText) {
        try {
            URL url = new URL("http://localhost:5000/analyse_sentiment");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonInput = "{\"text\":\"" + feedbackText.replace("\"", "\\\"") + "\"}";
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInput.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line.trim());
                }
            }

            JSONObject jsonResponse = new JSONObject(response.toString());
            return jsonResponse.getString("sentiment");

        } catch (Exception e) {
            e.printStackTrace();
            return "neutral";
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
