<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ocean View Resort | Welcome</title>
    <link rel="icon" type="image/x-icon" href="images/favicon.png">

    <style>
        :root{
            --blue: #2aa7ff;
            --blueDark: #0f86d6;
            --text: #0b2b3a;
        }

        *{ box-sizing: border-box; }
        body{
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            color: #fff;
            min-height: 100vh;
        }

        .page{
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-image:
                    linear-gradient(rgba(0, 0, 0, 0.45), rgba(0, 0, 0, 0.55)),
                    url("images/background.jpg");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        header{
            width: 100%;
            padding: 14px 18px;
            background: rgba(255,255,255,0.10);
            border-bottom: 1px solid rgba(255,255,255,0.18);
            backdrop-filter: blur(4px);
        }

        .header-wrap{
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .brand{
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
        }


        .logo-img{
            width: 44px;
            height: 44px;
            object-fit: contain;
            border-radius: 0;
            background: transparent;
            padding: 0;
            display: block;
        }


        .brand-text{
            display: flex;
            flex-direction: column;
            line-height: 1.1;
            min-width: 0;
        }

        .hotel-name{
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sub{
            margin: 4px 0 0 0;
            font-size: 12.5px;
            color: rgba(255,255,255,0.85);
        }

        .login-top-btn{
            border: none;
            cursor: pointer;
            padding: 10px 14px;
            border-radius: 10px;
            background: rgba(255,255,255,0.92);
            color: var(--text);
            font-weight: 700;
            min-width: 110px;
        }

        .login-top-btn:active{ transform: translateY(1px); }

        .hero{
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 18px;
            text-align: center;
        }

        .hero-wrap{
            width: 100%;
            max-width: 980px;
            padding: 22px 16px;
        }

        .hero h1{
            margin: 0 0 10px 0;
            font-size: clamp(30px, 5vw, 58px);
            font-weight: 800;
        }

        .hero p{
            margin: 0 auto 18px auto;
            max-width: 70ch;
            font-size: clamp(14px, 1.7vw, 18px);
            line-height: 1.6;
            color: rgba(255,255,255,0.9);
        }

        .hero .login-btn{
            border: none;
            cursor: pointer;
            padding: 12px 22px;
            border-radius: 12px;
            background: linear-gradient(180deg, var(--blue), var(--blueDark));
            color: #fff;
            font-weight: 800;
            font-size: 15px;
            min-width: 170px;
        }

        .hero .login-btn:active{ transform: translateY(1px); }

        footer{
            text-align: center;
            padding: 12px 10px;
            background: rgba(255,255,255,0.10);
            border-top: 1px solid rgba(255,255,255,0.18);
            color: rgba(255,255,255,0.9);
            font-size: 13px;
        }

        @media (max-width: 520px){
            .header-wrap{
                flex-direction: column;
                align-items: flex-start;
            }
            .login-top-btn{
                width: 100%;
            }
            .hero-wrap{
                padding: 14px 8px;
            }
            .hero .login-btn{
                width: 100%;
                max-width: 360px;
            }
        }


        .page{
            position: relative;
            overflow: hidden;
            /* CSS variables controlled by JS */
            --bg1: url("images/background.jpg");
            --bg2: url("images/background.jpg");
            --op1: 1;
            --op2: 0;
        }
        .page::before,
        .page::after{
            content: "";
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            transition: opacity 1.2s ease-in-out;
            z-index: 0;
            pointer-events: none;
        }
        .page::before{
            background-image: linear-gradient(rgba(0, 0, 0, 0.45), rgba(0, 0, 0, 0.55)), var(--bg1);
            opacity: var(--op1);
        }
        .page::after{
            background-image: linear-gradient(rgba(0, 0, 0, 0.45), rgba(0, 0, 0, 0.55)), var(--bg2);
            opacity: var(--op2);
        }
        .page > *{
            position: relative;
            z-index: 1;
        }

    </style>
</head>

<body>
<div class="page">
    <header>
        <div class="header-wrap">
            <div class="brand">
                <img class="logo-img" src="images/Ocean View Resort Logo.png" alt="OceanView Resort Logo" />
                <div class="brand-text">
                    <h2 class="hotel-name">Ocean View Resort</h2>
                    <p class="sub">Hotel Reservation & Billing System</p>
                </div>
            </div>
        </div>
    </header>

    <main class="hero">
        <div class="hero-wrap">
            <h1>Welcome to Ocean View Resort</h1>
            <p>
                A simple system to manage guest details, reservations, and billing in one place.<br>
                Click the login button to access the system.
            </p>
            <button class="login-btn" id="loginMain">LOGIN</button>
        </div>
    </main>

    <footer>
        <p style="margin:0;">
            <span id="year"></span> Ocean View Resort | Hotel Reservation & Billing System
        </p>
        <p style="margin:6px 0 0 0; font-size:12px; opacity:0.9;">
            Developed by Rakindu Fernando
        </p>
    </footer>

</div>

<script>
    document.getElementById("year").textContent = new Date().getFullYear();

    function goLogin(){
        window.location.href = "http://localhost:8080/oceanviewresort/login";
    }

    document.getElementById("loginMain").addEventListener("click", goLogin);



    (function () {
        var page = document.querySelector(".page");
        if (!page) return;


        var ctx = "<%= request.getContextPath() %>";


        var images = [
            ctx + "/images/background.jpg",
            ctx + "/images/background2.jpg",
            ctx + "/images/background3.jpg",
            ctx + "/images/background4.jpg"
        ];


        for (var i = 0; i < images.length; i++) {
            var img = new Image();
            img.src = images[i];
        }


        var index = 0;
        var showingFirst = true;

        page.style.setProperty("--bg1", 'url("' + images[0] + '")');
        page.style.setProperty("--bg2", 'url("' + images[0] + '")');
        page.style.setProperty("--op1", "1");
        page.style.setProperty("--op2", "0");

        function showNext() {
            var nextIndex = (index + 1) % images.length;

            if (showingFirst) {
                page.style.setProperty("--bg2", 'url("' + images[nextIndex] + '")');
                page.style.setProperty("--op2", "1");
                page.style.setProperty("--op1", "0");
            } else {
                page.style.setProperty("--bg1", 'url("' + images[nextIndex] + '")');
                page.style.setProperty("--op1", "1");
                page.style.setProperty("--op2", "0");
            }

            showingFirst = !showingFirst;
            index = nextIndex;
        }

        setInterval(showNext, 6000);
    })();


</script>
</body>
</html>
