<%@page import="java.util.List"%>
<%@page import="model.Store"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Store | SHESelect</title>
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

            .store-card, .section {
                background: #ffc0cb;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 15px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .header {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .badge {
                background: orange;
                color: white;
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 6px;
            }
            .input-field, textarea {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #ccc;
                margin-top: 10px;
            }
            .status-toggle label {
                margin-right: 15px;
            }
            .save-btn {
                background: #00cc66;
                padding: 10px 15px;
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 10px;
                float: right;
                margin-bottom: 20px;
            }

            .edit-icon {
                width: 16px;
                height: 16px;
                vertical-align: middle;
                margin-left: 5px;
                cursor: pointer;
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
        <br>
        <div class="content-wrapper">
            <a href="ManageStore" class="back-button">Back</a>
            <br><br><br>
            <h1>Manage Store</h1>
            <%
                Store store = (Store) request.getAttribute("store");
                System.out.println("store in JSP: " + store);
                System.out.println("store ID in JSP: " + (store != null ? store.getStoreid() : "store is null"));
            %>
            <form action="EditStore" method="POST">
                <input type="hidden" name="storeid" value="<%= store.getStoreid()%>">
                <button class="save-btn" type="submit">Save Changes</button>

                <div class="store-card">
                    <h2>Store Name</h2>
                    <input class="input-field" type="text" name="storename" value="<%= store.getStorename()%>" required>
                </div>

                <div class="section">
                    <b>Description <img src="images/edit icon.png" alt="Edit" class="edit-icon"></b>
                    <textarea name="description" rows="3"><%= store.getDescription()%></textarea>
                </div>

                <div class="section">
                    <b>Location <img src="images/edit icon.png" alt="Edit" class="edit-icon"></b>
                    <textarea name="address" rows="2"><%= store.getAddress()%></textarea>
                </div>

                <div class="section">
                    <b>Status</b><br>
                    <label><input type="radio" name="status" value="open" <%= "open".equals(store.getStatus()) ? "checked" : ""%>> Open</label>
                    <label><input type="radio" name="status" value="close" <%= "close".equals(store.getStatus()) ? "checked" : ""%>> Close</label>
                </div>
            </form>
        </div>
    </body>
</html>
