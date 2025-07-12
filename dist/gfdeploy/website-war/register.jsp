<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Member Registration</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <!--Web site CSS layout design -->
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', sans-serif;
                background: #f6f1f6;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }

            .register-container {
                display: flex;
                width: 900px;
                min-height: 520px;
                height: auto;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
            }

            .form-section {
                background-color: #ffe1f0;
                flex: 1;
                padding: 40px;
                box-sizing: border-box;
                overflow-y: auto;
            }

            .form-section h1 {
                margin-bottom: 30px;
                font-size: 24px;
                color: #333;
            }

            .form-group {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                background: #fff;
                border: 1px solid #ccc;
                padding: 8px 10px;
                border-radius: 5px;
            }

            .form-group input {
                border: none;
                outline: none;
                flex: 1;
                font-size: 14px;
                padding: 5px;
                background: transparent;
            }

            .form-group svg {
                margin-right: 10px;
                fill: #777;
            }

            .form-section .error {
                color: red;
                margin-top: 10px;
            }

            .submit-btn {
                width: 100%;
                padding: 12px;
                background: #ffae00;
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                margin-top: 10px;
            }

            .submit-btn:hover {
                background-color: #45a049;
            }

            .form-section p {
                font-size: 14px;
                margin-top: 10px;
                text-align: center;
            }

            .form-section p a {
                color: #007BFF;
                text-decoration: none;
            }

            .image-section {
                background: #e8f3e8;
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .image-section img {
                max-width: 300px;
            }

            .red-border {
                border: 2px solid red !important;
            }

            .signin-link a {
                color: #4CAF50;
                text-decoration: none;
            }

            .signin-link a:hover {
                text-decoration: underline;
            }

            .error {
                color: red;
                font-weight: bold;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <!-- Left Registration form -->
            <div class="form-section">
                <h1>Member Registration</h1>

                <form action="Register" method="POST">
                    <div class="form-group ${usernameInvalid ? 'red-border' : ''}">
                        <input type="text" name="username" placeholder="Username" value="${username != null ? username : ''}" required>
                    </div>

                    <div class="form-group ${passwordInvalid ? 'red-border' : ''}">
                        <input type="password" name="password" placeholder="Password" required>
                    </div>

                    <div class="form-group ${nameInvalid ? 'red-border' : ''}">
                        <input type="text" name="name" placeholder="Name" value="${name != null ? name : ''}" required>
                    </div>

                    <div class="form-group ${ageInvalid ? 'red-border' : ''}">
                        <input type="text" name="age" placeholder="Age" value="${age != null ? age : ''}" required>
                    </div>

                    <div class="form-group ${emailInvalid ? 'red-border' : ''}">
                        <input type="email" name="email" placeholder="Email" value="${email != null ? email : ''}" required>
                    </div>

                    <div class="form-group ${phonenoInvalid ? 'red-border' : ''}">
                        <input type="text" name="phoneno" placeholder="Phone no" value="${phoneno != null ? phoneno : ''}" required>
                    </div>

                    <div class="form-group ${addressInvalid ? 'red-border' : ''}">
                        <input type="text" name="address" placeholder="Location address" value="${address != null ? address : ''}" required>
                    </div>

                    <input type="submit" value="REGISTER" class="submit-btn">

                    <c:if test="${usernameInvalid}">
                        <p class="error">Username is invalid or already taken</p>
                    </c:if>

                    <c:if test="${not empty param.errorMessage}">
                        <p class="error">${param.errorMessage}</p>
                    </c:if>

                    <div class="signin-link">
                        <p>Already have an account? <a href="login.jsp">Sign In</a></p>
                    </div>

                    <c:if test="${not empty registrationFailed}">
                        <p class="error">${registrationFailed}</p>
                    </c:if>
                </form>
            </div>

            <!-- Right Logo image -->
            <div class="image-section">
                <img src="images/Login logo.png" alt="SHESelect Logo">
            </div>

        </div>
    </body>
</html>

