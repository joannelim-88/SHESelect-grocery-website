<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

            .sidebar {
                width: 220px;
                background-color: #FFA84B;
                padding: 20px;
                color: white;
                display: flex;
                flex-direction: column;
            }

            .sidebar h3 {
                margin-bottom: 10px;
            }

            .sidebar a {
                text-decoration: none;
                color: black;
                display: block;
                margin: 8px 0;
                padding: 8px;
                background-color: #fff;
                border-radius: 4px;
                text-align: center;
            }

            .sidebar a:hover {
                background-color: #ffdeaf;
            }

            .main-content {
                flex: 1;
                padding: 20px;
            }

            .store-header {
                display: flex;
                justify-content: space-between;
                background-color: #FFA84B;
                padding: 20px;
                color: black;
                border-radius: 6px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;

            }

            .items-section {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .item-card {
                background-color: white;
                border-radius: 10px;
                width: 180px;
                padding: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .item-card:hover {
                transform: scale(1.03);
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


            .status-open {
                color: green;
                font-weight: bold;
            }

            .store-info p {
                margin: 4px 0;
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

            .store-layout {
                display: flex;
                align-items: flex-start;
                gap: 20px;
            }

            .sidebar {
                width: 280px; 
                background-color: #ffaa4d;
                padding: 15px;
                border-radius: 6px;
                flex-shrink: 0;
            }

            .main-content {
                flex: 1;
            }

            .top-description {
                background-color: #ffaa4d;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
            }

            .product-cards {
                display: flex;
                flex-wrap: wrap;
                gap: 50px;
            }

            .store-icon {
                width: 70px;
                height: 70px;
                margin-right: 20px;
            }

            .store-header-center {
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-bottom: 20px;
            }

            .sidebar a.active {
                font-weight: bold;
                color: #d35400;
                text-decoration: underline;
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
        
        <div class="main-content">
            <a href="CustomerHome" class="back-button">Back</a>
            <br><br><br>
            
            <div class="store-layout">

                
                <div class="sidebar">
                    <div class="store-header-center">
                        <img src="images/store icon.png" alt="Store Icon" class="store-icon">
                        <h2>${store.storename}</h2>
                    </div>

                    <h3>Categories</h3>
                    <a href="ViewStore?storeid=${store.storeid}&category=All" class="${selectedCategory == 'All' ? 'active' : ''}">All</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Promotion" class="${selectedCategory == 'Promotion' ? 'active' : ''}">Promotion</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Beverages" class="${selectedCategory == 'Beverages' ? 'active' : ''}">Beverages</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Fresh Food" class="${selectedCategory == 'Fresh Food' ? 'active' : ''}">Fresh Food</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Dry Food" class="${selectedCategory == 'Dry Food' ? 'active' : ''}">Dry Food</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Household" class="${selectedCategory == 'Household' ? 'active' : ''}">Household</a>
                    <a href="ViewStore?storeid=${store.storeid}&category=Beauty and Health" class="${selectedCategory == 'Beauty and Health' ? 'active' : ''}">Beauty and Health</a>

                </div>

                
                <div class="main-content">

                    
                    <div class="top-description">
                        <div class="store-info">
                            <p><strong>Description:</strong> ${store.description}</p>
                        </div>
                        <div class="store-info">
                            <p><strong>Location:</strong> ${store.address}</p>
                            <p><strong>Status:</strong> <span class="status-open">${store.status}</span></p>
                        </div>
                    </div>

                    
                    <c:if test="${fn:toLowerCase(selectedCategory) == 'all'}">
                        <h2>For you</h2> 
                        <div class="product-cards">
                            <c:forEach var="product" items="${recommendedProducts}">
                                <a href="ViewProduct?productid=${product.productid}&storeid=${product.store.storeid}" class="item-card-link">
                                    <div class="item-card">
                                        <div><img src="${product.imagepath}" alt="${product.productname}" class="item-icon"></div>
                                        <p><strong>${product.productname}</strong></p>
                                        <p style="color: green;">RM ${product.price}</p>
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

                        <br><br>
                        <h2>All products</h2>
                    </c:if>

                    <!-- Product Items -->
                    <div class="product-cards">
                        <c:forEach var="product" items="${products}">
                            <c:choose>
                                <c:when test="${fn:toLowerCase(selectedCategory) == 'all'}">
                                    
                                    <a href="ViewProduct?productid=${product.productid}&storeid=${product.store.storeid}" class="item-card-link">
                                        <div class="item-card">
                                            <div><img src="${product.imagepath}" alt="${product.productname}" class="item-icon"></i></div>
                                            <p>
                                                <strong>${product.productname}</strong>
                                            </p>
                                            <p style="color: green;">RM ${product.price}</p>
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
                                </c:when>
                                <c:when test="${not empty product.category and fn:toLowerCase(fn:trim(product.category)) == fn:toLowerCase(selectedCategory)}">
                                    
                                    <a href="ViewProduct?productid=${product.productid}&storeid=${product.store.storeid}" class="item-card-link">
                                        <div class="item-card">
                                            <div><img src="${product.imagepath}" alt="${product.productname}" class="item-icon"></div>
                                            <p>
                                                <strong>${product.productname}</strong>
                                            </p>
                                            <p style="color: green;">RM ${product.price}</p>
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
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </div>

                </div>
            </div>
        </div>
    </body>
</html>
