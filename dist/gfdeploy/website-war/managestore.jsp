<%@page import="model.Store"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Store | SHESelect</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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

            .store-card {
                background-color: #fbb6ce;
                padding: 20px;
                border-radius: 10px;
                margin: 20px auto;
                width: 80%;
                display: flex;
                align-items: center;
                justify-content: space-between;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            }
            .store-info {
                display: flex;
                align-items: center;
            }
            .store-icon {
                width: 50px;
                height: 50px;
                margin-right: 20px;
            }
            .edit-btn {
                background-color: #fca311;
                border: none;
                border-radius: 8px;
                padding: 10px 15px;
                color: white;
                cursor: pointer;
                font-weight: bold;
                display: flex;
                align-items: center;
            }

            .edit-btn img,
            .add-btn img {
                width: 16px;
                height: 16px;
                margin-right: 6px;
                vertical-align: middle;
            }

            .edit-btn:hover {
                background-color: #fbbd91;
            }

            .add-store-container {
                text-align: center;
                margin-top: 30px;
            }

            .add-btn {
                padding: 10px 20px;
                font-size: 16px;
                background-color: white;
                border: 2px solid #000;
                border-radius: 8px;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
            }

            .add-btn:hover {
                background-color: #fbbd91;
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
            <h1>Manage Store</h1>

            <%
                
                List<Store> storeList = (List<Store>) request.getAttribute("storeList");
                if (storeList != null && !storeList.isEmpty()) {
                    for (Store store : storeList) {
            %>

            <div class="store-card">
                <div class="store-info">
                    <img src="images/store icon.png" alt="Store Icon" class="store-icon">
                    <div>
                        <strong><%= store.getStorename()%></strong><br>
                        <span style="color: grey;">owner: <%= store.getGrocer().getGrocerid()%></span>
                    </div>
                </div>
                <form action="EditStore" method="get">
                    <input type="hidden" name="storeid" value="<%= store.getStoreid()%>">
                    <button class="edit-btn">
                        <img src="images/edit icon.png" alt="Edit Store">
                        Edit Store
                    </button>
                </form>
            </div>
            <%
                }
            } else {
            %>
            <p style="text-align: center;">No stores added yet.</p>
            <% }%>

            
            <form action="addstore.jsp" method="get">
                <button class="add-btn">
                    <img src="images/add icon.png" alt="Add Store">
                    Add Store
                </button>
            </form>

        </div>
    </body>
</html>
