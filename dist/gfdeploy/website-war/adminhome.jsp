<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SHESelect | Online Grocery Place</title>
        <!--Web site tab icon --> 
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <link rel="apple-touch-icon" sizes= "192x192" href="images/logo-192x192.png">
        <link rel="manifest" href="manifest.json">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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

            
            .carousel {
                position: relative;
                width: 100%;
                max-width: 1200px; 
                margin: 20px auto; 
                overflow: hidden;
                height: 500px; 
                background-color: #f5f5f5;
            }

            .carousel img {
                position: absolute;
                width: 100%;
                height: 100%;
                object-fit: contain;
                display: none;
                background-color: #f5f5f5;
                transition: opacity 0.5s ease;
                opacity: 0;
            }

            .carousel img.active {
                display: block;
                opacity: 1;
            }

            .carousel-controls {
                display: flex;
                justify-content: center;
                gap: 40px;
                margin-top: 10px;
            }

            .carousel-button {
                background-color: rgba(248, 200, 211, 0.8);
                border: none;
                cursor: pointer;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .carousel-button img {
                width: 24px;
                height: 24px;
            }

            .carousel-dots {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: center;
            }

            .dot {
                height: 12px;
                width: 12px;
                background-color: #e0e0e0;
                border-radius: 50%;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .dot.active {
                background-color: #f8c8d3;
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

        </style>
        <%-- Function for Carousel and Side Menu --%>
        <script>
            // Carousel and menu logic
            document.addEventListener('DOMContentLoaded', function () {
                // Carousel functionality
                const images = document.querySelectorAll('.carousel img');
                const dots = document.querySelectorAll('.dot');
                const prevButton = document.querySelector('.prev-button');
                const nextButton = document.querySelector('.next-button');

                let currentIndex = 0;
                let intervalId;
                const intervalDuration = 5000;

                function showImage(index) {
                    images.forEach((img, i) => {
                        img.classList.remove('active');
                        if (i === index) {
                            img.classList.add('active');
                        }
                    });

                    dots.forEach((dot, i) => {
                        dot.classList.toggle('active', i === index);
                    });
                }

                function nextImage() {
                    currentIndex = (currentIndex + 1) % images.length;
                    showImage(currentIndex);
                    resetInterval();
                }

                function prevImage() {
                    currentIndex = (currentIndex - 1 + images.length) % images.length;
                    showImage(currentIndex);
                    resetInterval();
                }

                function startInterval() {
                    intervalId = setInterval(nextImage, intervalDuration);
                }

                function resetInterval() {
                    clearInterval(intervalId);
                    startInterval();
                }

                // Dot click event
                dots.forEach((dot, i) => {
                    dot.addEventListener('click', () => {
                        currentIndex = i;
                        showImage(currentIndex);
                        resetInterval();
                    });
                });

                showImage(currentIndex);
                startInterval();

                nextButton?.addEventListener('click', nextImage);
                        prevButton?.addEventListener('click', prevImage);

                const carousel = document.querySelector('.carousel');
                carousel.addEventListener('mouseenter', () => clearInterval(intervalId));
                carousel.addEventListener('mouseleave', startInterval);
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

        <%-- Home Page Carousel --%>
        <div class="carousel" id="carousel">
            <img src="images/Carousel img 1.png" class="active" alt="Image 1">
            <img src="images/Carousel img 2.png" alt="Image 2">
            <img src="images/Carousel img 3.png" alt="Image 3">
        </div>

        <div class="carousel-controls">
            <button class="carousel-button prev-button">
                <img src="images/previous icon.png" alt="Previous">
            </button>

            <div class="carousel-dots">
                <span class="dot active"></span>
                <span class="dot"></span>
                <span class="dot"></span>
            </div>

            <button class="carousel-button next-button">
                <img src="images/next icon.png" alt="Next">
            </button>
        </div>

        <h1 style="text-align: center;">Welcome Admin!</h1>

        <%-- Buttons --%>
        <div class="button-container">
            <a href="RegisterGrocer">
                <i class="fas fa-store"></i> Register Grocer
            </a>
            <a href="manageuserinfo.jsp">
                <i class="fas fa-users-cog"></i> Manage User Information
            </a>
            <a href="ManagePayment">
                <i class="fas fa-money-check-alt"></i> Manage Payment
            </a>
        </div>
    </body>
</html>
