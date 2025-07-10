<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

            .main-layout {
                display: flex;
            }

            .category-menu {
                display: block;
                flex-wrap: wrap; 
                gap: 10px; 
                padding: 20px;
                background-color: #f4f4f4;
                border-right: 1px solid #ccc;
                max-height: 400px;
                overflow-y: auto;
            }

            .category-item {
                padding: 8px 16px;
                border-radius: 5px;
                cursor: pointer;
                background-color: #fff;
                transition: background-color 0.2s, color 0.2s;
                flex: 0 0 auto; 
            }

            .category-item:hover,
            .category-item.active {
                background-color: lightpink;
                font-weight: bold;
                color: white;
            }


            .product-grid {
                flex: 1;
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                padding: 20px;
            }

            @media (max-width: 768px) {
                .product-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            .product-card { 
                border: 1px solid #ddd; padding: 15px; text-align: center; 
            }
            .product-price { 
                font-weight: bold; color: green; 
            }
            .add-product-btn { 
                margin-top: 20px; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer; 
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

            function filterProducts(category) {
                const selectedStoreId = document.getElementById("storeSelect").value;


                document.querySelectorAll('.category-item').forEach(item => {
                    item.classList.remove('active');
                });
                event.target.classList.add('active');

                // Filter products by category and store
                const cards = document.querySelectorAll('.product-card');
                cards.forEach(card => {
                    const cardCategory = card.getAttribute('data-category');
                    const cardStoreId = card.getAttribute('data-storeid');

                    const showCard = (category === 'All' || cardCategory === category) &&
                            (selectedStoreId === "" || cardStoreId === selectedStoreId);

                    card.style.display = showCard ? 'block' : 'none';
                });
            }

            //Run initial filter 
            window.addEventListener("DOMContentLoaded", function () {
                filterProducts('All');
            });
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
            <a href="grocerhome.jsp" class="back-button">Back</a>
            <br><br><br>
            <h1>Manage Product</h1>
            <!-- Store Selection -->
            <form method="get" action="ManageProduct">
                <label for="storeSelect">Select Store:</label>
                <select name="storeId" id="storeSelect" onchange="this.form.submit()">
                    <option value="">-- No store selected --</option>
                    <c:forEach var="store" items="${stores}">
                        <option value="${store.storeid}" ${store.storeid == param.storeId ? 'selected' : ''}>
                            ${store.storename}
                        </option>
                    </c:forEach>
                </select>
                <input type="hidden" name="category" value="${param.category}" />
            </form>
            <br>

            <!-- Category Menu -->
            <div class="main-layout">
                <div class="category-menu">
                    <a href="ManageProduct?storeId=${param.storeId}&category=All" class="category-item ${param.category == 'All' ? 'active' : ''}">All</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Promotion" class="category-item ${param.category == 'Promotion' ? 'active' : ''}">Promotion</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Beverages" class="category-item ${param.category == 'Beverages' ? 'active' : ''}">Beverages</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Fresh Food" class="category-item ${param.category == 'Fresh Food' ? 'active' : ''}">Fresh Food</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Dry Food" class="category-item ${param.category == 'Dry Food' ? 'active' : ''}">Dry Food</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Household" class="category-item ${param.category == 'Household' ? 'active' : ''}">Household</a>
                    <a href="ManageProduct?storeId=${param.storeId}&category=Beauty and Health" class="category-item ${param.category == 'Beauty and Health' ? 'active' : ''}">Beauty and Health</a>
                </div>
            </div>


            <!-- Product cards -->
            <div class="product-grid" id="productGrid">
                <c:forEach var="product" items="${products}">
                    <c:if test="${product.store.storeid == param.storeId}">
                        <div class="product-card" 
                             data-category="${product.category}" 
                             data-storeid="${product.store.storeid}">
                            <img src="${pageContext.request.contextPath}/${product.imagepath}" alt="${product.productname}" style="width:100%; height:150px; object-fit:cover; border-radius:8px;">
                            <h3>${product.productname}</h3>
                            <p class="product-price">RM${product.price}</p>
                            <p>${product.category}</p>
                            <a href="${pageContext.request.contextPath}/EditProduct?productId=${product.productid}&storeId=${product.store.storeid}">Edit</a>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <!-- Add Product Button -->
            <c:choose>
                <c:when test="${not empty param.storeId}">
                    <p>
                        <a href="addproduct.jsp?storeId=${param.storeId}">
                            <button type="button" class="add-product-btn">Add Product</button>
                        </a>
                    </p>
                </c:when>
                <c:otherwise>
                    <p>
                        <button type="button" class="add-product-btn" onclick="alert('Please select a store before adding a product.')" style="opacity: 0.6; cursor: not-allowed;" disabled>
                            Add Product
                        </button>
                    </p>
                </c:otherwise>
            </c:choose>

        </div>
    </body>
</html>
