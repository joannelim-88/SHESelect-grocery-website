<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Member Login</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <!--Web site CSS layout design -->
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #fff5f7; 
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .login-container {
                background-color: lightpink;
                padding: 20px 40px; 
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
                width: 650px; 
                margin: 100px auto; 
                text-align: center;
            }

            .logo {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
            }

            .subtitle {
                color: #666;
                margin-bottom: 30px;
                font-size: 14px;
            }

            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #555;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .login-btn {
                width: 100%;
                padding: 12px;
                background-color: orange;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }

            .login-btn:hover {
                background-color: #45a049;
            }

            .signup-link {
                margin-top: 20px;
                font-size: 14px;
                color: #666;
            }

            .signup-link a {
                color: #4CAF50;
                text-decoration: none;
            }

            .signup-link a:hover {
                text-decoration: underline;
            }

            .logo-image {
                max-width: 350px; 
                height: auto;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="logo">
                <img src="images/Login logo.png" alt="SHESelect Logo" class="logo-image">
            </div>

            <h2>Member Login</h2>

            <form action="Login" method="POST">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <button type="submit" class="login-btn">LOGIN</button>

                <div class="signup-link">
                    Not a member? <a href="register.jsp">Sign Up Now</a>
                </div>
            </form>

            <c:if test="${not empty logoutMessage}">
                <p style="color: green; margin-top: 20px;">${logoutMessage}</p>
            </c:if>

            <c:if test="${not empty loginError}">
                <p style="color: red; margin-top: 20px;">${loginError}</p>
            </c:if>

            <c:if test="${not empty registrationSuccess}">
                <p style="color: green; margin-top: 20px;">${registrationSuccess}</p>
            </c:if>

        </div>
    </body>
</html>
