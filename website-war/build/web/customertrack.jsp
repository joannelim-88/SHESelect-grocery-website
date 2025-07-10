<%@page import="java.util.Map"%>
<%@page import="model.OrderItem"%>
<%@page import="java.util.List"%>
<%@page import="model.MyOrder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Track Order | SHESelect</title>
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

            .order-header{
                border: 1px solid #ccc; 
                padding: 10px; 
                border-radius: 10px; 
                background-color: #f8f8f8;
            }

            .order-item{
                background: white; 
                padding: 15px; 
                margin-bottom: 10px; 
                border-radius: 10px; 
                box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
                display: flex;
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
        <%
            List<MyOrder> customerOrders = (List<MyOrder>) request.getAttribute("customerOrders");
            Map<Long, List<OrderItem>> orderItemsMap = (Map<Long, List<OrderItem>>) request.getAttribute("orderItems");

            if (customerOrders == null || customerOrders.isEmpty()) {
        %>
        <p>You have no orders yet.</p>
        <%
        } else {
        %>

        <div class="content-wrapper">

            <a href="CustomerHome" class="back-button">Back</a>
            <br><br><br>
            <h1>My Orders</h1>

            <%
                for (MyOrder order : customerOrders) {
            %>
            <div class="order-header">
                <h3>Order id: <b><%= order.getOrderid()%></b> 
                    <span style="float:right; color:blue;"><%= order.getOrderstatus()%></span>
                </h3>
            </div>

            <br>

            <%
                List<OrderItem> orderItems = orderItemsMap.get(order.getOrderid());
                if (orderItems != null) {
                    for (OrderItem item : orderItems) {
            %>
            <div class="order-item" style="margin-bottom: 20px;">
                <div style="display: flex; align-items: center; margin-bottom: 10px; flex-wrap: wrap; gap: 50px;">
                    <div style="flex: 1;">
                        <b><%= item.getProductname()%></b><br>
                        RM <%= item.getPrice()%>
                    </div>
                    <div style="text-align: right;">
                        <div>Quantity: <%= item.getQuantity()%></div>
                        <div>Amount: RM <%= item.getTotalamount()%></div>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>

            <form action="CustomerTrack" method="POST">
                <input type="hidden" name="orderId" value="<%= order.getOrderid()%>">
                <p>
                    <input type="submit" name="action" value="Cancel Order" 
                           <%
                               String status = order.getOrderstatus().toLowerCase();
                               if ("done".equals(status) || "pending review".equals(status) || "reviewed".equals(status)) {
                           %> 
                           disabled 
                           <%
                               }
                           %>
                           style="background-color: orange; color: white; padding: 10px; border-radius: 5px;">
                </p>

                <p>
                    <input type="submit" name="action" value="Review"
                           <%
                               String statusLower = order.getOrderstatus().toLowerCase();
                               if (!(statusLower.equals("pending review")
                                       || statusLower.equals("reviewed"))) {
                           %> 
                           disabled 
                           <%
                               }
                           %>
                           style="padding: 10px; border-radius: 5px;">
                </p>
            </form>

            <hr style="margin: 40px 0;"> 
            <%
                }
            %>

        </div> 

        <%
            }
        %>
    </body>
</html>
