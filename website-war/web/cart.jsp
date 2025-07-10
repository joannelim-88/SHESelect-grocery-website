<%@page import="java.util.List"%>
<%@page import="model.Cart"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart | SHESelect</title>
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

            .store-section {
                margin-bottom: 30px;
            }
            .cart-items {
                list-style: none;
                padding: 0;
            }
            .cart-item {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .cart-item strong {
                margin-right: 10px;
            }

            .cart-item .item-price {
                color: green;
                font-weight: bold;
                margin-left: 10px;
                white-space: nowrap;
            }

            .cart-item .total-price {
                color: green;
                font-weight: bold;
                margin-left: 10px;
                white-space: nowrap;
            }

            .quantity-form button {
                padding: 5px 10px;
                margin: 0 5px;
            }
            .checkout-btn {
                width: 100%;
                padding: 12px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 1rem;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            .checkout-btn:hover {
                background-color: #45a049;
            }
            .empty-cart {
                text-align: center;
                font-size: 1.2rem;
                color: #777;
                margin-top: 50px;
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

            function changeQuantity(amount) {
                var quantityInput = event.target.parentElement.querySelector('input[name="quantity"]');
                var current = parseInt(quantityInput.value);
                var newQuantity = current + amount;
                if (newQuantity < 1)
                    newQuantity = 1; 
                quantityInput.value = newQuantity;
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
            <h1>Your Cart</h1>

            <%-- Cart items --%>
            <%
                List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
                if (cartItems == null || cartItems.isEmpty()) {
            %>
            <div class="empty-cart">
                Your cart is empty. Start shopping!
            </div>
            <%
            } else {
            %>
            <ul class="cart-items">
                <%
                    double totalPrice = 0.0; 
                    for (Cart item : cartItems) {
                        double itemTotalPrice = item.getProduct().getPrice() * item.getQuantity(); 
                        totalPrice += itemTotalPrice; 
                %>
                <li class="cart-item">
                    <div class="cart-item-header">
                        <strong><%= item.getProduct().getProductname()%></strong>
                    </div>
                    <div class="store-name">
                        Store: <%= item.getProduct().getStore().getStorename()%>
                    </div>

                    <form action="CartServlet" method="post" class="quantity-form">
                        <input type="hidden" name="cartId" value="<%= item.getCartid()%>"/>
                        <button type="button" onclick="changeQuantity(-1)">-</button>
                        <input type="number" name="quantity" value="<%= item.getQuantity()%>" min="1" style="width: 40px; text-align: center;"/>
                        <button type="button" onclick="changeQuantity(1)">+</button>
                        <button type="submit" name="action" value="update" style="margin-left: 10px;">
                            Update
                        </button>
                        <button type="submit" name="action" value="remove" style="color: red;">
                            Remove
                        </button> 
                    </form>
                    <div class="item-price">
                        Price per item: RM <%= item.getProduct().getPrice()%> 
                        <br>
                        Total: RM <%= itemTotalPrice%> 
                    </div>
                </li>
                <% }%>
            </ul>
            <br>
            <div class="total-price">
                <strong>Total Price: RM <%= totalPrice%></strong> 
            </div>
            <br>
            <form action="CheckOut" method="get">
                <button class="checkout-btn">Check out</button>
            </form>
            <%
                }
            %>

            <% String error = request.getParameter("error");
                if (error != null) {
            %>
            <div class="error-message"><%= error%></div>
            <% }%>

        </div>
    </body>
</html>
