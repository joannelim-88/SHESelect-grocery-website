<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Grocer | SHESelect</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <%-- Website CSS layout styling --%>
        <style>
            input[type="number"] {
                width: 60px;
                text-align: center;
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

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: greenyellow;
                color: white;
                padding: 10px 20px;
                border: 2px solid greenyellow;
                border-radius: 15px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                text-decoration: none; 
            }

            .btn:hover {
                background: orange;
                color: lightseagreen;
            }

            form {
                max-width: 500px;
                margin: auto;
                background: #f9f9f9;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }

            form table {
                width: 100%;
                border-spacing: 15px;
            }

            form td {
                vertical-align: top;
            }

            form td:first-child {
                text-align: right;
                font-weight: 500;
                padding-right: 10px;
                white-space: nowrap;
                width: 30%;
            }

            input[type="text"],
            input[type="number"] {
                width: 100%;
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            #ageInput {
                width: 60px;
                text-align: center;
                display: inline-block;
                margin: 0 10px;
            }

        </style>
        <script>
            function changeAge(amount) {
                const ageInput = document.getElementById('ageInput');
                let currentAge = parseInt(ageInput.value) || 0;
                let newAge = currentAge + amount;

                if (newAge >= 0 && newAge <= 100) {
                    ageInput.value = newAge;
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
        <br>
        <div class="content-wrapper">
            <a href="RegisterGrocer" class="back-button">Back</a>
            <br><br><br>
            <h1>Register Grocer</h1>
            <h3>Grocer registration</h3>
            <br><br>
            <form action="AddGrocer" method="POST" class="form">
                <table>
                    <tr>
                        <td>Set Password: </td>
                        <td><input type="text" name="password" placeholder="e.g. Jolim338" size="20"></td>
                    </tr>
                    <tr>
                        <td>Name: </td>
                        <td><input type="text" name="name" placeholder="e.g. Joanne" size="20"></td>
                    </tr>
                    <tr>
                        <td>Age: </td> 
                        <td>
                            <button type="button" onclick="changeAge(-1)">-</button>
                            <input type="number" name="age" id="ageInput" value="0" min="0" max="100">
                            <button type="button" onclick="changeAge(1)">+</button>
                        </td> 
                    </tr>
                    <tr>
                        <td>Email: </td>
                        <td><input type="text" name="email" placeholder="e.g. user@gmail.com" size="20"></td>
                    </tr>
                    <tr>
                        <td>Phone no: </td>
                        <td><input type="text" name="phoneno" id="phoneInput" placeholder="e.g. 1234567890" size="20"></td>
                    </tr>
                    <tr>
                        <td>Address: </td>
                        <td><input type="text" name="address" size="20"></td>
                    </tr>
                </table>
                <br>
                <p><input type="submit" value="Register" class="btn"></p>
            </form>
        </div>
    </body>
</html>
