<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Product | SHESelect</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <!--Web site CSS layout design -->
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

            
            .product-form {
                max-width: 500px;
                margin: auto;
            }
            .form-row {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
            }
            input[type="text"],
            select,
            input[type="number"] {
                width: 100%;
                padding: 8px;
            }
            .stock-control {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .stock-control button {
                padding: 5px 10px;
            }

            .delete-button {
                background-color: red;
                color: white;
                padding: 10px 25px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 10px;
                display: inline-block;
                cursor: pointer;
                transition: background-color 0.3s ease;
                text-decoration: none;
            }

            .delete-button:hover {
                background-color: darkred;
            }

            .update-button {
                background-color: greenyellow;
                color: white;
                padding: 10px 25px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 10px;
                display: inline-block;
                cursor: pointer;
                transition: background-color 0.3s ease;
                text-decoration: none;
            }

            .update-button:hover {
                background-color: green;
            }
        </style>
        <script>
            function changeStock(delta) {
                var stockInput = document.getElementById('stock');
                var current = parseInt(stockInput.value);
                if (!isNaN(current)) {
                    var newVal = current + delta;
                    if (newVal >= 1) {
                        stockInput.value = newVal;
                    }
                }
            }

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
        </script>
    </head>
    <body>
        <%-- Home page Header --%> 
        <header>
            <img src="images/home page icon.png" alt="Logo"> 
            <div class="header-icons">
                <a href="GrocerProfile"><img src="images/profile icon1.png" alt="Profile"></a> 
                <img src="images/menu icon.png" alt="Menu" id="menu-icon" onclick="toggleMenu()"> 
            </div>

            <div id="side-menu">
                <ul>
                    <li>
                        <a href="CustomerOrders">
                            <img src="images/cart icon.png"> Customer orders
                        </a>
                    </li>
                    <li>
                        <a href="GFeedbackForum">
                            <img src="images/star icon.png"> Feedback forum
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
            <a href="ManageProduct" class="back-button">Back</a>
            <br><br><br>
            <h1>Manage Product</h1>
            <h3>Edit Product</h3>
            <%
                Product selectedProduct = (Product) request.getAttribute("selectedProduct");
            %>

            <div class="product-form">
                <form action="EditProduct" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="${selectedProduct.productid != null ? selectedProduct.productid : ''}">
                    <input type="hidden" name="storeId" value="${storeId}">

                    <div class="form-row">
                        <label>Product Image:</label>
                        <input type="file" name="productImage" accept="image/*">
                        <% if (selectedProduct != null && selectedProduct.getImagepath() != null && !selectedProduct.getImagepath().isEmpty()) {%>
                        <div style="margin-top: 10px;">
                            <img src="${pageContext.request.contextPath}/<%= selectedProduct.getImagepath()%>" width="100" alt="Current Image">
                            <p><small><%= selectedProduct.getImagepath().substring(selectedProduct.getImagepath().lastIndexOf("/") + 1)%></small></p>
                        </div>
                        <% }%>
                    </div>

                    <div class="form-row">
                        <label>Product Name:</label>
                        <input type="text" name="productname" required value="<%= selectedProduct != null ? selectedProduct.getProductname() : ""%>">
                    </div>

                    <div class="form-row">
                        <label>Description:</label>
                        <input type="text" name="description" value="<%= selectedProduct != null ? selectedProduct.getDescription() : ""%>">
                    </div>

                    <div class="form-row">
                        <label>Category:</label>
                        <select name="category" required>
                            <option value="">Select / Add New</option>
                            <option value="Promotion" <%= selectedProduct != null && "Promotion".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Promotion</option>
                            <option value="Fresh Food" <%= selectedProduct != null && "Fresh Food".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Fresh Food</option>
                            <option value="Dry Food" <%= selectedProduct != null && "Dry Food".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Dry Food</option>
                            <option value="Beverages" <%= selectedProduct != null && "Beverages".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Beverages</option>
                            <option value="Household" <%= selectedProduct != null && "Household".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Household</option>
                            <option value="Beauty and Health" <%= selectedProduct != null && "Beauty and Health".equals(selectedProduct.getCategory()) ? "selected" : ""%>>Beauty and Health</option>
                        </select>
                    </div>

                    <div class="form-row">
                        <label>Price (RM):</label>
                        <input type="text" name="price" required value="<%= selectedProduct != null ? selectedProduct.getPrice() : ""%>">
                    </div>

                    <div class="form-row">
                        <label>Stock:</label>
                        <div class="stock-control">
                            <button type="button" onclick="changeStock(-1)">-</button>
                            <input type="number" id="stock" name="stock" value="<%= selectedProduct != null ? selectedProduct.getStockquantity() : 0%>" min="1" required>
                            <button type="button" onclick="changeStock(1)">+</button>
                        </div>
                    </div>

                    <div class="form-row">
                        <input type="submit" class="update-button" value="Update Product">
                    </div>
                </form>
                <br>
                <!-- Delete Product Button -->
                <form id="deleteProductForm" action="DeleteProduct" method="POST" onsubmit="return confirm('Are you sure you want to delete this product?')">
                    <input type="hidden" name="productId" value="${selectedProduct.productid != null ? selectedProduct.productid : ''}">
                    <button type="submit" class="delete-button">Delete Product</button>
                </form>

                <script>
                    
                    document.getElementById('deleteProductForm').addEventListener('submit', function (event) {
                        event.preventDefault(); 

                        var productId = document.querySelector('[name="productId"]').value;

                        
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', 'DeleteProduct', true); 
                        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

                        
                        xhr.onload = function () {
                            if (xhr.status === 200) {
                                var response = xhr.responseText;
                                if (response === "success") {
                                    alert("Product successfully deleted!");
                                    
                                    window.location.href = "ManageProduct";
                                } else {
                                    alert("Failed to delete the product. Please try again.");
                                }
                            } else {
                                alert("Error occurred while deleting the product.");
                            }
                        };

                        
                        xhr.send('productId=' + encodeURIComponent(productId));
                    });
                </script>

            </div>
        </div>
    </body>
</html>
