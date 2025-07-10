<%@page import="model.Customer"%>
<%@page import="model.MyUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@page import="model.Store"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

           
            .carousel {
                position: relative;
                width: 100%;
                max-width: 1200px; 
                margin: 20px auto; 
                overflow: hidden;
                height: 500px; 
                background-color: #f5f5f5;
            }

            .carousel img {
                position: absolute;
                width: 100%;
                height: 100%;
                object-fit: contain;
                display: none;
                background-color: #f5f5f5;
                transition: opacity 0.5s ease;
                opacity: 0;
            }

            .carousel img.active {
                display: block;
                opacity: 1;
            }

            .carousel-controls {
                display: flex;
                justify-content: center;
                gap: 40px;
                margin-top: 10px;
            }

            .carousel-button {
                background-color: rgba(248, 200, 211, 0.8);
                border: none;
                cursor: pointer;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .carousel-button img {
                width: 24px;
                height: 24px;
            }

            .carousel-dots {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: center;
            }

            .dot {
                height: 12px;
                width: 12px;
                background-color: #e0e0e0;
                border-radius: 50%;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .dot.active {
                background-color: #f8c8d3;
            }

            
            .button-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 15px;
                margin-top: 30px;
            }

            .button-container a {
                display: inline-flex;
                font-weight: bold;
                align-items: center;
                gap: 10px;
                padding: 18px 28px; 
                background-color: #2e7d32;
                color: white;
                text-decoration: none;
                font-size: 20px; 
                border-radius: 8px;
                transition: background-color 0.3s ease;
            }

            .button-container a:hover {
                background-color: #f8c8d3;
            }

            .button-container i {
                font-size: 22px; 
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

            .category-container {
                text-align: center;
                font-family: Arial, sans-serif;
                padding: 20px;
            }

            .category-title {
                font-size: 35px;
                margin-bottom: 20px;
                font-weight: bolder;
                text-align: left;
            }

            .categories {
                display: flex;
                justify-content: center;
                gap: 90px;
                flex-wrap: wrap;
            }

            .category-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-decoration: none;
                color: darkcyan;
                font-weight: bolder;
                font-size: 20px;
            }

            .category-icon {
                background-color: pink;
                border-radius: 50%;
                width: 100px;
                height: 100px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 45px;
                font-weight: bolder;
                margin-bottom: 20px;
            }

            .store-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px; 
                margin-top: 20px;
            }

            .store-item {
                text-decoration: none;
            }

            .store-button {
                padding: 30px 40px; 
                background-color: #ffb6c1;
                border: none;
                border-radius: 15px; 
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                min-width: 250px; 
                justify-content: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
            }

            .store-button:hover {
                background-color: #ff8fa3; 
                transform: translateY(-2px); 
            }

            .store-icon {
                font-size: 24px;
                margin-right: 10px;
                color: #fff;
            }

            .store-name {
                font-size: 18px;
                font-weight: bold;
                color: #fff; 
            }

            .store-location {
                font-size: 14px;
                color: #000; 
                opacity: 0.9;
            }

            .store-text {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }

            .store-button {
                display: inline-flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                width: 180px;               
                height: 120px;              
                padding: 8px;
                margin: 10px;
                border: 1px solid #ccc;
                border-radius: 12px;
                background-color: #ffe6f0;  
                color: #000;
                text-decoration: none;
                transition: background-color 0.3s, transform 0.2s;
                box-shadow: 1px 1px 4px rgba(0,0,0,0.1);
            }

            .store-button:hover {
                background-color: #ffd6e7;  
                transform: translateY(-2px);
            }

            
            #cart-popup {
                display: none;
                position: fixed;
                top: 0;
                right: 0;
                width: 400px;
                height: 100%;
                background: #fff;
                box-shadow: -3px 0 10px rgba(0,0,0,0.1);
                z-index: 9999;
                overflow-y: auto;
                transition: transform 0.3s ease-in-out;
                transform: translateX(100%); 
            }

            
            #cart-popup.show-cart {
                display: block;
                transform: translateX(0); 
            }

            .cart-popup-content {
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .close-btn {
                font-size: 40px;
                cursor: pointer;
                align-self: flex-end;
            }

            .empty-cart {
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
            }

            .empty-cart-image {
                width: 90px;
                length: 90px;
                margin-bottom: 20px;
            }

            .cart-buttons {
                margin-top: 20px;
            }

            .btn-go-cart {
                display: inline-block;
                background-color: #00aaff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin-bottom: 10px;
            }

            .btn-continue-shopping {
                background: none;
                border: none;
                color: #00aaff;
                font-size: 14px;
                cursor: pointer;
            }

            .cart-items-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .cart-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 10px;
                border-bottom: 1px solid #eee;
                font-size: 16px;
                font-weight: 500;
            }

            .cart-item .item-name {
                flex: 1;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .cart-item .item-quantity {
                color: green;
                font-weight: bold;
                margin-left: 10px;
                white-space: nowrap;
            }
        </style>
        <%-- Function for Carousel and Side Menu --%>
        <script>
            
            document.addEventListener('DOMContentLoaded', function () {
                
                const images = document.querySelectorAll('.carousel img');
                const dots = document.querySelectorAll('.dot');
                const prevButton = document.querySelector('.prev-button');
                const nextButton = document.querySelector('.next-button');

                let currentIndex = 0;
                let intervalId;
                const intervalDuration = 5000;

                function showImage(index) {
                    images.forEach((img, i) => {
                        img.classList.remove('active');
                        if (i === index) {
                            img.classList.add('active');
                        }
                    });

                    dots.forEach((dot, i) => {
                        dot.classList.toggle('active', i === index);
                    });
                }

                function nextImage() {
                    currentIndex = (currentIndex + 1) % images.length;
                    showImage(currentIndex);
                    resetInterval();
                }

                function prevImage() {
                    currentIndex = (currentIndex - 1 + images.length) % images.length;
                    showImage(currentIndex);
                    resetInterval();
                }

                function startInterval() {
                    intervalId = setInterval(nextImage, intervalDuration);
                }

                function resetInterval() {
                    clearInterval(intervalId);
                    startInterval();
                }

                
                dots.forEach((dot, i) => {
                    dot.addEventListener('click', () => {
                        currentIndex = i;
                        showImage(currentIndex);
                        resetInterval();
                    });
                });

                showImage(currentIndex);
                startInterval();

                nextButton?.addEventListener('click', nextImage);
                        prevButton?.addEventListener('click', prevImage);

                const carousel = document.querySelector('.carousel');
                carousel.addEventListener('mouseenter', () => clearInterval(intervalId));
                carousel.addEventListener('mouseleave', startInterval);
            });


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

            
            function toggleCart() {
                var cartPopup = document.getElementById('cart-popup');
                cartPopup.classList.toggle('show-cart');
            }

            
            function checkout() {
                window.location.href = "checkout.jsp"; 
            }

        </script>
    </head>
    <body>
        <%-- Home page Header --%> 
        <header>
            <img src="images/home page icon.png" alt="Logo"> 
            <div class="header-icons">
                <!-- Pop up cart menu -->
                <a href="javascript:void(0)" onclick="toggleCart()">
                    <img src="images/cart icon.png" alt="Cart">
                </a> 
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
            <%
                List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
            %>
            <!-- Cart Pop-up -->
            <div id="cart-popup" class="cart-popup">
                <div class="cart-popup-content">
                    <span class="close-btn" onclick="toggleCart()">&times;</span>

                    <%
                        if (cartItems == null || cartItems.isEmpty()) {
                    %>
                    <!-- Show Empty Cart Message -->
                    <div class="empty-cart">
                        <img src="images/empty cart.png" alt="Empty Cart" class="empty-cart-image">
                        <h3>Your cart is empty</h3>
                        <p>Add items to your cart and place order here.</p>

                        <div class="cart-buttons">
                            <a href="CartServlet" class="btn-go-cart">Go to Cart</a>
                            <button onclick="toggleCart()" class="btn-continue-shopping">Continue Shopping</button>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <!-- Show Cart Items -->
                    <h2><br>Your Cart</h2>
                    <ul class="cart-items-list">
                        <%
                            for (Cart item : cartItems) {
                        %>
                        <li class="cart-item">
                            <span class="item-name"><%= item.getProduct().getProductname()%></span>
                            <span class="item-quantity">Qty: <%= item.getQuantity()%></span>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                    <div class="cart-buttons">
                        <a href="CartServlet" class="btn-go-cart">Go to Cart</a>
                        <button onclick="toggleCart()" class="btn-continue-shopping">Continue Shopping</button>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </header>

        <%-- Home Page Carousel--%>
        <div class="carousel" id="carousel">
            <img src="images/Carousel img 1.png" class="active" alt="Image 1">
            <img src="images/Carousel img 2.png" alt="Image 2">
            <img src="images/Carousel img 3.png" alt="Image 3">
        </div>

        <div class="carousel-controls">
            <button class="carousel-button prev-button">
                <img src="images/previous icon.png" alt="Previous">
            </button>

            <div class="carousel-dots">
                <span class="dot active"></span>
                <span class="dot"></span>
                <span class="dot"></span>
            </div>

            <button class="carousel-button next-button">
                <img src="images/next icon.png" alt="Next">
            </button>
        </div>


        <form action="CustomerHome" method="POST" class="category-container">
            <h1 class="category-title">Category</h1>
            <div class="categories">
                <a href="ViewCategory?category=Promotion" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-tags"></i> 
                    </div>
                    Promotion deals
                </a>

                <a href="ViewCategory?category=Fresh Food" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-apple-alt"></i> 
                    </div>
                    Fresh Food
                </a>

                <a href="ViewCategory?category=Dry Food" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-box-open"></i> 
                    </div>
                    Dry Food
                </a>

                <a href="ViewCategory?category=Beverages" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-wine-glass-alt"></i> 
                    </div>
                    Beverages
                </a>

                <a href="ViewCategory?category=Household" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-broom"></i> 
                    </div>
                    Household
                </a>

                <a href="ViewCategory?category=Beauty and Health" class="category-item">
                    <div class="category-icon">
                        <i class="fas fa-pump-soap"></i> 
                    </div>
                    Beauty and Health
                </a>
            </div>

            <h1 class="category-title">Store</h1>
            
            <c:forEach var="store" items="${stores}">
                <a href="ViewStore?storeid=${store.storeid}" class="store-button">
                    <div class="store-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <div class="store-text">
                        <span class="store-name">${store.storename}</span>
                        <span class="store-location">${store.address}</span>
                    </div>
                </a>
            </c:forEach>
        </form>
    </body>
</html>
