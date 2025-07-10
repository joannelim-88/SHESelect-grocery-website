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
import model.Store;
import model.StoreFacade;

@WebServlet(name = "AddProduct", urlPatterns = {"/AddProduct"})
@MultipartConfig
public class AddProduct extends HttpServlet {

    @EJB
    private StoreFacade storeFacade;

    @EJB
    private ProductFacade productFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("productname");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        String stock = request.getParameter("stock");

        String storeId = request.getParameter("storeId");
        Store store = storeFacade.find(storeId); 

        
        Part filePart = request.getPart("productImage");
        String imagePath = saveFile(filePart);

        
        double Price = Double.parseDouble(price);
        int Stock = Integer.parseInt(stock);

        Product product = new Product();
        product.setProductname(name);
        product.setDescription(description);
        product.setCategory(category);
        product.setPrice(Price);
        product.setStockquantity(Stock);
        product.setImagepath(imagePath);
        product.setStore(store);

        productFacade.create(product);

        response.sendRedirect("ManageProduct?storeId=" + storeId);
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
