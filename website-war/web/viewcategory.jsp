<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SHESelect | Online Grocery Place</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <%-- Web site CSS layout design --%>
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

            .product-cards {
                display: flex;
                flex-wrap: wrap;
                gap: 50px;
                justify-content: center;
                margin-top: 20px;
            }

            
            .item-card {
                background-color: white;
                border-radius: 10px;
                width: 100%;
                max-width: 200px;
                padding: 15px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                display: flex;
                flex-direction: column;
                align-items: center;
                transition: transform 0.2s ease;
            }

            .item-card:hover {
                transform: scale(1.03);
            }

            
            @media (max-width: 768px) {
                .product-cards {
                    justify-content: center;
                }
            }

            .item-card button {
                margin-top: 10px;
                background-color: #2ecc71;
                border: none;
                cursor: pointer;
                color: white;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.3s ease, transform 0.2s ease;
                font-size: 1.4em;
            }

            .item-card button:hover {
                background-color: #27ae60;
                transform: scale(1.1);
            }

            .item-icon {
                width: 100px;
                height: 80px;
                vertical-align: middle;
                margin-right: 8px;
                border-radius: 4px;
            }
            .item-card-link {
                text-decoration: none;
                color: inherit;
                display: block;
                width: 220px;
            }

            @media (max-width: 768px) {
                .item-card-link {
                    width: 100%;
                }
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

            <h1>${category}</h1>

            <c:if test="${not empty recommendedProducts}">
                <h2>Suggested for you</h2>
                <div class="product-cards">
                    <c:forEach var="product" items="${recommendedProducts}">
                        <a href="ViewProduct?productid=${product.productid}&storeid=${product.store.storeid}" class="item-card-link">
                            <div class="item-card">
                                <img src="${product.imagepath}" alt="${product.productname}" class="item-icon">
                                <p>
                                    <strong>${product.productname}</strong>
                                </p>

                                <p style="color: green;">RM ${product.price}</p>

                                <p style="font-size: 0.9em; color: #555;">Store: <strong>${product.store.storename}</strong></p>

                                <form action="CartServlet" method="post">
                                    <input type="hidden" name="productId" value="${product.productid}">
                                    <input type="hidden" name="storeId" value="${product.store.storeid}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" title="Add to Cart">
                                        <i class="fas fa-cart-plus fa-lg"></i>
                                    </button>
                                </form>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>


            <h2>All products</h2>
            <c:if test="${not empty products}">
                <div class="product-cards">
                    <c:forEach var="product" items="${products}">
                        <a href="ViewProduct?productid=${product.productid}&storeid=${product.store.storeid}" class="item-card-link">
                            <div class="item-card">
                                <img src="${product.imagepath}" alt="${product.productname}" class="item-icon">
                                <p>
                                    <strong>${product.productname}</strong>
                                </p>

                                <p style="color: green;">RM ${product.price}</p>

                                <p style="font-size: 0.9em; color: #555;">Store: <strong>${product.store.storename}</strong></p>

                                <form action="CartServlet" method="post">
                                    <input type="hidden" name="productId" value="${product.productid}">
                                    <input type="hidden" name="storeId" value="${product.store.storeid}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" title="Add to Cart">
                                        <i class="fas fa-cart-plus fa-lg"></i>
                                    </button>
                                </form>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty products}">
                <p>No products available for this category.</p>
            </c:if>
        </div>
    </body>
</html>
