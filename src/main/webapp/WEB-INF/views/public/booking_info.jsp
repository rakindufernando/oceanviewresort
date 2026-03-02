<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.*" %>

<%!
    private String mask(String s, int showStart, int showEnd) {
        if (s == null) return "";
        s = s.trim();
        if (s.isEmpty()) return "";
        int n = s.length();
        if (n <= showStart + showEnd) return s;

        String a = s.substring(0, showStart);
        String b = s.substring(n - showEnd);

        StringBuilder mid = new StringBuilder();
        for (int i = 0; i < n - (showStart + showEnd); i++) mid.append("*");
        return a + mid + b;
    }

    private String money(double v) {
        return String.format(java.util.Locale.US, "%,.2f", v);
    }
%>

<%
    String ctx = request.getContextPath();

    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");

    Reservation r = (Reservation) request.getAttribute("reservation");

    Double rate = (Double) request.getAttribute("rate");
    Long nights = (Long) request.getAttribute("nights");
    Double total = (Double) request.getAttribute("total");
    Double paid = (Double) request.getAttribute("paid");
    Double balance = (Double) request.getAttribute("balance");

    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");

    String pResNo = request.getParameter("reservationNo") != null ? request.getParameter("reservationNo") : "";
    String pMobile = request.getParameter("mobile") != null ? request.getParameter("mobile") : "";
    String pNic = request.getParameter("nicPassport") != null ? request.getParameter("nicPassport") : "";

    boolean openFindOnLoad =
            (r != null)
                    || (reservations != null && !reservations.isEmpty())
                    || (error != null && !error.trim().isEmpty())
                    || (msg != null && !msg.trim().isEmpty());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Ocean View Resort | Guest Booking Info</title>
    <link rel="icon" type="image/x-icon" href="<%= ctx %>/images/favicon.png">

    <style>
        :root{
            --blue:#2aa7ff;
            --blue2:#1d93ea;
            --blueDark:#0f86d6;

            --text:#071f2d;
            --muted:#3b6b93;

            --line: rgba(207,230,255,1);
            --soft:#f2f9ff;

            --glass: rgba(255,255,255,0.18);
            --glass2: rgba(255,255,255,0.10);

            --darkGlass: rgba(7,20,30,0.52);
            --darkGlass2: rgba(7,20,30,0.70);

            --shadow: 0 16px 40px rgba(0,0,0,0.10);
            --shadow2: 0 10px 24px rgba(0,0,0,0.08);
        }

        *{ box-sizing:border-box; }
        html{ scroll-behavior:smooth; }

        body{
            margin:0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, Helvetica, sans-serif;
            color: var(--text);
            background: var(--soft);
        }

        a{ color:inherit; }
        img{ max-width:100%; display:block; }

        .wrap{
            width: min(1200px, 100%);
            margin: 0 auto;
            padding: 0 14px;
        }

        .glass{
            background: var(--glass);
            border: 1px solid rgba(255,255,255,0.28);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.10);
        }

        .glass-dark{
            background: linear-gradient(180deg, rgba(7,20,30,0.60), rgba(7,20,30,0.45));
            border-bottom: 1px solid rgba(255,255,255,0.14);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        .topbar{
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 999;
        }

        .topbar-inner{
            display:flex;
            align-items:center;
            gap:14px;
            padding: 10px 0;
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            text-decoration:none;
            min-width: 220px;
        }

        .brand img{
            width: 44px;
            height: 44px;
            object-fit: contain;
            filter: drop-shadow(0 6px 14px rgba(0,0,0,0.22));
        }

        .brand .t1{
            font-weight: 900;
            letter-spacing: 0.2px;
            font-size: 14px;
            line-height: 1.2;
            color: #fff;
        }

        .brand .t2{
            font-size: 12px;
            color: rgba(255,255,255,0.82);
            margin-top: 2px;
        }

        .nav{
            display:flex;
            gap: 8px;
            flex: 1;
            align-items:center;
            overflow: hidden;
        }

        .nav a{
            text-decoration:none;
            font-size: 13px;
            padding: 9px 10px;
            border-radius: 999px;
            color: rgba(255,255,255,0.92);
            white-space: nowrap;
            transition: background 0.18s ease, transform 0.05s ease;
        }
        .nav a:hover{ background: rgba(255,255,255,0.12); }
        .nav a:active{ transform: translateY(1px); }
        .nav a.active{
            background: rgba(255,255,255,0.18);
            border: 1px solid rgba(255,255,255,0.18);
        }

        .actions{
            display:flex;
            align-items:center;
            gap:10px;
            justify-content:flex-end;
        }

        .icon-link{
            width: 40px;
            height: 40px;
            border-radius: 999px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            text-decoration:none;
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.16);
            color: rgba(255,255,255,0.94);
            font-size: 16px;
            transition: background 0.18s ease, transform 0.05s ease;
        }
        .icon-link:hover{ background: rgba(255,255,255,0.16); }
        .icon-link:active{ transform: translateY(1px); }

        .btn{
            border:none;
            cursor:pointer;
            padding: 11px 14px;
            border-radius: 14px;
            font-weight: 900;
            letter-spacing: 0.2px;
            font-size: 13px;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap: 8px;
            text-decoration:none;
            transition: transform 0.05s ease, filter 0.2s ease;
            user-select:none;
        }
        .btn:active{ transform: translateY(1px); }

        .btn-primary{
            background: rgba(42,167,255,0.60);
            border: 1px solid rgba(255,255,255,0.22);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            color: #fff;
        }
        .btn-primary:hover{ filter: brightness(1.03); }

        .btn-ghost{
            background: rgba(255,255,255,0.16);
            border: 1px solid rgba(255,255,255,0.22);
            color: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px) saturate(140%);
            -webkit-backdrop-filter: blur(10px) saturate(140%);
        }

        .nav-toggle{
            display:none;
            border:none;
            background: rgba(255,255,255,0.12);
            color:#fff;
            width: 42px;
            height: 42px;
            border-radius: 14px;
            cursor:pointer;
            font-size: 18px;
        }

        .mobile-nav{
            display:none;
            padding: 10px 0 14px;
        }

        .mobile-nav.show{ display:block; }

        .mobile-nav a{
            display:block;
            padding: 11px 12px;
            border-radius: 14px;
            text-decoration:none;
            color: rgba(255,255,255,0.92);
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.14);
            margin-top: 8px;
            font-size: 13px;
        }

        .hero{
            min-height: 100vh;
            display:flex;
            align-items:flex-end;
            padding: 95px 0 40px;
            position: relative;
            background:
                    radial-gradient(1200px 500px at 10% 10%, rgba(42,167,255,0.22), rgba(0,0,0,0)),
                    linear-gradient(180deg, rgba(6,18,28,0.58), rgba(6,18,28,0.60)),
                    url("<%= ctx %>/images/guest/background01.jpg");
            background-size: cover;
            background-position: center;
            overflow:hidden;
        }

        .hero::before{
            content:"";
            position:absolute;
            inset:-30px;
            background:
                    linear-gradient(90deg, rgba(255,255,255,0.10), rgba(255,255,255,0.00)),
                    radial-gradient(500px 220px at 80% 20%, rgba(255,255,255,0.08), rgba(0,0,0,0));
            pointer-events:none;
            transform: rotate(-2deg);
        }

        .hero::after{
            content:"";
            position:absolute;
            inset:0;
            background: linear-gradient(90deg, rgba(0,0,0,0.60), rgba(0,0,0,0.18) 60%, rgba(0,0,0,0.05));
            pointer-events:none;
        }

        .hero-bg-anim{
            position:absolute;
            inset:0;
            background: transparent;
            pointer-events:none;
            animation: heroZoom 14s ease-in-out infinite alternate;
        }

        .hero .wrap{
            position: relative;
            z-index: 2;
        }

        @keyframes heroZoom{
            from{ transform: scale(1.00); }
            to{ transform: scale(1.05); }
        }

        .hero-card{
            background: transparent;
            border: none;
            box-shadow: none;
            backdrop-filter: none;
            -webkit-backdrop-filter: none;
        }

        .hero h1{
            margin: 0;
            color: #fff;
            font-size: 36px;
            letter-spacing: 0.2px;
            text-shadow: 0 10px 22px rgba(0,0,0,0.50);
        }

        .hero .line{
            margin-top: 8px;
            color: rgba(255,255,255,0.94);
            font-size: 16px;
            font-weight: 800;
        }

        .hero .desc{
            margin-top: 10px;
            color: rgba(255,255,255,0.88);
            font-size: 14px;
            line-height: 1.7;
            text-shadow: 0 10px 20px rgba(0,0,0,0.45);
            max-width: 920px;
        }

        .chips{
            display:flex;
            flex-wrap:wrap;
            gap: 8px;
            margin-top: 12px;
        }

        .chip{
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,0.16);
            border: 1px solid rgba(255,255,255,0.22);
            color: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px) saturate(140%);
            -webkit-backdrop-filter: blur(10px) saturate(140%);
        }

        .hero-btns{
            display:flex;
            gap: 10px;
            flex-wrap:wrap;
            margin-top: 14px;
        }

        .scrollHint{
            margin-top: 12px;
            display:flex;
            align-items:center;
            gap: 8px;
            color: rgba(255,255,255,0.82);
            font-size: 12px;
        }

        .dot{
            width: 8px;
            height: 8px;
            border-radius: 999px;
            background: rgba(255,255,255,0.78);
            box-shadow: 0 0 0 6px rgba(255,255,255,0.10);
            animation: pulse 1.6s ease-in-out infinite;
        }

        @keyframes pulse{
            0%{ transform: scale(1); opacity: 0.9; }
            60%{ transform: scale(1.25); opacity: 0.7; }
            100%{ transform: scale(1); opacity: 0.9; }
        }

        section{
            padding: 58px 0;
        }

        section.alt{
            background: linear-gradient(180deg, rgba(255,255,255,0.0), rgba(255,255,255,0.65));
            border-top: 1px solid rgba(207,230,255,0.55);
            border-bottom: 1px solid rgba(207,230,255,0.55);
        }

        .sec-title{
            font-size: 30px;
            margin: 0 0 10px 0;
            letter-spacing: 0.2px;
        }

        .sec-sub{
            margin: 0 0 18px 0;
            color: var(--muted);
            line-height: 1.65;
            font-size: 14px;
            max-width: 900px;
        }

        .grid2{
            display:grid;
            grid-template-columns: 1.05fr 0.95fr;
            gap: 18px;
            align-items:center;
        }

        .card{
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 20px;
            padding: 16px;
            box-shadow: var(--shadow2);
        }

        .hoverLift{
            transition: transform 0.12s ease, box-shadow 0.12s ease;
        }
        .hoverLift:hover{
            transform: translateY(-3px);
            box-shadow: 0 18px 44px rgba(0,0,0,0.10);
        }

        .img-box{
            border-radius: 20px;
            min-height: 300px;
            background:
                    linear-gradient(180deg, rgba(0,0,0,0.16), rgba(0,0,0,0.16)),
                    url("<%= ctx %>/images/guest/section-about.jpg");
            background-size: cover;
            background-position: center;
            border: 1px solid rgba(255,255,255,0.22);
            box-shadow: var(--shadow2);
        }

        .mini-cards{
            display:grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-top: 12px;
        }

        .mini{
            border-radius: 18px;
            padding: 12px;
            background: #fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        .mini b{ font-size: 13px; display:block; }
        .mini span{ font-size: 12px; color: var(--muted); display:block; margin-top: 6px; line-height: 1.45; }

        .list{
            margin: 10px 0 0 18px;
            color: var(--muted);
            line-height: 1.9;
            font-size: 14px;
        }

        .cards3{
            display:grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .tile{
            border-radius: 20px;
            padding: 14px;
            background: #fff;
            border: 1px solid var(--line);
            min-height: 140px;
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            transition: transform 0.12s ease;
        }
        .tile:hover{ transform: translateY(-2px); }
        .tile b{ display:block; font-size: 14px; }
        .tile p{ margin: 8px 0 0 0; font-size: 13px; color: var(--muted); line-height: 1.65; }

        .exp-card{
            padding: 0;
            overflow: hidden;
        }

        .exp-card b,
        .exp-card p{
            padding: 0 14px;
        }

        .exp-card b{
            padding-top: 14px;
        }

        .exp-card p{
            padding-bottom: 14px;
        }

        .exp-card::before{
            content:"";
            display:block;
            height: 150px;
            background-size: cover;
            background-position: center;
            border-bottom: 1px solid rgba(207,230,255,0.9);
        }

        .exp-card:hover::before{
            filter: brightness(1.02);
        }

        .exp1::before{ background-image: url("<%= ctx %>/images/guest/exp-galle-fort.jpg"); }
        .exp2::before{ background-image: url("<%= ctx %>/images/guest/exp-sunset.jpg"); }
        .exp3::before{ background-image: url("<%= ctx %>/images/guest/exp-beach.jpg"); }
        .exp4::before{ background-image: url("<%= ctx %>/images/guest/exp-culture.jpg"); }
        .exp5::before{ background-image: url("<%= ctx %>/images/guest/exp-daytrip.jpg"); }
        .exp6::before{ background-image: url("<%= ctx %>/images/guest/exp-family.jpg"); }

        .gallery-grid{
            display:grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .g{
            height: 190px;
            border-radius: 20px;
            border: 1px solid var(--line);
            background: #e6f3ff;
            overflow:hidden;
            position:relative;
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            transition: transform 0.12s ease;
        }
        .g:hover{ transform: translateY(-2px); }
        .g::after{
            content:"";
            position:absolute;
            inset:0;
            background: linear-gradient(180deg, rgba(0,0,0,0.0), rgba(0,0,0,0.26));
        }

        .g1{ background-image:url("<%= ctx %>/images/gallery1.jpg"); background-size:cover; background-position:center; }
        .g2{ background-image:url("<%= ctx %>/images/gallery2.jpg"); background-size:cover; background-position:center; }
        .g3{ background-image:url("<%= ctx %>/images/gallery3.jpg"); background-size:cover; background-position:center; }
        .g4{ background-image:url("<%= ctx %>/images/gallery4.jpg"); background-size:cover; background-position:center; }
        .g5{ background-image:url("<%= ctx %>/images/gallery5.jpg"); background-size:cover; background-position:center; }
        .g6{ background-image:url("<%= ctx %>/images/gallery6.jpg"); background-size:cover; background-position:center; }
        .g7{ background-image:url("<%= ctx %>/images/gallery7.jpg"); background-size:cover; background-position:center; }
        .g8{ background-image:url("<%= ctx %>/images/gallery8.jpg"); background-size:cover; background-position:center; }

        .reviews{
            display:grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .review{
            border-radius: 20px;
            padding: 14px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        .review b{ display:block; font-size: 13px; }
        .review p{ margin: 8px 0 0 0; font-size: 13px; color: var(--muted); line-height: 1.65; }
        .review .who{ margin-top: 10px; font-size: 12px; color: #0b4f86; font-weight: 800; }

        .offers{
            display:grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .offer{
            border-radius: 20px;
            padding: 14px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }
        .offer b{ display:block; font-size: 14px; }
        .offer p{ margin: 8px 0 0 0; font-size: 13px; color: var(--muted); line-height: 1.65; }
        .offer .small{ margin-top: 10px; font-size: 12px; color:#0b4f86; font-weight:800; }

        .map{
            border-radius: 20px;
            overflow:hidden;
            border: 1px solid var(--line);
            height: 380px;
            background:#e6f3ff;
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        iframe{ border:0; width:100%; height:100%; }

        .contact-grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .contact-box{
            border-radius: 20px;
            padding: 14px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        .contact-box b{ display:block; font-size: 14px; margin-bottom: 8px; }

        .contact-box div{
            font-size: 13px;
            color: var(--muted);
            line-height: 1.9;
        }

        .form{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 12px;
        }

        .form .full{ grid-column: 1 / -1; }

        label{
            display:block;
            font-size: 12px;
            color:#155a92;
            margin-bottom: 6px;
            font-weight: 900;
        }

        input, textarea{
            width:100%;
            padding: 11px 12px;
            border-radius: 14px;
            border: 1px solid var(--line);
            font-size: 13px;
            outline: none;
            transition: border 0.15s ease, box-shadow 0.15s ease;
            background: #fff;
        }

        input:focus, textarea:focus{
            border: 1px solid rgba(42,167,255,0.7);
            box-shadow: 0 0 0 4px rgba(42,167,255,0.18);
        }

        textarea{ min-height: 110px; resize: vertical; }

        .note{
            font-size: 12px;
            color: var(--muted);
            line-height: 1.65;
            margin-top: 10px;
        }

        .faq{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 10px;
        }

        .qa{
            border-radius: 20px;
            border: 1px solid var(--line);
            background: #fff;
            overflow:hidden;
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        .qa button{
            width:100%;
            text-align:left;
            padding: 13px 14px;
            border:none;
            background:#fff;
            cursor:pointer;
            font-weight: 900;
            color: var(--text);
            font-size: 13px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap: 10px;
        }

        .qa .ans{
            display:none;
            padding: 0 14px 14px 14px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.65;
        }

        .qa.open .ans{ display:block; }
        .qa .ic{ font-weight: 900; color:#0b4f86; }

        .modal{
            position: fixed;
            inset: 0;
            display:none;
            z-index: 200;
        }

        .modal.show{ display:block; }

        .modal-bg{
            position:absolute;
            inset:0;
            background: rgba(0,0,0,0.55);
            opacity: 0;
            animation: fadeIn 0.18s ease forwards;
        }

        @keyframes fadeIn{
            to{ opacity: 1; }
        }

        .modal-panel{
            position:relative;
            width: min(980px, calc(100% - 20px));
            margin: 74px auto 20px;
            border-radius: 24px;
            overflow:hidden;
            border: 1px solid rgba(255,255,255,0.22);
            box-shadow: 0 20px 50px rgba(0,0,0,0.32);
            transform: translateY(14px);
            opacity: 0;
            animation: slideUp 0.20s ease forwards;
        }

        @keyframes slideUp{
            to{
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-head{
            padding: 14px 14px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 10px;
            background: linear-gradient(180deg, rgba(7,20,30,0.72), rgba(7,20,30,0.52));
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        .modal-head h3{
            margin:0;
            color:#fff;
            font-size: 16px;
            letter-spacing: 0.2px;
        }

        .xbtn{
            border:none;
            cursor:pointer;
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.18);
            color:#fff;
            font-size: 18px;
        }

        .modal-body{
            background: rgba(255,255,255,0.95);
            padding: 14px;
        }

        .msg{
            padding: 11px 12px;
            border-radius: 16px;
            border: 1px solid #bfe3ff;
            background: #eef7ff;
            margin-bottom: 12px;
            font-size: 13px;
        }

        .err{
            padding: 11px 12px;
            border-radius: 16px;
            border: 1px solid #ffb3b3;
            background: #fff0f0;
            color: #8a1515;
            margin-bottom: 12px;
            font-size: 13px;
        }

        .lookup{
            border-radius: 20px;
            padding: 14px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        .pillRow{
            display:flex;
            flex-wrap:wrap;
            gap: 8px;
            margin-bottom: 12px;
        }

        .pill{
            font-size: 12px;
            font-weight: 900;
            color: #0b4f86;
            padding: 8px 10px;
            border-radius: 999px;
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.22);
        }

        .row{
            display:flex;
            gap: 10px;
            flex-wrap:wrap;
        }

        .col{
            flex:1;
            min-width: 220px;
        }

        table{
            width:100%;
            border-collapse:collapse;
            margin-top: 10px;
            background:#fff;
            border-radius: 16px;
            overflow:hidden;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
        }

        th, td{
            border-bottom: 1px solid #d6ecff;
            padding: 11px 10px;
            text-align:left;
            font-size: 13px;
        }
        th{
            background:#eef7ff;
            color:#0b4f86;
            font-weight: 900;
        }

        .table-actions a{
            display:inline-flex;
            padding: 8px 10px;
            border-radius: 14px;
            text-decoration:none;
            border: 1px solid var(--line);
            background:#fff;
            font-weight: 900;
            color:#0b4f86;
            font-size: 12px;
        }
        .table-actions a:hover{ background:#eef7ff; }

        .bill{
            margin-top: 12px;
            border-radius: 20px;
            padding: 0;
            background: transparent;
            border: none;
            box-shadow: none;
        }

        .print-actions{
            display:flex;
            gap: 10px;
            flex-wrap:wrap;
            margin-top: 12px;
        }

        .modal-panel{
            max-height: calc(100vh - 110px);
            display: flex;
            flex-direction: column;
        }

        .modal-body{
            overflow: auto;
            max-height: calc(100vh - 190px);
            overscroll-behavior: contain;
        }

        .invPaper{
            background:#fff;
            border: 1px solid #d7e7ff;
            border-radius: 18px;
            padding: 18px;
        }

        .invTop{
            display:flex;
            justify-content:space-between;
            gap:16px;
            flex-wrap:wrap;
            align-items:flex-start;
        }

        .invBrand{
            display:flex;
            gap:12px;
            align-items:flex-start;
        }

        .invLogo{
            width:62px;
            height:62px;
            object-fit:contain;
        }

        .invHotel{
            font-weight:900;
            font-size:18px;
            letter-spacing:0.2px;
        }

        .invSmall{
            font-size:12px;
            color:#444;
            line-height:1.6;
        }

        .invTitle{
            font-size:44px;
            font-weight:900;
            letter-spacing:2px;
            text-align:right;
        }

        .invMeta{
            margin-top:10px;
            font-size:13px;
            display:grid;
            gap:6px;
            justify-items:end;
        }

        .invMetaRow{
            display:grid;
            grid-template-columns:auto auto;
            gap:14px;
        }

        .invMetaRow .k{
            font-weight:900;
            text-align:right;
            white-space:nowrap;
        }

        .invMetaRow .v{
            text-align:left;
            white-space:nowrap;
        }

        .invMid{
            display:flex;
            justify-content:space-between;
            gap:16px;
            flex-wrap:wrap;
            margin-top:16px;
            padding-top:10px;
            border-top: 1px solid #e7f2ff;
        }

        .invBox{
            min-width:240px;
        }

        .invLabel{
            font-size:12px;
            font-weight:900;
            margin-bottom:6px;
            color:#111;
        }

        .invName{
            font-size:14px;
            font-weight:900;
            margin-bottom:2px;
        }

        .invTable{
            width:100%;
            border-collapse:collapse;
            margin-top:16px;
            border: 1px solid #d7e7ff;
            border-radius: 14px;
            overflow:hidden;
        }

        .invTable th{
            background:#f2f9ff;
            color:#111;
            font-weight:900;
            font-size:12px;
            padding:10px;
            border-bottom: 1px solid #d7e7ff;
        }

        .invTable td{
            font-size:12.5px;
            padding:10px;
            border-bottom: 1px solid #eef6ff;
        }

        .invTable tr:last-child td{
            border-bottom:none;
        }

        .invTable .r{ text-align:right; }
        .invTable .c{ text-align:center; }

        .invTotals{
            display:flex;
            justify-content:space-between;
            gap:16px;
            flex-wrap:wrap;
            margin-top:16px;
            padding-top:10px;
            border-top: 1px solid #e7f2ff;
        }

        .invSum{
            min-width:260px;
            margin-left:auto;
        }

        .sumRow{
            display:flex;
            justify-content:space-between;
            gap:10px;
            padding:6px 0;
            font-size:13px;
        }

        .sumRow span:first-child{
            font-weight:900;
        }

        .sumRow.total{
            border-top: 1px solid #d7e7ff;
            padding-top:10px;
            margin-top:6px;
            font-size:14px;
        }

        .invTerms{
            margin-top:16px;
            padding-top:10px;
            border-top: 1px solid #e7f2ff;
        }

        .invFoot{
            margin-top:18px;
            font-size:11px;
            color:#666;
            display:flex;
            justify-content:space-between;
            gap:10px;
            flex-wrap:wrap;
        }

        .dining-card{
            padding: 0;
            overflow: hidden;
        }

        .dining-card b,
        .dining-card p{
            padding: 0 14px;
        }

        .dining-card b{
            padding-top: 14px;
        }

        .dining-card p{
            padding-bottom: 14px;
        }

        .dining-card::before{
            content:"";
            display:block;
            height: 150px;
            background-size: cover;
            background-position: center;
            border-bottom: 1px solid rgba(207,230,255,0.9);
        }

        .din1::before{ background-image: url("<%= ctx %>/images/guest/dining-all-day.jpg"); }
        .din2::before{ background-image: url("<%= ctx %>/images/guest/dining-seafood.jpg"); }
        .din3::before{ background-image: url("<%= ctx %>/images/guest/dining-drinks.jpg"); }

        @media (max-width: 1100px){
            .nav{ display:none; }
            .nav-toggle{ display:inline-flex; align-items:center; justify-content:center; }
            .topbar-inner{ justify-content:space-between; }
        }

        @media (max-width: 900px){
            .facts-grid{ grid-template-columns: 1fr 1fr; }
            .grid2{ grid-template-columns: 1fr; }
            .mini-cards{ grid-template-columns: 1fr 1fr; }
            .cards3{ grid-template-columns: 1fr; }
            .gallery-grid{ grid-template-columns: 1fr 1fr; }
            .reviews{ grid-template-columns: 1fr 1fr; }
            .offers{ grid-template-columns: 1fr; }
            .contact-grid{ grid-template-columns: 1fr; }
            .faq{ grid-template-columns: 1fr; }
            .hero h1{ font-size: 30px; }
        }



        @media (max-width: 520px){
            .brand{ min-width: 0; }
            .actions{ gap: 8px; flex-wrap:wrap; }
            .btn{ width: 100%; justify-content:center; }
            .icon-link{ width: 42px; height: 42px; }
            .lineSig{ width: 48%; }
        }


        .stay-layout{
            display:grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 14px;
            align-items: stretch;
        }

        .stay-grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .stay-img{
            border-radius: 18px;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            background-size: cover;
            background-position: center;
            min-height: 140px;
            overflow:hidden;
            transition: transform 0.12s ease;
        }

        .stay-img:hover{
            transform: translateY(-2px);
        }

        .s1{ background-image: url("<%= ctx %>/images/guest/stay1.jpg"); }
        .s2{ background-image: url("<%= ctx %>/images/guest/stay2.jpg"); }
        .s3{ background-image: url("<%= ctx %>/images/guest/stay3.jpg"); }
        .s4{ background-image: url("<%= ctx %>/images/guest/stay4.jpg"); }

        @media (max-width: 900px){
            .stay-layout{
                grid-template-columns: 1fr;
            }
            .stay-img{
                min-height: 160px;
            }
        }

        .g{
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .g1{ background-image: url("<%= ctx %>/images/guest/gallery/gallery1.jpg"); }
        .g2{ background-image: url("<%= ctx %>/images/guest/gallery/gallery2.jpg"); }
        .g3{ background-image: url("<%= ctx %>/images/guest/gallery/gallery3.jpg"); }
        .g4{ background-image: url("<%= ctx %>/images/guest/gallery/gallery4.jpg"); }
        .g5{ background-image: url("<%= ctx %>/images/guest/gallery/gallery5.jpg"); }
        .g6{ background-image: url("<%= ctx %>/images/guest/gallery/gallery6.jpg"); }
        .g7{ background-image: url("<%= ctx %>/images/guest/gallery/gallery7.jpg"); }
        .g8{ background-image: url("<%= ctx %>/images/guest/gallery/gallery8.jpg"); }



        .offersGrid{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 14px;
        }

        .offerCard{
            border-radius: 22px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            overflow:hidden;
            transition: transform 0.12s ease, box-shadow 0.12s ease;
        }

        .offerCard:hover{
            transform: translateY(-2px);
            box-shadow: 0 18px 44px rgba(0,0,0,0.10);
        }

        .offerCover{
            height: 150px;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            border-bottom: 1px solid rgba(207,230,255,0.9);
        }

        .oc1 .offerCover{ background-image: url("<%= ctx %>/images/guest/offers/offer-longstay.jpg"); }
        .oc2 .offerCover{ background-image: url("<%= ctx %>/images/guest/offers/offer-midweek.jpg"); }
        .oc3 .offerCover{ background-image: url("<%= ctx %>/images/guest/offers/offer-dining.jpg"); }
        .oc4 .offerCover{ background-image: url("<%= ctx %>/images/guest/offers/offer-local.jpg"); }

        .offerBody{
            padding: 14px;
        }

        .offerTop{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 10px;
        }

        .offerBadge{
            font-size: 12px;
            font-weight: 900;
            color: #0b4f86;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.22);
            white-space: nowrap;
        }

        .offerText{
            margin: 10px 0 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .offerList{
            margin: 10px 0 0 18px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.8;
        }

        .offerMeta{
            margin-top: 12px;
            display:grid;
            gap: 8px;
            font-size: 12px;
            color: var(--muted);
        }

        .offerMeta > div{
            background:#eef7ff;
            border: 1px solid #d6ecff;
            padding: 8px 10px;
            border-radius: 14px;
        }

        .offerActions{
            margin-top: 12px;
            display:flex;
            gap: 10px;
            flex-wrap:wrap;
        }

        @media (max-width: 520px){
            .offerActions .btn{
                width: 100%;
                justify-content:center;
            }
        }

        .fieldErr{
            font-size: 12px;
            color: #8a1515;
            margin-top: 6px;
            min-height: 14px;
        }

        .inputBad{
            border: 1px solid #ff9f9f !important;
            box-shadow: 0 0 0 4px rgba(255, 120, 120, 0.15) !important;
        }

        .toast{
            position: fixed;
            left: 0;
            right: 0;
            bottom: 20px;
            display: none;
            justify-content: center;
            z-index: 9999;
            padding: 0 14px;
        }

        .toast.show{
            display: flex;
        }

        .toastBox{
            width: min(520px, 100%);
            background: rgba(7,20,30,0.86);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 18px;
            padding: 14px 16px;
            box-shadow: 0 18px 44px rgba(0,0,0,0.25);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            animation: toastUp 0.18s ease forwards;
        }

        .toastTitle{
            font-weight: 900;
            font-size: 14px;
        }

        .toastText{
            margin-top: 4px;
            font-size: 13px;
            color: rgba(255,255,255,0.88);
            line-height: 1.5;
        }

        @keyframes toastUp{
            from{ transform: translateY(10px); opacity: 0; }
            to{ transform: translateY(0); opacity: 1; }
        }

        .reviews2{
            display:grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .reviewCard{
            border-radius: 22px;
            padding: 16px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            transition: transform 0.12s ease, box-shadow 0.12s ease;
        }

        .reviewCard:hover{
            transform: translateY(-2px);
            box-shadow: 0 18px 44px rgba(0,0,0,0.10);
        }

        .revTop{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap: 12px;
        }

        .revTop b{
            display:block;
            font-size: 14px;
            line-height: 1.35;
        }

        .stars{
            font-size: 13px;
            font-weight: 900;
            color: #0b4f86;
            white-space: nowrap;
        }

        .reviewCard p{
            margin: 10px 0 0 0;
            font-size: 13px;
            color: var(--muted);
            line-height: 1.7;
        }

        .revMeta{
            margin-top: 12px;
            display:flex;
            flex-wrap:wrap;
            gap: 8px;
        }

        .tag{
            font-size: 12px;
            font-weight: 800;
            color: #0b4f86;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.22);
        }

        .whoLine{
            margin-top: 12px;
            display:flex;
            gap: 8px;
            align-items:center;
            font-size: 12px;
            color: var(--muted);
        }

        .who{
            font-weight: 900;
            color:#0b4f86;
        }

        .sep{
            opacity: 0.6;
        }

        .reviewNote{
            margin-top: 12px;
            font-size: 12px;
            color: var(--muted);
        }

        @media (max-width: 900px){
            .reviews2{
                grid-template-columns: 1fr;
            }
        }

        @media print{
            @page{
                size: A4;
                margin: 12mm;
            }

            .footerNew{
                display:none !important;
            }

            html, body{
                margin: 0 !important;
                padding: 0 !important;
                background: #fff !important;
                height: auto !important;
                overflow: visible !important;
            }

            .topbar,
            section,
            .modal-bg,
            .modal-head,
            .print-actions,
            .lookup,
            .pillRow,
            .msg,
            .err{
                display: none !important;
            }

            #findModal{
                display: block !important;
                position: static !important;
                inset: auto !important;
                height: auto !important;
            }

            #findModal .modal-panel{
                position: static !important;
                margin: 0 !important;
                max-height: none !important;
                border: none !important;
                box-shadow: none !important;
                overflow: visible !important;
                transform: none !important;
                opacity: 1 !important;
                animation: none !important;
            }

            #findModal .modal-body{
                max-height: none !important;
                overflow: visible !important;
                padding: 0 !important;
                background: #fff !important;
            }

            #billPrintArea{
                display: block !important;
                visibility: visible !important;
                width: 100% !important;
                margin: 0 !important;
            }

            #billPrintArea,
            #billPrintArea *{
                visibility: visible !important;
            }
            .no-print{
                display:none !important;
            }
        }

        .facGrid{
            display:grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .facCard{
            border-radius: 22px;
            background:#fff;
            border: 1px solid var(--line);
            box-shadow: 0 10px 22px rgba(0,0,0,0.06);
            padding: 16px;
            transition: transform 0.12s ease, box-shadow 0.12s ease;
        }

        .facCard:hover{
            transform: translateY(-2px);
            box-shadow: 0 18px 44px rgba(0,0,0,0.10);
        }

        .facTop{
            display:flex;
            align-items:center;
            gap: 10px;
        }

        .facIcon{
            width: 40px;
            height: 40px;
            border-radius: 14px;
            display:flex;
            align-items:center;
            justify-content:center;
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.22);
            font-size: 18px;
        }

        .facTop b{
            font-size: 14px;
            line-height: 1.35;
        }

        .facCard p{
            margin: 10px 0 0 0;
            font-size: 13px;
            color: var(--muted);
            line-height: 1.7;
        }

        .facList{
            margin: 10px 0 0 18px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.8;
        }

        .facTagRow{
            margin-top: 12px;
            display:flex;
            flex-wrap:wrap;
            gap: 8px;
        }

        .facTag{
            font-size: 12px;
            font-weight: 800;
            color: #0b4f86;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.22);
        }

        @media (max-width: 900px){
            .facGrid{
                grid-template-columns: 1fr;
            }
        }


        .footerNew{
            position: relative;
            padding: 30px 0 18px;
            color: rgba(255,255,255,0.92);
            background: linear-gradient(180deg, #050b10, #07131c);
            border-top: 1px solid rgba(42,167,255,0.22);
            overflow: hidden;
        }

        .footerBgArt{
            position: absolute;
            inset: 0;
            background:
                    radial-gradient(700px 260px at 15% 10%, rgba(42,167,255,0.22), rgba(0,0,0,0)),
                    radial-gradient(700px 260px at 85% 25%, rgba(15,134,214,0.18), rgba(0,0,0,0)),
                    linear-gradient(180deg, rgba(255,255,255,0.04), rgba(0,0,0,0));
            opacity: 0.85;
            pointer-events: none;
        }

        .footerNew .wrap{
            position: relative;
            z-index: 2;
        }

        .footerTop{
            display: grid;
            grid-template-columns: 1.25fr 1.15fr 0.8fr;
            gap: 18px;
            align-items: start;
            padding-bottom: 18px;
            border-bottom: 1px solid rgba(255,255,255,0.10);
        }

        .footBrand{
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }

        .footLogo{
            width: 54px;
            height: 54px;
            object-fit: contain;
            filter: drop-shadow(0 12px 24px rgba(0,0,0,0.30));
        }

        .footTitle{
            font-weight: 900;
            font-size: 16px;
            letter-spacing: 0.2px;
        }

        .footSub{
            margin-top: 2px;
            font-size: 12px;
            color: rgba(255,255,255,0.70);
        }

        .footDesc{
            margin-top: 10px;
            font-size: 12px;
            color: rgba(255,255,255,0.80);
            line-height: 1.7;
            max-width: 420px;
        }

        .footHead{
            font-weight: 900;
            font-size: 13px;
            letter-spacing: 0.2px;
            color: rgba(255,255,255,0.92);
        }

        .footNewsletter .footRow{
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .footInput{
            flex: 1;
            min-width: 220px;
            padding: 12px 12px;
            border-radius: 14px;
            border: 1px solid rgba(42,167,255,0.25);
            background: rgba(255,255,255,0.06);
            color: #fff;
            outline: none;
            box-shadow: 0 12px 26px rgba(0,0,0,0.25);
        }

        .footInput::placeholder{
            color: rgba(255,255,255,0.60);
        }

        .footInput:focus{
            border: 1px solid rgba(42,167,255,0.55);
            box-shadow: 0 0 0 4px rgba(42,167,255,0.18), 0 12px 26px rgba(0,0,0,0.28);
        }

        .footBtn{
            padding: 12px 16px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.14);
            background: linear-gradient(180deg, #2aa7ff, #0f86d6);
            color: #fff;
            font-weight: 900;
            cursor: pointer;
            box-shadow: 0 14px 28px rgba(42,167,255,0.18);
            transition: transform 0.12s ease, filter 0.12s ease;
        }

        .footBtn:hover{
            transform: translateY(-2px);
            filter: brightness(1.05);
        }

        .footHint{
            margin-top: 8px;
            font-size: 12px;
            color: rgba(255,255,255,0.65);
        }

        .socialRow{
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .soc{
            width: 40px;
            height: 40px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: #d8efff;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.14);
            font-weight: 900;
            box-shadow: 0 12px 26px rgba(0,0,0,0.25);
            transition: transform 0.12s ease, background 0.12s ease, border 0.12s ease;
        }

        .soc:hover{
            transform: translateY(-2px);
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.30);
        }

        .footerGrid{
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            padding-top: 18px;
        }

        .footCol{
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.10);
            border-radius: 18px;
            padding: 14px;
            box-shadow: 0 14px 30px rgba(0,0,0,0.28);
        }

        .footText{
            margin-top: 10px;
            font-size: 12px;
            color: rgba(255,255,255,0.78);
            line-height: 1.75;
        }

        .footLink{
            display: block;
            margin-top: 9px;
            font-size: 12px;
            color: rgba(255,255,255,0.78);
            text-decoration: none;
            transition: color 0.12s ease, transform 0.12s ease;
        }

        .footLink:hover{
            color: #2aa7ff;
            transform: translateX(2px);
        }

        .footerBottom{
            margin-top: 16px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.10);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            font-size: 12px;
            color: rgba(255,255,255,0.68);
        }

        .backTop{
            color: rgba(255,255,255,0.90);
            text-decoration: none;
            font-weight: 900;
            padding: 10px 12px;
            border-radius: 14px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.14);
            box-shadow: 0 12px 26px rgba(0,0,0,0.25);
            transition: transform 0.12s ease, background 0.12s ease, border 0.12s ease;
        }

        .backTop:hover{
            transform: translateY(-2px);
            background: rgba(42,167,255,0.12);
            border: 1px solid rgba(42,167,255,0.30);
        }

        @media (max-width: 900px){
            .footerTop{
                grid-template-columns: 1fr;
            }
            .footerGrid{
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 520px){
            .footerGrid{
                grid-template-columns: 1fr;
            }
            .footBtn{
                width: 100%;
            }
            .soc{
                width: 38px;
                height: 38px;
            }
        }
    </style>
</head>

<body>

<div class="topbar glass-dark">
    <div class="wrap">
        <div class="topbar-inner">
            <a class="brand" href="#home">
                <img src="<%= ctx %>/images/Ocean View Resort Logo.png" alt="Ocean View Resort">
                <div>
                    <div class="t1">Ocean View Resort</div>
                    <div class="t2">Galle Sri Lanka</div>
                </div>
            </a>

            <nav class="nav" id="mainNav">
                <a href="#home" data-sec="home">Home</a>
                <a href="#about" data-sec="about">About</a>
                <a href="#stay" data-sec="stay">Stay</a>
                <a href="#dining" data-sec="dining">Dining</a>
                <a href="#experiences" data-sec="experiences">Experiences</a>
                <a href="#facilities" data-sec="facilities">Facilities</a>
                <a href="#gallery" data-sec="gallery">Gallery</a>
                <a href="#reviews" data-sec="reviews">Reviews</a>
                <a href="#offers" data-sec="offers">Offers</a>
                <a href="#location" data-sec="location">Location</a>
                <a href="#faq" data-sec="faq">FAQ</a>
                <a href="#contact" data-sec="contact">Contact</a>
            </nav>

            <div class="actions">
                <a class="icon-link" href="tel:+94911234567" title="Call">📞</a>
                <a class="icon-link" href="https://wa.me/94911234567" target="_blank" title="WhatsApp">💬</a>
                <a class="icon-link" href="mailto:info@oceanviewresort.lk" title="Email">✉️</a>
                <button class="btn btn-primary" id="openFindBtn">Find Reservation</button>
            </div>

            <button class="nav-toggle" id="navToggle">☰</button>
        </div>

        <div class="mobile-nav" id="mobileNav">
            <a href="#home">Home</a>
            <a href="#about">About</a>
            <a href="#stay">Stay</a>
            <a href="#dining">Dining</a>
            <a href="#experiences">Experiences</a>
            <a href="#facilities">Facilities</a>
            <a href="#gallery">Gallery</a>
            <a href="#reviews">Reviews</a>
            <a href="#offers">Offers</a>
            <a href="#location">Location</a>
            <a href="#faq">FAQ</a>
            <a href="#contact">Contact</a>
        </div>
    </div>
</div>

<section class="hero" id="home">
    <div class="hero-bg-anim"></div>
    <div class="wrap">
        <div class="hero-card">
            <h1>Ocean View Resort Galle</h1>
            <div class="line">Beachfront comfort, warm Sri Lankan hospitality, and sunsets over the Indian Ocean.</div>
            <div class="desc">
                Stay steps away from the shoreline and enjoy a relaxed coastal atmosphere designed for couples, families, and small groups.
                From morning sea views to evening dining, everything is built around a calm beachside experience.
            </div>

            <div class="chips">
                <span class="chip">Beachfront location</span>
                <span class="chip">Family friendly service</span>
                <span class="chip">Dining with ocean breeze</span>
                <span class="chip">Easy access to Galle Fort</span>
            </div>

            <div class="hero-btns">
                <button class="btn btn-primary" id="heroFindBtn">Find Reservation</button>
                <a class="btn btn-ghost" href="tel:+94911234567">Call Us</a>
                <a class="btn btn-ghost" href="#gallery">View Gallery</a>
            </div>

            <div class="scrollHint">
                <span class="dot"></span>
                <span>Scroll to explore the resort</span>
            </div>
        </div>
    </div>
</section>

<section id="about" class="alt">
    <div class="wrap">
        <h2 class="sec-title">A beachside stay in historic Galle</h2>
        <p class="sec-sub">
            Ocean View Resort is a popular coastal hotel in Galle welcoming local and international guests throughout the year.
            Our focus is simple clean rooms, friendly service, great food, and a peaceful oceanfront setting.
        </p>

        <div class="grid2">
            <div class="card hoverLift">
                <b style="display:block; font-size:14px; color:#0b4f86;">What we focus on</b>
                <ul class="list">
                    <li>Genuine hospitality</li>
                    <li>Comfort first</li>
                    <li>Clean and safe environment</li>
                    <li>Respect for local culture and nature</li>
                </ul>

                <div class="mini-cards">
                    <div class="mini">
                        <b>Hospitality</b>
                        <span>Friendly service and clear communication</span>
                    </div>
                    <div class="mini">
                        <b>Comfort</b>
                        <span>Essentials for a relaxing beach stay</span>
                    </div>
                    <div class="mini">
                        <b>Cleanliness</b>
                        <span>Daily housekeeping and safe property</span>
                    </div>
                    <div class="mini">
                        <b>Local care</b>
                        <span>Respect for the area and community</span>
                    </div>
                </div>
            </div>

            <div class="img-box" aria-label="About image"></div>
        </div>
    </div>
</section>

<section id="stay">
    <div class="wrap">
        <h2 class="sec-title">Stay with comfort by the sea</h2>
        <p class="sec-sub">
            Our accommodation is designed for rest after beach time and exploring the south coast. Expect essentials that matter most for a comfortable stay.
        </p>

        <div class="stay-layout">
            <div class="card hoverLift">
                <ul class="list">
                    <li>Air conditioning and fresh linen</li>
                    <li>Wifi in rooms and public areas</li>
                    <li>Hot water and daily housekeeping</li>
                    <li>In room tea and coffee setup</li>
                    <li>Balcony or outdoor seating in selected rooms</li>
                    <li>Front desk support for guest requests</li>
                </ul>
            </div>

            <div class="stay-grid">
                <div class="stay-img s1"></div>
                <div class="stay-img s2"></div>
                <div class="stay-img s3"></div>
                <div class="stay-img s4"></div>
            </div>
        </div>
    </div>
</section>

<section id="dining" class="alt">
    <div class="wrap">
        <h2 class="sec-title">Dining and drinks</h2>
        <p class="sec-sub">
            Enjoy Sri Lankan flavours and international favourites, with fresh seafood options inspired by the south coast.
            Choose relaxed meals by the ocean breeze or a quiet table indoors.
        </p>

        <div class="cards3">
            <div class="tile dining-card din1">
                <b>All day dining</b>
                <p>Breakfast, lunch, and dinner options with simple comfort meals.</p>
            </div>
            <div class="tile dining-card din2">
                <b>Seafood and local specials</b>
                <p>Fresh dishes inspired by coastal Sri Lanka and local markets.</p>
            </div>
            <div class="tile dining-card din3">
                <b>Light bites and beverages</b>
                <p>Snacks, tea, coffee, and refreshing drinks during the day.</p>
            </div>
        </div>
    </div>
</section>

<section id="experiences">
    <div class="wrap">
        <h2 class="sec-title">Things to do around Galle</h2>
        <p class="sec-sub">
            Your stay is perfectly placed for beaches, heritage, and day trips. The south coast is most popular for beach weather roughly from December to April.
        </p>

        <div class="cards3">
            <div class="tile exp-card exp1">
                <b>Galle Fort heritage walk</b>
                <p>Explore the Old Town of Galle and its fortifications with iconic views.</p>
            </div>
            <div class="tile exp-card exp2">
                <b>Sunset by the ramparts</b>
                <p>An easy evening plan with ocean views and landmarks inside the fort area.</p>
            </div>
            <div class="tile exp-card exp3">
                <b>South coast beaches</b>
                <p>Relax on nearby beaches and enjoy safe sea activities when conditions are suitable.</p>
            </div>
        </div>

        <div style="margin-top:12px;" class="cards3">
            <div class="tile exp-card exp4">
                <b>Culture and local life</b>
                <p>Visit museums, cafés, crafts, and local markets for a deeper feel of the region.</p>
            </div>
            <div class="tile exp-card exp5">
                <b>Day trip support</b>
                <p>Ask the front desk for taxi arrangements and simple trip planning help.</p>
            </div>
            <div class="tile exp-card exp6">
                <b>Family friendly moments</b>
                <p>Short trips and beach time that work well for families and small groups.</p>
            </div>
        </div>
    </div>
</section>

<section id="facilities" class="alt">
    <div class="wrap">
        <h2 class="sec-title">Facilities made for a smooth stay</h2>
        <p class="sec-sub">Small services that help your stay feel easy and comfortable.</p>

        <div class="facGrid">
            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🛎</div>
                    <b>Front desk support</b>
                </div>
                <p>Help for requests, directions, and simple guest support during your stay.</p>
                <ul class="facList">
                    <li>Check in help and guidance</li>
                    <li>Local travel tips on request</li>
                    <li>Quick help for guest issues</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">Daily support</span>
                    <span class="facTag">Friendly service</span>
                </div>
            </div>

            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🚕</div>
                    <b>Airport and taxi arrangements</b>
                </div>
                <p>Guidance and contacts for reliable transport options around the south coast.</p>
                <ul class="facList">
                    <li>Airport pickup on request</li>
                    <li>Taxi contacts for day trips</li>
                    <li>Helpful directions and timing</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">Transport help</span>
                    <span class="facTag">Day trips</span>
                </div>
            </div>

            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🧺</div>
                    <b>Laundry service</b>
                </div>
                <p>Available on request for longer stays and guests who need extra comfort.</p>
                <ul class="facList">
                    <li>Same day service on request</li>
                    <li>Simple pricing at desk</li>
                    <li>Ideal for long stays</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">On request</span>
                    <span class="facTag">Long stays</span>
                </div>
            </div>

            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🌿</div>
                    <b>Outdoor relaxation spaces</b>
                </div>
                <p>Enjoy calm seating areas with a sea breeze and a relaxed coastal mood.</p>
                <ul class="facList">
                    <li>Garden and outdoor seating</li>
                    <li>Quiet areas for reading</li>
                    <li>Best for sunset time</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">Calm vibe</span>
                    <span class="facTag">Sea breeze</span>
                </div>
            </div>

            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🛡</div>
                    <b>Safety focused standards</b>
                </div>
                <p>Basic property safety and guest comfort guidelines to support a secure stay.</p>
                <ul class="facList">
                    <li>Clean and maintained areas</li>
                    <li>Clear guest support process</li>
                    <li>Simple safety checks</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">Guest care</span>
                    <span class="facTag">Comfort first</span>
                </div>
            </div>

            <div class="facCard">
                <div class="facTop">
                    <div class="facIcon">🎉</div>
                    <b>Event and group support</b>
                </div>
                <p>Available on request depending on dates and capacity for small groups.</p>
                <ul class="facList">
                    <li>Small group stays</li>
                    <li>Basic support for plans</li>
                    <li>Advance notice recommended</li>
                </ul>
                <div class="facTagRow">
                    <span class="facTag">Groups</span>
                    <span class="facTag">On request</span>
                </div>
            </div>
        </div>

        <div class="note" style="margin-top:12px;">
            Some services are available on request based on timing and availability. Please contact the front desk for confirmation.
        </div>
    </div>
</section>

<section id="gallery">
    <div class="wrap">
        <h2 class="sec-title">Gallery</h2>
        <p class="sec-sub">A quick look at the resort, the ocean view, and the Galle vibe.</p>

        <div class="gallery-grid">
            <div class="g g1"></div>
            <div class="g g2"></div>
            <div class="g g3"></div>
            <div class="g g4"></div>
            <div class="g g5"></div>
            <div class="g g6"></div>
            <div class="g g7"></div>
            <div class="g g8"></div>
        </div>
    </div>
</section>

<section id="reviews" class="alt">
    <div class="wrap">
        <h2 class="sec-title">Guest words</h2>
        <p class="sec-sub">Real feedback helps future guests feel confident.</p>

        <div class="reviews2">
            <div class="reviewCard">
                <div class="revTop">
                    <b>Peaceful and clean with a great view</b>
                    <div class="stars">★★★★★</div>
                </div>
                <p>
                    Nice calm atmosphere and comfortable room for a beach trip. The room was clean when we arrived and the view was really relaxing in the evening.
                </p>
                <div class="revMeta">
                    <span class="tag">Clean rooms</span>
                    <span class="tag">Quiet stay</span>
                    <span class="tag">Ocean view</span>
                </div>
                <div class="whoLine">
                    <span class="who">Guest review</span>
                    <span class="sep">•</span>
                    <span class="small">Couple stay</span>
                </div>
            </div>

            <div class="reviewCard">
                <div class="revTop">
                    <b>Staff were friendly and helpful throughout</b>
                    <div class="stars">★★★★★</div>
                </div>
                <p>
                    Good communication and quick support when we needed anything. The front desk answered questions politely and helped with transport details.
                </p>
                <div class="revMeta">
                    <span class="tag">Helpful staff</span>
                    <span class="tag">Quick support</span>
                    <span class="tag">Good service</span>
                </div>
                <div class="whoLine">
                    <span class="who">Guest review</span>
                    <span class="sep">•</span>
                    <span class="small">Family trip</span>
                </div>
            </div>

            <div class="reviewCard">
                <div class="revTop">
                    <b>Perfect base for Galle Fort visits</b>
                    <div class="stars">★★★★☆</div>
                </div>
                <p>
                    Easy access to main attractions and beaches around the area. We could plan short day trips and come back for a peaceful rest at night.
                </p>
                <div class="revMeta">
                    <span class="tag">Great location</span>
                    <span class="tag">Day trips</span>
                    <span class="tag">Easy travel</span>
                </div>
                <div class="whoLine">
                    <span class="who">Guest review</span>
                    <span class="sep">•</span>
                    <span class="small">Friends group</span>
                </div>
            </div>

            <div class="reviewCard">
                <div class="revTop">
                    <b>Food was fresh and enjoyable</b>
                    <div class="stars">★★★★☆</div>
                </div>
                <p>
                    We enjoyed local flavours and seafood options during the stay. Breakfast was simple but fresh and the dining area felt comfortable.
                </p>
                <div class="revMeta">
                    <span class="tag">Fresh food</span>
                    <span class="tag">Local flavours</span>
                    <span class="tag">Good dining</span>
                </div>
                <div class="whoLine">
                    <span class="who">Guest review</span>
                    <span class="sep">•</span>
                    <span class="small">Weekend stay</span>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="offers">
    <div class="wrap">
        <h2 class="sec-title">Special offers</h2>
        <p class="sec-sub">Offers may change based on dates and availability.</p>

        <div class="offersGrid">
            <div class="offerCard oc1">
                <div class="offerCover"></div>
                <div class="offerBody">
                    <div class="offerTop">
                        <b>Long stay savings</b>
                        <span class="offerBadge">Save 10%</span>
                    </div>

                    <p class="offerText">Ideal for guests staying 3 nights or more with stable plans.</p>

                    <ul class="offerList">
                        <li>10% off room total</li>
                        <li>Breakfast included</li>
                        <li>Late checkout on request</li>
                    </ul>

                    <div class="offerMeta">
                        <div>Promo code - LONGSTAY</div>
                        <div>Valid Sun to Thu</div>
                    </div>

                    <div class="offerActions">
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="#contact">Ask us</a>
                    </div>
                </div>
            </div>

            <div class="offerCard oc2">
                <div class="offerCover"></div>
                <div class="offerBody">
                    <div class="offerTop">
                        <b>Early week getaway deal</b>
                        <span class="offerBadge">Save 12%</span>
                    </div>

                    <p class="offerText">Mid week stays are a calm option to enjoy the south coast.</p>

                    <ul class="offerList">
                        <li>12% off Mon to Wed check in</li>
                        <li>Welcome drink on arrival</li>
                        <li>Best for couples and small groups</li>
                    </ul>

                    <div class="offerMeta">
                        <div>Promo code - MIDWEEK</div>
                        <div>Subject to room availability</div>
                    </div>

                    <div class="offerActions">
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="#contact">Ask us</a>
                    </div>
                </div>
            </div>

            <div class="offerCard oc3">
                <div class="offerCover"></div>
                <div class="offerBody">
                    <div class="offerTop">
                        <b>Seasonal dining bundle</b>
                        <span class="offerBadge">Dinner deal</span>
                    </div>

                    <p class="offerText">Enjoy a package including meals and relaxing dining times.</p>

                    <ul class="offerList">
                        <li>Set dinner once per stay</li>
                        <li>Complimentary dessert</li>
                        <li>Seafood or local menu options</li>
                    </ul>

                    <div class="offerMeta">
                        <div>Promo code - DINESEA</div>
                        <div>Dates and menu may vary</div>
                    </div>

                    <div class="offerActions">
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="#contact">Ask us</a>
                    </div>
                </div>
            </div>

            <div class="offerCard oc4">
                <div class="offerCover"></div>
                <div class="offerBody">
                    <div class="offerTop">
                        <b>Local resident rates</b>
                        <span class="offerBadge">Sri Lanka</span>
                    </div>

                    <p class="offerText">Special pricing for Sri Lankan residents with valid ID.</p>

                    <ul class="offerList">
                        <li>Resident discount on selected dates</li>
                        <li>Valid NIC required at check in</li>
                        <li>Limited rooms per day</li>
                    </ul>

                    <div class="offerMeta">
                        <div>Promo code - LOCALOFF</div>
                        <div>Valid ID required</div>
                    </div>

                    <div class="offerActions">
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="#contact">Ask us</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="note" style="margin-top:12px;">
            Offers may change based on dates and availability. Contact the front desk for confirmation.
        </div>
    </div>
</section>

<section id="location" class="alt">
    <div class="wrap">
        <h2 class="sec-title">Location</h2>
        <p class="sec-sub">
            Ocean View Resort is located on the southern coast near the main attractions of Galle. Use the map below for directions and nearby points.
        </p>

        <div class="grid2">
            <div class="map">
                <iframe
                        loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade"
                        src="https://www.google.com/maps?q=Galle%20Sri%20Lanka&output=embed">
                </iframe>
            </div>

            <div class="card hoverLift">
                <b style="display:block; font-size:14px; color:#0b4f86;">Quick location notes</b>
                <ul class="list">
                    <li>Distance to Galle Fort depends on traffic and route</li>
                    <li>Nearby beach points for relaxing time</li>
                    <li>Railway and bus access available in Galle</li>
                    <li>Airport transfer guidance on request</li>
                </ul>

                <div style="margin-top:14px;">

                </div>
            </div>
        </div>
    </div>
</section>

<section id="faq">
    <div class="wrap">
        <h2 class="sec-title">FAQ</h2>
        <p class="sec-sub">Answers to common guest questions.</p>

        <div class="faq">
            <div class="qa">
                <button type="button"><span>Check in and check out</span><span class="ic">+</span></button>
                <div class="ans">Check in from 2 pm, check out by 11 am. Early check in or late check out depends on availability.</div>
            </div>

            <div class="qa">
                <button type="button"><span>Identification</span><span class="ic">+</span></button>
                <div class="ans">A valid national ID or passport is required at check in.</div>
            </div>

            <div class="qa">
                <button type="button"><span>Payments</span><span class="ic">+</span></button>
                <div class="ans">We accept cash and major cards. A tax invoice can be provided on request.</div>
            </div>

            <div class="qa">
                <button type="button"><span>Taxes and charges</span><span class="ic">+</span></button>
                <div class="ans">Rates may include applicable taxes and charges. Your bill copy shows the full breakdown.</div>
            </div>

            <div class="qa">
                <button type="button"><span>Cancellation and changes</span><span class="ic">+</span></button>
                <div class="ans">Policies depend on the rate or package selected. Contact us with your reservation number.</div>
            </div>

            <div class="qa">
                <button type="button"><span>Wifi</span><span class="ic">+</span></button>
                <div class="ans">Wifi is available in rooms and public areas.</div>
            </div>
        </div>
    </div>
</section>

<section id="contact" class="alt">
    <div class="wrap">
        <h2 class="sec-title">Contact us</h2>
        <p class="sec-sub">We reply as soon as possible during working hours.</p>

        <div class="contact-grid">
            <div class="contact-box hoverLift">
                <b>Contact details</b>
                <div>
                    Phone +94 71 200 9223<br>
                    WhatsApp +94 70 550 6150<br>
                    Email info@oceanviewresort.lk<br>
                    Address Galle Sri Lanka
                </div>

                <div style="margin-top:12px;">
                    <a class="btn btn-primary" href="tel:+94911234567">Call now</a>
                    <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="https://wa.me/94911234567" target="_blank">WhatsApp</a>
                </div>
            </div>

            <div class="contact-box hoverLift">
                <b>Send a message</b>

                <form id="contactForm">
                    <div class="form">
                        <div>
                            <label>Name</label>
                            <input id="cName" type="text" placeholder="Your name">
                            <div class="fieldErr" id="errName"></div>
                        </div>

                        <div>
                            <label>Email</label>
                            <input id="cEmail" type="email" placeholder="Your email">
                            <div class="fieldErr" id="errEmail"></div>
                        </div>

                        <div class="full">
                            <label>Message</label>
                            <textarea id="cMsg" placeholder="Write your message"></textarea>
                            <div class="fieldErr" id="errMsg"></div>
                        </div>

                        <div class="full">
                            <label>Reservation number optional</label>
                            <input id="cRes" type="text" placeholder="OV-2026-00001">
                            <div class="fieldErr" id="errRes"></div>
                        </div>
                    </div>

                    <div style="margin-top:12px;">
                        <button class="btn btn-primary" id="sendBtn" type="submit">Send</button>
                    </div>
                </form>

                <div class="toast" id="toastOk" aria-hidden="true">
                    <div class="toastBox">
                        <div class="toastTitle">Message sent</div>
                        <div class="toastText">Thanks, we will contact you soon.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="footerNew">
    <div class="footerBgArt"></div>

    <div class="wrap">
        <div class="footerTop">
            <div class="footBrand">
                <img class="footLogo" src="<%= ctx %>/images/Ocean View Resort Logo.png" alt="Ocean View Resort">
                <div>
                    <div class="footTitle">Ocean View Resort</div>
                    <div class="footSub">Galle Sri Lanka</div>
                    <div class="footDesc">
                        Beachfront comfort in Galle with friendly service and a calm atmosphere.
                    </div>
                </div>
            </div>

            <div class="footNewsletter">
                <div class="footHead">Subscribe to latest offers</div>
                <div class="footRow">
                    <input class="footInput" id="subEmail" type="email" placeholder="Enter your email">
                    <button class="footBtn" id="subBtn" type="button">Submit</button>
                </div>
                <div class="footHint">You can unsubscribe anytime.</div>
            </div>

            <div class="footSocial">
                <div class="footHead">Find us on</div>
                <div class="socialRow">
                    <a class="soc" href="https://web.facebook.com/rakindu.fernando" title="Facebook">FB</a>
                    <a class="soc" href="#" title="X">X</a>
                    <a class="soc" href="https://www.instagram.com/_rakinduu_/" title="Instagram">IG</a>
                    <a class="soc" href="https://www.youtube.com/@rakistudios" title="YouTube">YT</a>
                    <a class="soc" href="https://www.linkedin.com/in/rakindu-fernando-78a665233/" title="LinkedIn">IN</a>
                </div>
            </div>
        </div>

        <div class="footerGrid">
            <div class="footCol">
                <div class="footHead">Ocean View Resort</div>
                <div class="footText">
                    Address Galle Sri Lanka<br>
                    Phone +94 91 123 4567<br>
                    Email info@oceanviewresort.lk
                </div>
            </div>

            <div class="footCol">
                <div class="footHead">Quick links</div>
                <a class="footLink" href="#about">About</a>
                <a class="footLink" href="#gallery">Gallery</a>
                <a class="footLink" href="#offers">Offers</a>
                <a class="footLink" href="#contact">Contact</a>
                <a class="footLink" href="#" onclick="openFind(); return false;">Find reservation</a>
            </div>

            <div class="footCol">
                <div class="footHead">Policies</div>
                <a class="footLink" href="#faq">Privacy notice</a>
                <a class="footLink" href="#faq">Terms and conditions</a>
                <a class="footLink" href="#faq">Cookie notice</a>
                <a class="footLink" href="#faq">Accessibility</a>
            </div>

            <div class="footCol">
                <div class="footHead">Support</div>
                <a class="footLink" href="tel:+94911234567">Phone</a>
                <a class="footLink" href="https://wa.me/94911234567" target="_blank">WhatsApp</a>
                <a class="footLink" href="mailto:info@oceanviewresort.lk">Email</a>
                <a class="footLink" href="<%= ctx %>/login">Staff login</a>
            </div>
        </div>

        <div class="footerBottom">
            <div>Copyright Ocean View Resort Galle Sri Lanka | Design and Developed by Rakindu Fernando</div>
            <a class="backTop" href="#home">Back to top</a>
        </div>
    </div>
</footer>

<div class="modal" id="findModal" aria-hidden="true">
    <div class="modal-bg" id="modalBg"></div>

    <div class="modal-panel" style="background: rgba(255,255,255,0.0);">
        <div class="modal-head">
            <h3>Find reservation and print invoice</h3>
            <button class="xbtn" id="closeFindBtn" type="button">✕</button>
        </div>

        <div class="modal-body">
            <% if (msg != null && !msg.trim().isEmpty()) { %>
            <div class="msg"><%= msg %></div>
            <% } %>

            <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="err"><%= error %></div>
            <% } %>

            <div class="lookup">
                <div class="pillRow">
                    <div class="pill">Enter any two details</div>
                    <div class="pill">Reservation and mobile</div>
                    <div class="pill">Reservation and NIC</div>
                    <div class="pill">Mobile and NIC</div>
                </div>

                <form method="post" action="<%= ctx %>/booking-info" id="lookupForm">
                    <div class="row">
                        <div class="col">
                            <label>Reservation number</label>
                            <input type="text" name="reservationNo" value="<%= pResNo %>" placeholder="OV-2026-00001">
                        </div>
                        <div class="col">
                            <label>Mobile number</label>
                            <input type="text" name="mobile" value="<%= pMobile %>" placeholder="07XXXXXXXX">
                        </div>
                        <div class="col">
                            <label>NIC or passport</label>
                            <input type="text" name="nicPassport" value="<%= pNic %>" placeholder="NIC or passport number">
                        </div>
                        <div class="col">
                            <label>Check in date optional</label>
                            <input type="date" name="checkInDate">
                        </div>
                    </div>

                    <div class="print-actions">
                        <button class="btn btn-primary" type="submit">Search reservation</button>
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="<%= ctx %>/booking-info">Reset</a>
                        <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="<%= ctx %>/booking-info?action=clear">Clear</a>
                    </div>

                    <div class="note">
                        We use your details only to retrieve your booking and support your stay.
                    </div>
                </form>
            </div>

            <% if (reservations != null && !reservations.isEmpty()) { %>
            <div class="no-print" style="margin-top:12px;">
                <b style="display:block; font-size:14px; color:#0b4f86;">Your reservations</b>

                <table>
                    <tr>
                        <th>Reservation no</th>
                        <th>Room type</th>
                        <th>Check in</th>
                        <th>Check out</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <% for (Reservation rr : reservations) { %>
                    <tr>
                        <td><%= rr.getReservationNo() %></td>
                        <td><%= rr.getRoomType() %></td>
                        <td><%= rr.getCheckIn() %></td>
                        <td><%= rr.getCheckOut() %></td>
                        <td><%= rr.getStatus() %></td>
                        <td class="table-actions">
                            <a href="<%= ctx %>/booking-info?keep=1&reservationNo=<%= rr.getReservationNo() %>">View invoice</a>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
            <% } %>

            <% if (r != null) { %>
            <%
                java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy");
                String invDate = java.time.LocalDate.now().format(df);
                String dueDate = (r.getCheckOut() != null ? r.getCheckOut().format(df) : invDate);

                String rn = (r.getReservationNo() != null ? r.getReservationNo() : "");
                String invNo = rn.startsWith("OV-") ? "INV-" + rn.substring(3) : "INV-" + rn;

                double rateV = (rate != null ? rate : 0.0);
                long nightsV = (nights != null ? nights : 0L);
                double totalV = (total != null ? total : 0.0);
                double paidV = (paid != null ? paid : 0.0);
                double balV = (balance != null ? balance : 0.0);
                if (balV < 0) balV = 0.0;
            %>

            <div class="bill" id="billPrintArea">
                <div class="invPaper">
                    <div class="invTop">
                        <div class="invBrand">
                            <img class="invLogo" src="<%= ctx %>/images/Ocean View Resort Logo.png" alt="Ocean View Resort">
                            <div>
                                <div class="invHotel">Ocean View Resort</div>
                                <div class="invSmall">Galle, Sri Lanka</div>
                                <div class="invSmall">Phone +94 71 200 9223</div>
                                <div class="invSmall">Email info@oceanviewresort.lk</div>
                            </div>
                        </div>

                        <div>
                            <div class="invTitle">INVOICE</div>
                            <div class="invMeta">
                                <div class="invMetaRow">
                                    <div class="k">Invoice number</div>
                                    <div class="v"><%= invNo %></div>
                                </div>
                                <div class="invMetaRow">
                                    <div class="k">Invoice date</div>
                                    <div class="v"><%= invDate %></div>
                                </div>
                                <div class="invMetaRow">
                                    <div class="k">Due date</div>
                                    <div class="v"><%= dueDate %></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="invMid">
                        <div class="invBox">
                            <div class="invLabel">Billed to</div>
                            <div class="invName"><%= r.getGuestName() %></div>
                            <div class="invSmall">Mobile <%= mask(r.getGuestMobile(), 3, 2) %></div>
                            <div class="invSmall">NIC or passport <%= mask(r.getGuestNicPassport(), 2, 2) %></div>
                        </div>

                        <div class="invBox">
                            <div class="invLabel">Reservation details</div>
                            <div class="invSmall">Reservation no <b><%= r.getReservationNo() %></b></div>
                            <div class="invSmall">Room type <b><%= r.getRoomType() %></b></div>
                            <div class="invSmall">Check in <b><%= r.getCheckIn() %></b></div>
                            <div class="invSmall">Check out <b><%= r.getCheckOut() %></b></div>
                        </div>
                    </div>

                    <table class="invTable">
                        <thead>
                        <tr>
                            <th style="width:70px;" class="c">Item</th>
                            <th>Description</th>
                            <th style="width:120px;" class="r">Unit price</th>
                            <th style="width:90px;" class="c">Qty</th>
                            <th style="width:140px;" class="r">Amount</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="c">1</td>
                            <td>
                                Accommodation
                                <div class="invSmall"><%= r.getRoomType() %>, <%= nightsV %> night(s)</div>
                            </td>
                            <td class="r">LKR <%= money(rateV) %></td>
                            <td class="c"><%= nightsV %></td>
                            <td class="r">LKR <%= money(totalV) %></td>
                        </tr>
                        </tbody>
                    </table>

                    <div class="invTotals">
                        <div style="min-width:260px;">
                            <div class="invLabel">Please make payment to</div>
                            <div class="invSmall">Ocean View Resort bank account</div>
                            <div class="invSmall">Account no 022020XXXXXX</div>
                            <div class="invSmall">HNB Galle Branch</div>
                        </div>

                        <div class="invSum">
                            <div class="sumRow">
                                <span>Subtotal</span>
                                <span>LKR <%= money(totalV) %></span>
                            </div>
                            <div class="sumRow">
                                <span>Paid</span>
                                <span>LKR <%= money(paidV) %></span>
                            </div>
                            <div class="sumRow total">
                                <span>Balance due</span>
                                <span>LKR <%= money(balV) %></span>
                            </div>
                        </div>
                    </div>

                    <% if (payments != null && !payments.isEmpty()) { %>
                    <div style="margin-top:14px;">
                        <div class="invLabel">Payments received</div>
                        <table class="invTable">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Method</th>
                                <th>Reference</th>
                                <th class="r">Amount</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Payment p : payments) { %>
                            <tr>
                                <td><%= p.getPaidAt() %></td>
                                <td><%= p.getMethod() %></td>
                                <td><%= (p.getReferenceNo() != null ? p.getReferenceNo() : "") %></td>
                                <td class="r">LKR <%= money(p.getAmount()) %></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>

                    <div class="invTerms">
                        <div class="invLabel">Terms and conditions</div>
                        <div class="invSmall">Thank you for staying with us.</div>
                        <div class="invSmall">This is a system generated invoice.</div>
                    </div>

                    <div class="invFoot">
                        <div>Page 1 of 1</div>
                        <div>Ocean View Resort Galle Sri Lanka</div>
                    </div>
                </div>
            </div>

            <div class="print-actions">
                <button class="btn btn-primary" type="button" onclick="window.print()">Print invoice</button>
                <button class="btn btn-primary" type="button" onclick="window.print()">Save as PDF</button>
                <a class="btn" style="background:#fff; border:1px solid var(--line); color:#0b4f86;" href="<%= ctx %>/booking-info?keep=1">Back</a>
            </div>
            <% } %>

        </div>
    </div>
</div>

<script>
    (function () {
        try {
            var nav = performance.getEntriesByType && performance.getEntriesByType("navigation");
            if (nav && nav.length && nav[0].type === "reload") {
                window.location.replace("<%= ctx %>/booking-info");
            }
        } catch (e) { }
    })();

    function openFind(){
        var m = document.getElementById("findModal");
        if(!m) return;

        m.classList.add("show");
        m.setAttribute("aria-hidden","false");
        document.body.style.overflow = "hidden";

        var body = m.querySelector(".modal-body");
        if(body) body.scrollTop = 0;
    }

    function closeFind(){
        var m = document.getElementById("findModal");
        if(!m) return;
        m.classList.remove("show");
        m.setAttribute("aria-hidden","true");
        document.body.style.overflow = "";
    }

    (function(){
        var navToggle = document.getElementById("navToggle");
        var mobileNav = document.getElementById("mobileNav");

        if(navToggle && mobileNav){
            navToggle.addEventListener("click", function(){
                mobileNav.classList.toggle("show");
            });

            mobileNav.addEventListener("click", function(e){
                if(e.target && e.target.tagName === "A"){
                    mobileNav.classList.remove("show");
                }
            });
        }

        var openBtn = document.getElementById("openFindBtn");
        var heroBtn = document.getElementById("heroFindBtn");
        var closeBtn = document.getElementById("closeFindBtn");
        var bg = document.getElementById("modalBg");

        if(openBtn) openBtn.addEventListener("click", openFind);
        if(heroBtn) heroBtn.addEventListener("click", openFind);
        if(closeBtn) closeBtn.addEventListener("click", closeFind);
        if(bg) bg.addEventListener("click", closeFind);

        document.addEventListener("keydown", function(e){
            if(e.key === "Escape") closeFind();
        });

        var form = document.getElementById("lookupForm");
        if(form){
            form.addEventListener("submit", function(e){
                var resNo = (form.querySelector("input[name='reservationNo']") || {}).value || "";
                var mobile = (form.querySelector("input[name='mobile']") || {}).value || "";
                var nic = (form.querySelector("input[name='nicPassport']") || {}).value || "";

                resNo = resNo.trim();
                mobile = mobile.trim();
                nic = nic.trim();

                var count = 0;
                if(resNo.length > 0) count++;
                if(mobile.length > 0) count++;
                if(nic.length > 0) count++;

                if(count < 2){
                    e.preventDefault();
                    alert("Please enter at least two fields for privacy.");
                }
            });
        }

        var qas = document.querySelectorAll(".qa button");
        for(var i=0;i<qas.length;i++){
            qas[i].addEventListener("click", function(){
                var box = this.parentElement;
                if(!box) return;
                box.classList.toggle("open");

                var ic = this.querySelector(".ic");
                if(ic){
                    ic.textContent = box.classList.contains("open") ? "-" : "+";
                }
            });
        }

        var nav = document.getElementById("mainNav");
        if(nav){
            var navLinks = nav.querySelectorAll("a[data-sec]");
            var map = {};
            for(var j=0;j<navLinks.length;j++){
                map[navLinks[j].getAttribute("data-sec")] = navLinks[j];
            }

            var secs = [];
            var ids = ["home","about","stay","dining","experiences","facilities","gallery","reviews","offers","location","faq","contact"];
            for(var k=0;k<ids.length;k++){
                var el = document.getElementById(ids[k]);
                if(el) secs.push(el);
            }

            if("IntersectionObserver" in window){
                var obs = new IntersectionObserver(function(entries){
                    entries.forEach(function(en){
                        if(en.isIntersecting){
                            var id = en.target.getAttribute("id");
                            for(var x=0;x<navLinks.length;x++) navLinks[x].classList.remove("active");
                            if(map[id]) map[id].classList.add("active");
                        }
                    });
                }, { threshold: 0.35 });

                for(var s=0;s<secs.length;s++) obs.observe(secs[s]);
            }
        }

        <% if (openFindOnLoad) { %>
        openFind();
        <% } %>
    })();

    (function(){
        var f = document.getElementById("contactForm");
        if(!f) return;

        var nameEl = document.getElementById("cName");
        var emailEl = document.getElementById("cEmail");
        var msgEl = document.getElementById("cMsg");
        var resEl = document.getElementById("cRes");
        var btn = document.getElementById("sendBtn");

        var errName = document.getElementById("errName");
        var errEmail = document.getElementById("errEmail");
        var errMsg = document.getElementById("errMsg");
        var errRes = document.getElementById("errRes");

        function setErr(input, box, text){
            if(box) box.textContent = text || "";
            if(input){
                if(text) input.classList.add("inputBad");
                else input.classList.remove("inputBad");
            }
        }

        function isEmail(s){
            s = (s || "").trim();
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(s);
        }

        function showToast(){
            var t = document.getElementById("toastOk");
            if(!t) return;
            t.classList.add("show");
            t.setAttribute("aria-hidden","false");

            setTimeout(function(){
                t.classList.remove("show");
                t.setAttribute("aria-hidden","true");
            }, 2500);
        }

        f.addEventListener("submit", function(e){
            e.preventDefault();

            var ok = true;

            var n = (nameEl.value || "").trim();
            var em = (emailEl.value || "").trim();
            var m = (msgEl.value || "").trim();
            var r = (resEl.value || "").trim();

            setErr(nameEl, errName, "");
            setErr(emailEl, errEmail, "");
            setErr(msgEl, errMsg, "");
            setErr(resEl, errRes, "");

            if(n.length < 3){
                setErr(nameEl, errName, "Please enter your name");
                ok = false;
            }

            if(!isEmail(em)){
                setErr(emailEl, errEmail, "Please enter a valid email");
                ok = false;
            }

            if(m.length < 10){
                setErr(msgEl, errMsg, "Message should be at least 10 characters");
                ok = false;
            }

            if(r.length > 0){
                var re = /^OV-\d{4}-\d{5}$/;
                if(!re.test(r)){
                    setErr(resEl, errRes, "Use format OV-2026-00001");
                    ok = false;
                }
            }

            if(!ok) return;

            btn.disabled = true;

            showToast();

            f.reset();

            setTimeout(function(){
                btn.disabled = false;
            }, 900);
        });

        var inputs = [nameEl, emailEl, msgEl, resEl];
        inputs.forEach(function(inp){
            if(!inp) return;
            inp.addEventListener("input", function(){
                inp.classList.remove("inputBad");
                if(inp === nameEl && errName) errName.textContent = "";
                if(inp === emailEl && errEmail) errEmail.textContent = "";
                if(inp === msgEl && errMsg) errMsg.textContent = "";
                if(inp === resEl && errRes) errRes.textContent = "";
            });
        });
    })();

    (function(){
        var subBtn = document.getElementById("subBtn");
        var subEmail = document.getElementById("subEmail");
        if(!subBtn || !subEmail) return;

        function isEmail(s){
            s = (s || "").trim();
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(s);
        }

        subBtn.addEventListener("click", function(){
            var v = (subEmail.value || "").trim();

            if(!isEmail(v)){
                alert("Please enter a valid email");
                subEmail.focus();
                return;
            }

            subEmail.value = "";
            alert("Subscribed successfully");
        });
    })();
</script>

</body>
</html>