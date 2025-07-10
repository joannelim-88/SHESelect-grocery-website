package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.UUID;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.Product;
import model.ProductFacade;

@WebServlet(name = "EditProduct", urlPatterns = {"/EditProduct"})
@MultipartConfig
public class EditProduct extends HttpServlet {

    @EJB
    private ProductFacade productFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getMethod();

        if (method.equalsIgnoreCase("GET")) {
            String productId = request.getParameter("productId");
            String storeId = request.getParameter("storeId");
            System.out.println("Received productId: " + productId + " and storeId: " + storeId);

            if (productId != null && !productId.isEmpty()) {
                Product selectedProduct = productFacade.findByProductAndStore(productId, storeId);

                if (selectedProduct != null) {
                    request.setAttribute("selectedProduct", selectedProduct);
                    request.getRequestDispatcher("editproduct.jsp").forward(request, response);
                    return; 
                } else {
                    System.out.println("No product found with id: " + productId);
                }
            } else {
                System.out.println("No productId parameter received.");
            }

            response.sendRedirect("ManageProduct");
            System.out.println("Redirecting to ManageProduct as the product was not found.");

        } else if (method.equalsIgnoreCase("POST")) {
            
            String productIdParam = request.getParameter("productId");

            if (productIdParam != null && !productIdParam.isEmpty()) {

                Product product = productFacade.find(productIdParam);

                if (product != null) {
                    String name = request.getParameter("productname");
                    String description = request.getParameter("description");
                    String category = request.getParameter("category");
                    String price = request.getParameter("price");
                    String stock = request.getParameter("stock");

                    
                    Part filePart = request.getPart("productImage");
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                    try {
                        double Price = Double.parseDouble(price);
                        int Stock = Integer.parseInt(stock);

                        product.setProductname(name);
                        product.setDescription(description);
                        product.setCategory(category);
                        product.setPrice(Price);
                        product.setStockquantity(Stock);

                        if (fileName != null && !fileName.isEmpty()) {
                            
                            String oldImagePath = product.getImagepath(); 
                            if (oldImagePath != null) {
                                File oldFile = new File("C:\\Users\\joenl\\Downloads\\Year 3 FYP\\FYP_SHESelectwebsite\\FYP_SHESelectwebsite-war\\web\\" + oldImagePath);
                                if (oldFile.exists()) {
                                    oldFile.delete();
                                    System.out.println("Old image deleted: " + oldFile.getAbsolutePath());
                                }
                            }

                            
                            String savedPath = saveFile(filePart);
                            product.setImagepath(savedPath);
                        }

                        productFacade.edit(product);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Invalid input for price or stock.");
                        request.setAttribute("selectedProduct", product);
                        request.getRequestDispatcher("editproduct.jsp").forward(request, response);
                        return;
                    }
                }
            }

            response.sendRedirect("ManageProduct");
        }
    }

    private String saveFile(Part filePart) throws IOException {
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + extension; 

        String uploadDir = "C:\\Users\\joenl\\Downloads\\Year 3 FYP\\FYP_SHESelectwebsite\\FYP_SHESelectwebsite-war\\web\\images";
        File uploads = new File(uploadDir);
        if (!uploads.exists()) {
            uploads.mkdirs();
        }

        File file = new File(uploads, uniqueFileName);
        try (InputStream inputStream = filePart.getInputStream();
                OutputStream outputStream = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }

        System.out.println("Image saved to: " + file.getAbsolutePath());
        return "images/" + uniqueFileName;
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
