<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review | SHESelect</title>
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

            .review-block {
                border: 1px solid #ccc;
                padding: 10px;
                margin-bottom: 15px;
                background: #f9fff9;
            }
            .review-block input {
                display: block;
                margin: 5px 0;
                width: 300px;
            }
            input[type="text"], input[type="number"] {
                width: 100%;
                padding: 8px;
                margin: 6px 0;
                box-sizing: border-box;
            }
            button {
                padding: 8px 12px;
                margin-top: 10px;
            }

            .error-message {
                color: #fff;
                background-color: #e74c3c;
                border: 1px solid #c0392b;
                padding: 10px 15px;
                border-radius: 6px;
                font-weight: bold;
                margin-top: 10px;
                max-width: 500px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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
        <div class="content-wrapper">
            <a href="CustomerTrack" class="back-button">Back</a>
            <br><br><br>
            <h1>My Reviews</h1>

            <div class="order-header">
                Order id: <strong>${orderId}</strong><br>
                Status: <strong>${orderStatus}</strong>
            </div>

            <c:forEach var="item" items="${items}">
                <div class="review-block">
                    <p><strong>Product:</strong> ${item.product.productname}</p>
                    <p><strong>Quantity:</strong> ${item.quantity}</p>
                    <p><strong>Amount:</strong> RM ${item.totalamount}</p>

                    <form method="post" action="CustomerReview">
                        <input type="hidden" name="orderId" value="${orderId}" />


                        <input type="text" name="title_${item.id}"
                               value="${reviews[item.id] != null ? reviews[item.id].feedbacktitle : ''}"
                               placeholder="Enter feedback title" required
                               <c:if test="${orderStatus == 'pending review' || orderStatus == 'reviewed'}"></c:if> />

                               <input type="number" name="rate_${item.id}"
                               value="${reviews[item.id] != null ? reviews[item.id].rating : ''}"
                               min="1" max="5" placeholder="Rating 1-5" required
                               <c:if test="${orderStatus == 'pending review' || orderStatus == 'reviewed'}"></c:if> />

                               <input type="text" name="detail_${item.id}"
                               value="${reviews[item.id] != null ? reviews[item.id].feedbackdetail : ''}"
                               placeholder="Your feedback here" required
                               <c:if test="${orderStatus == 'pending review' || orderStatus == 'reviewed'}"></c:if> />

                        <c:if test="${orderStatus == 'pending review' || orderStatus == 'reviewed'}">
                            <c:choose>
                                <c:when test="${reviews[item.id] != null}">
                                    <button type="submit" name="action" value="edit_${item.id}">Edit Review</button>
                                    <button type="submit" name="action" value="remove_${item.id}">Remove</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" name="action" value="add_${item.id}">Submit</button>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </form>
                </div>
                <hr />
            </c:forEach>
        </div>
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold;">${error}</div>
        </c:if>

    </body>
</html>
