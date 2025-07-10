<%@page import="model.Wallet"%>
<%@page import="model.Customer"%>
<%@page import="model.OrderItem"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check Out | SHESelect</title>
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

            .item-box {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: #fffefb;
                padding: 10px 15px;
                margin-bottom: 10px;
                border-radius: 12px;
                border: 1px solid #ddd;
            }

            .item-box img {
                width: 30px;
                margin-right: 10px;
            }

            .payment-section, .delivery-section {
                display: flex;
                justify-content: space-between;
                border: 1px solid #ccc;
                padding: 15px;
                border-radius: 12px;
                margin-top: 15px;
                background-color: #fafafa;
            }

            .payment-section div,
            .delivery-section div {
                width: 48%;
            }

            .payment-method label {
                display: block;
                margin: 8px 0;
            }

            .summary {
                margin-top: 10px;
                text-align: right;
            }

            .place-order-btn {
                margin-top: 20px;
                background-color: #32cd32;
                color: white;
                padding: 12px 20px;
                border: none;
                font-size: 16px;
                border-radius: 30px;
                width: 100%;
                cursor: pointer;
            }

            .place-order-btn:hover {
                background-color: #28a428;
            }
            
            .error-message {
                color: red;
                margin-top: 10px;
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
            <a href="cart.jsp" class="back-button">Back</a>
            <br><br>
            <h1>Check out</h1>
            <!-- Order item list -->
            <c:forEach var="item" items="${cartItems}">
                <div class="item-box">
                    <div>
                        ${item.product.productname}<br>
                        RM ${item.product.price}
                    </div>
                    <div>
                        Quantity: ${item.quantity}<br>
                        Amount: RM ${item.quantity * item.product.price}
                    </div>
                </div>
            </c:forEach>

            <div class="summary">
                <strong>Total: RM ${grandTotal}</strong>
            </div>

            <form action="ConfirmOrder" method="post">
                <%= ((Customer) session.getAttribute("customer")).getCustomerid()%>

                <input type="radio" name="payment" value="wallet" checked> Pay with Wallet <br>
                <!-- Wallet section using session scope -->
                <c:if test="${not empty sessionScope.wallet}">
                    Wallet Balance: RM ${sessionScope.wallet.balance} <br><br>
                </c:if>
                <br><br>

                <strong>Deliver to:</strong><br><br>
                ${sessionScope.customer.name} <br>
                ${sessionScope.customer.address} <br><br>

                <button class="place-order-btn" type="submit">Place Order</button>

                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>

            </form>
        </div>
    </body>
</html>
