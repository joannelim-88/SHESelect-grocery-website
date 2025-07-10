<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SHESelect | Online Grocery Place</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <%-- Website CSS layout design --%>
        <style>

            body {
                background-color: #e0ffe0; 
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
            }

            header {
                background-color: #f8c8d3; 
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 30px; 
                width: 100vw; 
                box-sizing: border-box;
                position: relative;
                z-index: 1;
            }
            header img {
                height: 55px; 
            }
            .header-icons {
                display: flex;
                align-items: center;
                gap: 25px; 
            }
            .header-icons img {
                width: 50px; 
                height: 50px;
                object-fit: contain;
                cursor: pointer;
            }


            @media (max-width: 600px) {
                header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .header-icons {
                    margin-top: 10px;
                }
            }
            @media (max-width: 768px) {
                .carousel {
                    height: 300px; 
                }
            }

            #side-menu {
                position: absolute;
                top: 60px; 
                right: 10px;
                width: 270px;
                background-color: #eeeeee;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                border-radius: 10px;
                display: none;
                z-index: 999;
                transition: all 0.3s ease;
                padding: 12px;
            }

            #side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            #side-menu ul li {
                padding: 12px;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                font-size: 15px;
                border-bottom: 0.7px solid #ccc;
            }

            .logout-btn {
                display: inline-block;
                text-align: center;
                background-color: orange;
                color: white;
                border-radius: 20px;
                padding: 8px;
                text-decoration: none;
            }

            .back-button {
                background-color: orange;
                color: white;
                padding: 10px 25px;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                border-radius: 10px;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .back-button:hover {
                background-color: #ffb84d; 
            }

            .content-wrapper { 
                padding: 20px;
            }

            .product-view{
                display: flex; 
                gap: 30px; 
                align-items: flex-start; 
                flex-wrap: wrap;
            }

            .product-image {
                width: 300px;
                height: 200px;
                object-fit: cover;
            }

            .product-details h2 {
                margin-top: 0;
            }

            .add-cart-btn {
                font-size: 15px;       
                padding: 15px 30px;     
                background-color: #2ecc71;
                color: white;
                width: 200px;
                border: none;
                border-radius: 10px;
                cursor: pointer;       
            }

            .add-cart-btn:hover {
                background-color: #27ae60;
                transform: scale(1.05);
                transition: 0.2s ease;
            }

            .recommendation-section {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .recommend-card {
                padding: 10px;
                background: #eee;
                border-radius: 10px;
                text-align: center;
                width: 130px;
            }

            .recommend-card img {
                width: 80px;
                height: 80px;
                object-fit: cover;
            }
            .quantity-control {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .quantity-control input {
                width: 40px;
                text-align: center;
            }

        </style>
        <script>
            function toggleMenu() {
                const menu = document.getElementById("side-menu");
                menu.style.display = (menu.style.display === "block") ? "none" : "block";
            }

            function logout() {
                const confirmed = confirm("Are you sure you want to logout?");
                if (confirmed) {
                    window.location.href = "Logout";
                }
            }

            function changeQuantity(delta) {
                var quantityInput = document.getElementById('quantity');
                var current = parseInt(quantityInput.value);
                if (!isNaN(current)) {
                    var newVal = current + delta;
                    if (newVal >= 1) {
                        quantityInput.value = newVal;
                    }
                }
            }

        </script>
    </head>
    <body>
        <%-- Home page Header --%> 
        <header>
            <img src="images/home page icon.png" alt="Logo"> 
            <div class="header-icons">
                <a href="cart.jsp"><img src="images/cart icon.png" alt="Cart"></a> 
                <a href="Profile"><img src="images/profile icon1.png" alt="Profile"></a> 
                <img src="images/menu icon.png" alt="Menu" id="menu-icon" onclick="toggleMenu()"> 
            </div>

            <div id="side-menu">
                <ul>
                    <li>
                        <a href="CustomerTrack">
                            <img src="images/cart icon.png"> My Orders
                        </a>
                    </li>
                    <li>
                        <a href="FeedbackForum">
                            <img src="images/star icon.png"> Feedback forum
                        </a>
                    </li>
                    <li>
                        <a href="customersetting.jsp">
                            <img src="images/setting icon.png"> Settings
                        </a>
                    </li>
                    <li>
                        <button onclick="logout()" class="logout-btn">Logout</button>
                    </li>
                </ul>
            </div>
        </header>
        <br> 
        <div class="content-wrapper">
            <a href="CustomerHome" class="back-button">Back</a>
            <br><br>
            <%
                String currentProductId = request.getParameter("productid");
                String currentStoreId = request.getParameter("storeid");

                String productName = (String) request.getAttribute("productname");
                String productCategory = (String) request.getAttribute("category");
                String productDescription = (String) request.getAttribute("description");
                Double productPrice = (Double) request.getAttribute("price");
                Integer productStock = (Integer) request.getAttribute("stockquantity");
                String productImage = (String) request.getAttribute("imagepath");

                List<Product> allProducts = (List<Product>) request.getAttribute("products");
            %>
            <h1>View Product</h1>
            <h2><%= productCategory%></h2>
            <div class="product-view">
                <!-- Product Image -->
                <div>
                    <img src="<%= productImage != null ? productImage : "images/placeholder.png"%>" alt="Product Image" width="250" height="200">
                </div>

                <!-- Product Details -->
                <div class="product-details">
                    <h2><%= productName%></h2>
                    <p><strong>Description:</strong><br><%= productDescription%></p>
                    <p><strong>Price:</strong> <span style="color:green;">RM <%= productPrice%></span></p>
                    <p><strong>In Stock:</strong> <%= productStock%></p>

                    <label><strong>Quantity:</strong></label>
                    <div class="quantity-control">
                        <button type="button" onclick="changeQuantity(-1)" disabled>-</button>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" required readonly>
                        <button type="button" onclick="changeQuantity(1)" disabled>+</button>
                    </div>
                    <br><br>
                    <form action="CartServlet" method="post">
                        <input type="hidden" name="productId" value="<%= currentProductId%>">
                        <input type="hidden" name="storeId" value="<%= currentStoreId%>">
                        <input type="hidden" id="formQuantity" name="quantity" value="1">
                        <button type="submit" class="add-cart-btn">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                </div>
            </div>

            <br><br>
            <h3>You May Also Like</h3>
            <div class="recommendation-section">

                <div class="recommendation-section">
                    <%
                        List<Product> recommendedProducts = (List<Product>) request.getAttribute("recommendedProducts");

                        int count = 0;
                        if (recommendedProducts != null) {
                            for (Product prod : recommendedProducts) {
                                if (count >= 5) {
                                    break;
                                }
                    %>
                    <div class="recommend-card">
                        <img src="<%= prod.getImagepath() != null ? prod.getImagepath() : "images/placeholder.png"%>" alt="Product">
                        <p><%= prod.getProductname()%></p>
                        <p style="color: green;">RM <%= prod.getPrice()%></p>

                        <form action="ViewProduct" method="get">
                            <input type="hidden" name="productid" value="<%= prod.getProductid()%>">
                            <% if (prod.getStore() != null) {%>
                            <input type="hidden" name="storeid" value="<%= prod.getStore().getStoreid()%>">
                            <% } %>
                            <button type="submit" class="view-product-btn"><i class="fas fa-eye"></i> View Product</button>
                        </form>
                    </div>
                    <%
                            count++;
                        }
                    } else {
                    %>
                    <p>No recommendations available at the moment.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </body>
</html>
