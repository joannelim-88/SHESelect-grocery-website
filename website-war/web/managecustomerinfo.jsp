<%@page import="java.util.List"%>
<%@page import="model.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Customer | SHESelect</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <%-- Website CSS layout design --%>
        <style>
            input[type="number"] {
                width: 60px;
                text-align: center;
            }
            .icon {
                width: 20px; 
                height: 20px;
                vertical-align: middle;
            }

            button {
                background: none;
                border: none;
                cursor: pointer;
                padding: 5px;
            }

            button:hover img {
                opacity: 0.7; 
            }

            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 5px;
                text-align: center;
                font-weight: bold;
            }
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            
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

            .customer-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }

            .customer-card {
                background-color: #ffffff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                width: 300px;
                transition: transform 0.2s;
            }

            .customer-card:hover {
                transform: scale(1.02);
            }

            .customer-card h3 {
                margin-top: 0;
                color: #2e7d32;
            }

            .customer-card p {
                margin: 5px 0;
            }

            .action-buttons {
                margin-top: 10px;
                display: flex;
                gap: 15px;
                justify-content: flex-end;
            }

            .dropdown-form {
                background-color: #d3d3d3;
                padding: 20px;
                border-radius: 10px;
                margin-top: 20px;
                display: none;
                width: 80%;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            }

            .dropdown-form label {
                display: inline-block;
                width: 100px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .dropdown-form input[type="text"],
            .dropdown-form input[type="email"],
            .dropdown-form input[type="number"] {
                padding: 6px;
                width: 60%;
                margin-bottom: 10px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }

            .dropdown-form .form-row {
                margin-bottom: 12px;
            }

            .dropdown-form button {
                background-color: #4CAF50;
                color: white;
                padding: 10px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }

            .dropdown-form button:hover {
                background-color: #45a049;
            }

        </style>
        <script>
            // Populate form with selected customer data
            function editCustomer(customerid, name, age, email, phoneno, address) {
                document.getElementById('customerid').value = customerid;
                document.getElementById('name').value = name;
                document.getElementById('age').value = age;
                document.getElementById('email').value = email;
                document.getElementById('phoneno').value = phoneno;
                document.getElementById('address').value = address;

                
                document.getElementById('editForm').style.display = "block";
            }

            // Confirm and delete user
            function deleteCustomer(customerid) {
                if (confirm("Are you sure you want to delete this customer?")) {
                    
                    window.location.href = "DeleteCustomer?customerid=" + customerid;
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                document.getElementById("editForm").style.display = "none";
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
        <br>
        <div class="content-wrapper">

            <a href="manageuserinfo.jsp" class="back-button">Back</a>
            <br><br><br>
            <h1>Manage Customer Information</h1>
            <%-- Show list of registered customers --%>
            <div class="customer-container">
                <%
                    List<Customer> customers = (List<Customer>) request.getAttribute("customerList");
                    if (customers != null) {
                        for (Customer customer : customers) {
                %>
                <div class="customer-card">
                    <h3><%= customer.getCustomerid()%></h3>
                    <div class="action-buttons">
                        <button onclick="editCustomer('<%= customer.getCustomerid()%>', '<%= customer.getName()%>', '<%= customer.getAge()%>', '<%= customer.getEmail()%>', '<%= customer.getPhoneno()%>', '<%= customer.getAddress()%>')">
                            <img src="images/edit icon.png" alt="Edit" class="icon">
                        </button>
                        <button onclick="deleteCustomer('<%= customer.getCustomerid()%>')">
                            <img src="images/delete icon.png" alt="Delete" class="icon">
                        </button>
                    </div>
                </div>
                <% }
                    } %>
            </div>
            <%-- Edit Form --%>
            <div id="editForm" class="dropdown-form">
                <h2>User information</h2>
                <form action="ManageCustomer" method="post">
                    <input type="hidden" id="customerid" name="customerid">

                    <div class="form-row">
                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name">
                    </div>

                    <div class="form-row">
                        <label for="age">Age:</label>
                        <input type="number" id="age" name="age">
                    </div>

                    <div class="form-row">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email">
                    </div>

                    <div class="form-row">
                        <label for="phoneno">Phone no:</label>
                        <input type="text" id="phoneno" name="phoneno">
                    </div>

                    <div class="form-row">
                        <label for="address">Address:</label>
                        <input type="text" id="address" name="address">
                    </div>

                    <button type="submit">Save Changes</button>

                    <% String message = (String) request.getAttribute("message");
                        String messageType = (String) request.getAttribute("messageType");
                        if (message != null) {%>
                    <div class="message <%= messageType%>">
                        <%= message%>
                    </div>
                    <% }%>
                </form>
            </div>
        </div>
    </body>
</html>
