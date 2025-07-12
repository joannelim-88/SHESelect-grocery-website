<%@page import="model.Grocer"%>
<%@page import="model.OrderItem"%>
<%@page import="model.Store"%>
<%@page import="model.Product"%>
<%@page import="model.MyOrder"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Payment | SHESelect</title>
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
            <img src="images/home page icon.png" alt="Logo" class="logo"> 
            <div class="header-icons">
                <a href="AdminProfile"><img src="images/profile icon1.png" alt="Profile"></a> 
                <img src="images/menu icon.png" alt="Menu" id="menu-icon" onclick="toggleMenu()"> 
            </div>

            <div id="side-menu">
                <ul>
                    <li>
                        <a href="AFeedbackForum">
                            <img src="images/star icon.png"> Feedback forum
                        </a>
                    </li>
                    <li>
                        <button onclick="logout()" class="logout-btn">Logout</button>
                    </li>
                </ul>
            </div>
        </header>
        <div class="content-wrapper">
            <a href="adminhome.jsp" class="back-button">Back</a>
            <br><br><br>
            <h1>Manage Payment</h1>

            <% String message = (String) request.getAttribute("message");
                String error = (String) request.getAttribute("error");
            %>

            <% if (message != null) {%>
            <div style="color: green;"><%= message%></div>
            <% } else if (error != null) {%>
            <div style="color: red;"><%= error%></div>
            <% } %>
            
            <%-- Get done orders --%>
            <%
                List<MyOrder> doneOrders = (List<MyOrder>) request.getAttribute("done");
                if (doneOrders != null && !doneOrders.isEmpty()) {
                    for (MyOrder order : doneOrders) {
                        List<OrderItem> items = order.getOrderItems();
            %>
            <div style="margin: 20px; padding: 15px; border: 1px solid #ccc; border-radius: 10px;">
                <p><b>Order ID:</b> <%= order.getOrderid()%></p>
                <p><b>Status:</b> <%= order.getOrderstatus()%></p>

                <ul>
                    <%
                        if (items != null && !items.isEmpty()) {
                            for (OrderItem item : items) {
                                Product product = item.getProduct();
                                Store store = (product != null) ? product.getStore() : null;
                                Grocer grocer = (store != null) ? store.getGrocer() : null;
                    %>
                    <li>
                        <b>Product:</b> <%= (product != null) ? product.getProductname() : "N/A"%> - RM<%= item.getPrice()%> x <%= item.getQuantity()%><br>
                        <% if (store != null && grocer != null) {%>
                        <small>Store ID: <%= store.getStoreid()%> | Grocer ID: <%= grocer.getGrocerid()%></small>
                        <% } %>
                    </li>
                    <%      }
                    } else {
                    %>
                    <li>No items found for this order.</li>
                        <% }%>
                </ul>

                <form method="post" action="ManagePayment">
                    <input type="hidden" name="action" value="sendPayment" />
                    <input type="hidden" name="orderId" value="<%= order.getOrderid()%>" />
                    <label>Enter amount to pay (RM):</label>
                    <input type="number" name="amount" step="0.01" required />
                    <button type="submit">Pay Grocer</button>
                </form>
            </div>
            <%
                }
            } else {
            %>
            <p>No completed orders available for payment.</p>
            <% }%>
        </div>
    </body>
</html>
