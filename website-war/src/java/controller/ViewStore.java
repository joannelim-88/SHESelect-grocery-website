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
import model.MyUser;
import model.Product;
import model.ProductFacade;
import model.Store;
import model.StoreFacade;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "ViewStore", urlPatterns = {"/ViewStore"})
public class ViewStore extends HttpServlet {

    @EJB
    private ProductFacade productFacade;

    @EJB
    private StoreFacade storeFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String storeid = request.getParameter("storeid");
        String selectedCategory = request.getParameter("category");
        if (selectedCategory == null || selectedCategory.isEmpty()) {
            selectedCategory = "All";
        }

        
        System.out.println("Store ID: " + storeid);
        System.out.println("Selected Category: " + selectedCategory);

        Store selectedStore = storeFacade.find(storeid);

        
        List<Product> products;
        if ("All".equals(selectedCategory)) {
            products = productFacade.findByStoreId(storeid);  
        } else {
            products = productFacade.findByStoreIdAndCategory(storeid, selectedCategory);  
        }

        
        System.out.println("Number of products: " + (products != null ? products.size() : 0));

        // --- Recommendation Section ---
        List<Product> recommendedProducts = new ArrayList<>();
        try {
            MyUser userId = (MyUser) request.getSession().getAttribute("user");

            if (userId != null) {
                String user = userId.getId();
                System.out.println("DEBUG: userId = " + user);

                
                List<Product> storeProducts = productFacade.findByStoreId(storeid); 
                List<String> productIds = new ArrayList<>();

                for (Product product : storeProducts) {
                    productIds.add(product.getProductid());
                }

                
                JSONObject jsonPayload = new JSONObject();
                jsonPayload.put("user_id", user);
                jsonPayload.put("product_ids", new JSONArray(productIds));

                
                URL url = new URL("http://127.0.0.1:5000/get-recommendations");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setDoOutput(true);
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");

                String inputJson = jsonPayload.toString();
                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = inputJson.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }

                StringBuilder responseText = new StringBuilder();
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        responseText.append(line.trim());
                    }
                }

                JSONObject json = new JSONObject(responseText.toString());
                JSONArray idArray = json.getJSONArray("recommended_product_ids");
                System.out.println("DEBUG: Recommended Product IDs: " + idArray.toString());

                
                for (int i = 0; i < idArray.length(); i++) {
                    String recProductId = idArray.getString(i);
                    Product recProduct = productFacade.find(recProductId);

                    if (recProduct != null) {
                        recommendedProducts.add(recProduct);
                    }
                }
            }
        } catch (Exception ex) {
            System.out.println("Error fetching recommendations: " + ex.getMessage());
        }

        request.setAttribute("recommendedProducts", recommendedProducts);

        request.setAttribute("store", selectedStore);
        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", selectedCategory);

        request.getRequestDispatcher("viewstore.jsp").forward(request, response);
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
