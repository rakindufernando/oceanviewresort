<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%
    String ctx = request.getContextPath();
    String err = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Login</title>
    <link rel="icon" type="image/x-icon" href="images/favicon.png">
    <style>
        :root{
            --blue:#2aa7ff;
            --blueDark:#0f86d6;
            --text:#0b2b3a;
        }

        *{ box-sizing:border-box; }

        body{
            margin:0;
            font-family:Arial, Helvetica, sans-serif;
            color:#fff;
            min-height:100vh;

            background:
                    linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.55)),
                    url("images/background.jpg");
            background-size:cover;
            background-position:center;
            background-repeat:no-repeat;
        }

        header{
            width:100%;
            padding:14px 18px;
            background:rgba(255,255,255,0.10);
            border-bottom:1px solid rgba(255,255,255,0.18);
            backdrop-filter:blur(4px);
        }

        .header-wrap{
            max-width:1100px;
            margin:0 auto;
            display:flex;
            align-items:center;
            justify-content:flex-start;
            gap:12px;
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            min-width:0;
        }

        .logo-img{
            width:44px;
            height:44px;
            object-fit:contain;
            display:block;
        }

        .brand-text{
            display:flex;
            flex-direction:column;
            line-height:1.1;
            min-width:0;
        }

        .hotel-name{
            margin:0;
            font-size:18px;
            font-weight:700;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }

        .sub{
            margin:4px 0 0 0;
            font-size:12.5px;
            color:rgba(255,255,255,0.85);
        }

        .wrap{
            max-width:1100px;
            margin:0 auto;
            padding:24px 18px;
            min-height:calc(100vh - 135px);
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .card{
            width:100%;
            max-width:520px;
            background:rgba(255,255,255,0.92);
            border:1px solid rgba(255,255,255,0.35);
            border-radius:12px;
            padding:18px;
            color:var(--text);
        }

        .card h1, .card h2, .card h3, .card p, .card small{
            color:var(--text);
        }

        label{
            font-size:13px;
            font-weight:700;
            color:#fff;
            display:block;
            margin:10px 0 6px;
        }

        .card label{
            color:rgba(11,43,58,0.90);
        }

        input, select{
            width:100%;
            padding:10px 11px;
            border:1px solid rgba(15,134,214,0.25);
            border-radius:8px;
            outline:none;
            background:#fff;
            color:var(--text);
        }

        form br{ display:none; }

        form input{
            display:block;
            width:100%;
            margin:0 0 12px;
        }

        input:focus, select:focus{
            border-color:rgba(42,167,255,0.75);
            box-shadow:0 0 0 3px rgba(42,167,255,0.20);
        }

        .btn{
            width:100%;
            border:none;
            cursor:pointer;
            padding:12px 16px;
            border-radius:12px;
            background:linear-gradient(180deg, var(--blue), var(--blueDark));
            color:#fff;
            font-weight:800;
            font-size:15px;
            margin-top:14px;
        }

        .btn:active{ transform:translateY(1px); }

        .wrap > div,
        .login-box,
        .login-container,
        .card{
            background: rgba(0,0,0,0.10);
            padding: 22px 24px;
            border-radius: 16px;
            max-width: 720px;
            width: 100%;
            backdrop-filter: blur(4px);
        }

        .wrap > div h1,
        .wrap > div h2,
        .wrap > div p,
        .wrap > div label,
        .login-box h1, .login-box h2, .login-box p, .login-box label,
        .login-container h1, .login-container h2, .login-container p, .login-container label{
            color: #fff !important;
        }

        form label{ margin: 10px 0 6px; }
        form input{ margin: 0 0 12px; }

        footer{
            text-align:center;
            padding:12px 10px;
            background:rgba(255,255,255,0.10);
            border-top:1px solid rgba(255,255,255,0.18);
            color:rgba(255,255,255,0.9);
            font-size:13px;
        }

        footer p{ margin:0; }

        @media (max-width:520px){
            .wrap{ padding:18px 12px; }
            .card{ padding:16px; }
            .hotel-name{ font-size:17px; }
            .logo-img{ width:40px; height:40px; }
        }

    </style>
</head>
<body>
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

<div class="wrap">
    <div class="box">
        <div class="left">
            <h2>Staff Login</h2>
            <p class="small">Enter your username and password to access the system.</p>

            <% if (err != null) { %>
            <div class="err"><%= err %></div>
            <% } %>

            <form method="post" action="<%= ctx %>/login">
                <label>Username</label><br>
                <input type="text" name="username" required><br><br>

                <label>Password</label><br>
                <input type="password" name="password" required><br><br>

                <button class="btn" type="submit">Login</button>
            </form>
        </div>
    </div>
</div>

<footer>
    <p style="margin:0;">
        <span id="year"></span> Ocean View Resort | Hotel Reservation & Billing System
    </p>
    <p style="margin:6px 0 0 0; font-size:12px; opacity:0.9;">
        Developed by Rakindu Fernando
    </p>
</footer>
<script>
    document.getElementById("year").textContent = new Date().getFullYear();

    (function () {
        var target = document.querySelector(".page") || document.body;
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

        target.style.setProperty("--bg1", 'url("' + images[0] + '")');
        target.style.setProperty("--bg2", 'url("' + images[0] + '")');
        target.style.setProperty("--op1", "1");
        target.style.setProperty("--op2", "0");

        function showNext() {
            var nextIndex = (index + 1) % images.length;

            if (showingFirst) {
                target.style.setProperty("--bg2", 'url("' + images[nextIndex] + '")');
                target.style.setProperty("--op2", "1");
                target.style.setProperty("--op1", "0");
            } else {
                target.style.setProperty("--bg1", 'url("' + images[nextIndex] + '")');
                target.style.setProperty("--op1", "1");
                target.style.setProperty("--op2", "0");
            }

            showingFirst = !showingFirst;
            index = nextIndex;
        }

        setInterval(showNext, 6000);
    })();

</script>
</body>
</html>
