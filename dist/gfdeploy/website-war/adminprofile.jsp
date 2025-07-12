<%@page import="model.Admin"%>
<%@page import="model.MyUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Member Profile | SHESelect</title>
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

            input[type="number"] {
                width: 60px;
                text-align: center;
            }

            .profile-img {
                display: block; 
                margin: 0 auto; 
                width: 100px; 
                height: 100px; 
                object-fit: cover;
                border-radius: 50%; 
                border: 2px solid #007BFF; 
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); 
            }


            .profile-img + h1 {
                margin-top: 20px;
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

            .profile-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                max-width: 500px;
                margin: 0 auto;
                padding: 20px;
                font-family: Arial, sans-serif;
            }

            .profile-form {
                width: 100%;
            }

            .profile-form table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0 12px;
            }

            .profile-form td {
                padding: 6px 0;
            }

            .profile-form td:first-child {
                width: 40%;
                font-weight: bold;
                color: #555;
            }

            .profile-form input[type="text"],
            .profile-form input[type="number"] {
                width: 90%;  
                padding: 8px 12px; 
                border: 1px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 15px; 
            }

            .profile-form input[readonly] {
                background-color: #f9f9f9;
                color: #666;
            }

            .button-group {
                margin-top: 20px;
                text-align: center;
            }

            .button {
                background-color: #ff85a2;
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
                margin: 0 5px;
            }

            .button:hover {
                background-color: #ff6b8b;
            }

            .button:disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }
        </style>
        <script>
            //JSP elements
            function changeAge(amount) {
                const ageInput = document.getElementById('ageInput');
                let currentAge = parseInt(ageInput.value) || 0;
                let newAge = currentAge + amount;

                if (newAge >= 0 && newAge <= 100) {
                    ageInput.value = newAge;
                }
            }
            document.getElementById('phoneInput').addEventListener('input', function (event) {
                if (!event.target.value.startsWith("+60")) {
                    event.target.value = "+60";
                }
            });

            function AdminInfo(adminid, password, name, age, email, phoneno, address) {
                document.getElementById('adminid').value = adminid;
                document.getElementById('password').value = password;
                document.getElementById('name').value = name;
                document.getElementById('age').value = age;
                document.getElementById('email').value = email;
                document.getElementById('phoneno').value = phoneno;
                document.getElementById('address').value = address;
            }

            function togglePassword() {
                const pwField = document.getElementById("password");
                pwField.type = pwField.type === "password" ? "text" : "password";
            }

            function toggleEdit() {
                const isReadOnly = document.getElementById("name").readOnly;
                const form = document.getElementById("profileForm");
                const editBtn = document.getElementById("editBtn");

                // Toggle readonly for inputs 
                const inputs = form.querySelectorAll("input:not(#adminid):not([type=button]):not([type=submit])");
                inputs.forEach(input => input.readOnly = !input.readOnly);

                // Enable/disable age 
                form.querySelectorAll("button[onclick*='changeAge']").forEach(btn => btn.disabled = !btn.disabled);


                if (isReadOnly) {
                    editBtn.value = "Save Changes";
                    editBtn.type = "submit";
                } else {
                    editBtn.value = "Edit";
                    editBtn.type = "button";
                }
            }

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
            <h1>Member Profile</h1>


            <img src="images/Profile icon.png" alt="Profile Pic" class="profile-img">

            <!-- Edit mode checker -->
            <c:set var="isEditMode" value="${param.edit == 'true'}"/>

            <%
                Admin admin = (Admin) request.getAttribute("admin");
                MyUser user = (MyUser) request.getAttribute("user");
                if (admin != null && user != null) {
            %>

            <form action="AdminProfile?action=edit" method="POST" class="profile-form">
                <table>
                    <tr>
                        <td>Username: </td>
                        <td><input type="text" name="username" size="20" value="<%= admin.getAdminid()%>" readonly></td>
                    </tr>
                    <tr>
                        <td>Password: </td>
                        <td><input type="text" name="password" size="20" value="<%= user.getPassword()%>" <c:if test="${!isEditMode}">readonly</c:if>></td>
                        </tr>
                        <tr>
                            <td>Name: </td>
                            <td><input type="text" name="name" size="20" value="<%= admin.getName()%>" <c:if test="${!isEditMode}">readonly</c:if>></td>
                        </tr>
                        <tr>
                            <td>Age: </td>
                            <td>
                                <button type="button" onclick="document.getElementById('ageInput').stepDown()" <c:if test="${!isEditMode}">disabled</c:if>>-</button>
                            <input type="number" name="age" id="ageInput" min="0" max="100" value="<%= admin.getAge()%>" <c:if test="${!isEditMode}">readonly</c:if>>
                            <button type="button" onclick="document.getElementById('ageInput').stepUp()" <c:if test="${!isEditMode}">disabled</c:if>>+</button>
                            </td>
                        </tr>
                        <tr>
                            <td>Email: </td>
                            <td><input type="text" name="email" size="20" value="<%= admin.getEmail()%>" <c:if test="${!isEditMode}">readonly</c:if>></td>
                        </tr>
                        <tr>
                            <td>Phone no: </td>
                            <td><input type="text" name="phoneno" size="20" value="<%= admin.getPhoneno()%>" <c:if test="${!isEditMode}">readonly</c:if>></td>
                        </tr>
                        <tr>
                            <td>Location address: </td>
                            <td><input type="text" name="address" size="20" value="<%= admin.getAddress()%>" <c:if test="${!isEditMode}">readonly</c:if>></td>
                        </tr>
                    </table>

                    <!-- Buttons -->
                    <p>
                    <div class="button-group">
                    <c:choose>
                        <c:when test="${isEditMode}">
                            <button type="submit" class="button">Save Changes</button>
                        </c:when>
                        <c:otherwise>
                            <a href="?edit=true"><button type="button" class="button">Edit Profile</button></a>
                        </c:otherwise>
                    </c:choose>
                </div>
                </p>

                <%
                    String message = (String) request.getAttribute("message");
                    String messageType = (String) request.getAttribute("messageType");
                    if (message != null) {
                %>
                <div class="message <%= messageType%>"><%= message%></div>
                <% } %>
            </form>
            <% }%>
        </div>
    </body>
</html>
