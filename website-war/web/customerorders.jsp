<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Orders | SHESelect</title>
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
        <div class="content-wrapper">
            <a href="grocerhome.jsp" class="back-button">Back</a>
            <br><br><br>
            <h1>Customer Orders</h1>
            <form method="get" action="CustomerOrders">
                <label for="store">Select Store:</label>
                <select name="storeid" id="store" onchange="this.form.submit()">
                    <option value="">-- Choose Store --</option>
                    <c:forEach var="store" items="${stores}">
                        <option value="${store.storeid}" ${param.storeid == store.storeid ? 'selected' : ''}>${store.storename}</option>
                    </c:forEach>
                </select>
            </form>

            <%-- customers order list section --%>
            <c:if test="${not empty orders}">
                <h2>Orders for selected store</h2>
                <c:forEach var="order" items="${orders}">
                    <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; border-radius: 10px;">
                        <h3>Order ID: ${order.orderid}</h3>
                        <p>Status: ${order.orderstatus}</p>
                        <p>Customer: ${order.customer.name}</p>
                        <ul>
                            <c:forEach var="item" items="${orderItemsMap[order.orderid]}">
                                <c:if test="${item.product.store.storeid == param.storeid}">
                                    <li>
                                        ${item.productname} - ${item.quantity} pcs @ RM${item.price}
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>

                        <form method="post" action="CustomerOrders">
                            <input type="hidden" name="orderId" value="${order.orderid}" />
                            <input type="hidden" name="storeid" value="${param.storeid}" />
                            
                            <label for="status_${order.orderid}">Update Status:</label>
                            <select name="newStatus" id="status_${order.orderid}">
                                <option value="pending" ${order.orderstatus == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="done" ${order.orderstatus == 'done' ? 'selected' : ''}>Done</option>
                            </select>

                            <input type="submit" value="Update Order" />
                        </form>
                    </div> 
                </c:forEach>
            </c:if>
            <c:if test="${empty orders}">
                <p>No orders available for the selected store.</p>
            </c:if>
        </div>
    </body>
</html>
