<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Settings | SHESelect</title>
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

            .setting-section {
                margin: 20px auto;
                padding: 20px;
                max-width: 600px;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }

            .setting-section h2 {
                margin-top: 0;
            }

            .topup-section {
                margin-top: 15px;
            }

            .topup-section input[type="number"] {
                padding: 8px;
                width: 100px;
                margin-right: 10px;
            }

            .topup-section button {
                padding: 8px 16px;
            }

            .logout-section {
                text-align: center;
                margin: 40px 0;
            }

            .logout-section button {
                background-color: orange;
                color: white;
                border: none;
                padding: 12px 25px;
                font-size: 16px;
                border-radius: 10px;
                cursor: pointer;
            }

            .logout-section button:hover {
                background-color: #ffb84d;
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

            
            function toggleWalletOption(checkbox) {
                const topupForm = document.getElementById('topup-form');
                const isChecked = checkbox.checked;
                topupForm.style.display = isChecked ? 'block' : 'none';
                
                localStorage.setItem('walletEnabled', isChecked);
            }

            
            window.addEventListener('DOMContentLoaded', function () {
                const checkbox = document.getElementById('wallet-toggle');
                const storedState = localStorage.getItem('walletEnabled');

                if (storedState === 'true') {
                    checkbox.checked = true;
                    toggleWalletOption(checkbox); 
                }
            });

            
            function topUpWallet() {
                const amount = document.getElementById("topup-amount").value;

                if (!amount || parseFloat(amount) <= 0) {
                    alert("Please enter a valid amount");
                    return;
                }

                console.log("Entered amount:", amount); 

                fetch("CustomerSetting", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "amount=" + encodeURIComponent(amount)
                })
                        .then(response => response.text())
                        .then(data => {
                            console.log("Received data:", data); 
                            if (data.startsWith("SUCCESS:")) {
                                
                                const match = data.match(/RM\s*([\d.]+)/i);
                                if (match) {
                                    const updatedAmount = parseFloat(match[1]).toFixed(2);
                                    console.log("wallet-amount element:", document.getElementById("wallet-amount"));
                                    document.getElementById("wallet-amount").textContent = updatedAmount;
                                    alert("Wallet successfully topped up!");
                                } else {
                                    console.error("Could not extract wallet amount from response:", data);
                                    alert("Top-up successful, but failed to update display.");
                                }
                            } else {
                                alert(data);
                            }
                        });
            }

            function toggleWalletOption(checkbox) {
                document.getElementById("topup-form").style.display = checkbox.checked ? "block" : "none";
            }

            
            window.addEventListener('DOMContentLoaded', function () {
                const checkbox = document.getElementById('wallet-toggle');
                const storedState = localStorage.getItem('walletEnabled');

                if (storedState === 'true') {
                    checkbox.checked = true;
                    toggleWalletOption(checkbox); 
                }

                
                const walletAmountElement = document.getElementById("wallet-amount");
                if (walletAmountElement) {
                    fetch('CustomerSetting')
                            .then(response => response.text())
                            .then(balance => {
                                const parsed = parseFloat(balance);
                                if (!isNaN(parsed)) {
                                    walletAmountElement.textContent = parsed.toFixed(2);
                                } else {
                                    console.error("Balance received is not a number:", balance);
                                }
                            })
                            .catch(error => {
                                console.error("Failed to fetch wallet balance:", error);
                            });
                } else {
                    console.error("#wallet-amount element not found");
                }
            });

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
        <div class="content-wrapper">
            <a href="CustomerHome" class="back-button">Back</a>
            <br><br><br>
            <h1>Settings</h1>

            <!-- Payment Setting -->
            <div class="setting-section">
                <h2>Payment Setting</h2>
                <label>
                    <input type="checkbox" id="wallet-toggle" onchange="toggleWalletOption(this)">
                    Enable Online Wallet
                </label>
                <div id="topup-form" class="topup-section" style="display:none;">
                    <p>Current Wallet Balance: RM <span id="wallet-amount">0.00</span></p>
                    <input type="number" id="topup-amount" placeholder="Amount (RM)" step="0.01" min="0">
                    <button type="button" onclick="topUpWallet()">Top Up</button>
                </div>
            </div>

            <!-- Logout Button -->
            <div class="logout-section">
                <button onclick="logout()">Logout</button>
            </div>
        </div>
    </body>
</html>
