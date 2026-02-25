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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort | Booking Info</title>
    <link rel="icon" type="image/x-icon" href="<%= ctx %>/images/favicon.png">

    <style>
        :root{
            --blue:#2aa7ff;
            --blueDark:#0f86d6;
            --text:#0b2b3a;
            --card:#ffffff;
            --line:#cfe6ff;
        }

        *{ box-sizing:border-box; }
        body{
            margin:0;
            font-family:Arial, Helvetica, sans-serif;
            background:#f3f9ff;
            color:var(--text);
        }

        .topbar{
            padding:14px 18px;
            background:#d9efff;
            border-bottom:1px solid #bfe3ff;
        }

        .top-wrap{
            max-width:1050px;
            margin:0 auto;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            flex-wrap:wrap;
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
        }

        .logo{
            width:44px;
            height:44px;
            object-fit:contain;
        }

        .brand h1{
            margin:0;
            font-size:18px;
        }

        .brand p{
            margin:2px 0 0 0;
            font-size:12px;
            color:#155a92;
        }

        .links a{
            display:inline-block;
            margin:4px 6px 4px 0;
            padding:7px 10px;
            background:#fff;
            border:1px solid var(--line);
            border-radius:8px;
            text-decoration:none;
            color:#0b4f86;
            font-size:13px;
        }
        .links a:hover{ background:#eef7ff; }

        .container{
            max-width:1050px;
            margin:16px auto;
            padding:0 12px;
        }

        .card{
            background:var(--card);
            border:1px solid var(--line);
            border-radius:12px;
            padding:14px;
            box-shadow:0 1px 0 rgba(0,0,0,0.03);
        }

        .title{
            margin:0 0 10px 0;
            font-size:20px;
        }

        .msg{
            padding:10px;
            border-radius:8px;
            margin:10px 0;
            border:1px solid #bfe3ff;
            background:#eef7ff;
        }
        .err{
            padding:10px;
            border-radius:8px;
            margin:10px 0;
            border:1px solid #ffb3b3;
            background:#fff0f0;
            color:#8a1515;
        }

        .row{ display:flex; gap:10px; flex-wrap:wrap; }
        .col{ flex:1; min-width:220px; }

        label{ display:block; font-size:13px; margin-bottom:6px; color:#155a92; }
        input{
            width:100%;
            padding:9px;
            border:1px solid var(--line);
            border-radius:8px;
            font-size:13px;
        }

        .btn{
            display:inline-block;
            padding:10px 14px;
            background:linear-gradient(180deg, var(--blue), var(--blueDark));
            color:#fff;
            border:none;
            border-radius:10px;
            cursor:pointer;
            font-weight:700;
            font-size:13px;
        }
        .btn:active{ transform:translateY(1px); }

        .btn2{
            display:inline-block;
            padding:10px 14px;
            background:#fff;
            color:#0b4f86;
            border:1px solid var(--line);
            border-radius:10px;
            cursor:pointer;
            font-weight:700;
            font-size:13px;
            text-decoration:none;
        }
        .btn2:hover{ background:#eef7ff; }

        .small{
            font-size:12px;
            color:#3a6a93;
        }

        table{ width:100%; border-collapse:collapse; margin-top:10px; }
        th, td{ border:1px solid #d6ecff; padding:8px; text-align:left; font-size:13px; }
        th{ background:#eef7ff; }

        .bill{
            margin-top:12px;
            border:1px solid var(--line);
            border-radius:12px;
            padding:14px;
        }

        .bill-top{
            display:flex;
            justify-content:space-between;
            gap:10px;
            flex-wrap:wrap;
        }

        .right{ text-align:right; }

        .sign{
            display:flex;
            justify-content:space-between;
            gap:10px;
            margin-top:25px;
        }

        .line{
            border-top:1px solid #888;
            width:260px;
            padding-top:6px;
            font-size:12px;
        }

        footer{
            margin-top:18px;
            padding:12px;
            text-align:center;
            color:#3a6a93;
            font-size:12px;
        }

        @media (max-width:520px){
            .line{ width:48%; }
        }

        @media print {
            .no-print{ display:none !important; }
            body{ background:#fff; }
            .card{ border:none; box-shadow:none; }
            .bill{ border:none; }
        }
    </style>
</head>

<body>

<div class="topbar no-print">
    <div class="top-wrap">
        <div class="brand">
            <img class="logo" src="<%= ctx %>/images/Ocean View Resort Logo.png" alt="Ocean View Resort" />
            <div>
                <h1>Ocean View Resort</h1>
                <p>Booking Info and Bill Copy</p>
            </div>
        </div>
        <div class="links">
            <a href="<%= ctx %>/">Home</a>
            <a href="<%= ctx %>/booking-info?action=clear">Clear</a>
            <a href="<%= ctx %>/login">Staff Login</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2 class="title">Booking Information</h2>
        <div class="small">For privacy, enter at least two details to view booking and print bill.</div>

        <% if (msg != null && !msg.isEmpty()) { %>
        <div class="msg"><%= msg %></div>
        <% } %>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="err"><%= error %></div>
        <% } %>

        <div class="no-print">
            <form method="post" action="<%= ctx %>/booking-info" id="lookupForm">
                <div class="row">
                    <div class="col">
                        <label>Reservation Number</label>
                        <input type="text" name="reservationNo" value="<%= pResNo %>" placeholder="OV-2026-00001">
                    </div>
                    <div class="col">
                        <label>Mobile Number</label>
                        <input type="text" name="mobile" value="<%= pMobile %>" placeholder="07XXXXXXXX">
                    </div>
                    <div class="col">
                        <label>NIC or Passport</label>
                        <input type="text" name="nicPassport" value="<%= pNic %>" placeholder="NIC or Passport No">
                    </div>
                </div>

                <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
                    <button class="btn" type="submit">Search</button>
                    <a class="btn2" href="<%= ctx %>/booking-info">Reset</a>
                </div>

                <div class="small" style="margin-top:10px;">
                    Examples<br>
                    Reservation + Mobile<br>
                    Reservation + NIC<br>
                    Mobile + NIC
                </div>
            </form>
        </div>

        <% if (reservations != null && !reservations.isEmpty()) { %>
        <hr class="no-print">
        <div class="no-print">
            <h3 style="margin:0 0 8px 0;">Your Reservations</h3>
            <table>
                <tr>
                    <th>Reservation No</th>
                    <th>Room Type</th>
                    <th>Check In</th>
                    <th>Check Out</th>
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
                    <td>
                        <a class="btn2" href="<%= ctx %>/booking-info?keep=1&reservationNo=<%= rr.getReservationNo() %>">View Bill</a>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

        <% if (r != null) { %>
        <hr>

        <div class="bill" id="billArea">
            <div class="bill-top">
                <div>
                    <h3 style="margin:0;">Ocean View Resort</h3>
                    <div class="small">Guest Bill Copy</div>
                    <div class="small">Galle, Sri Lanka</div>
                </div>
                <div class="right">
                    <div><b>Date:</b> <%= new java.util.Date() %></div>
                    <div><b>Reservation No:</b> <%= r.getReservationNo() %></div>
                </div>
            </div>

            <hr>

            <table>
                <tr><th>Guest Name</th><td><%= r.getGuestName() %></td></tr>
                <tr><th>Room Type</th><td><%= r.getRoomType() %></td></tr>
                <tr><th>Check In</th><td><%= r.getCheckIn() %></td></tr>
                <tr><th>Check Out</th><td><%= r.getCheckOut() %></td></tr>
                <tr><th>Nights</th><td><%= nights != null ? nights : 0 %></td></tr>
                <tr><th>Rate per Night</th><td><%= rate != null ? String.format("%.2f", rate) : "0.00" %></td></tr>
                <tr><th>Total</th><td><b><%= total != null ? String.format("%.2f", total) : "0.00" %></b></td></tr>
                <tr><th>Paid</th><td><%= paid != null ? String.format("%.2f", paid) : "0.00" %></td></tr>
                <tr><th>Balance</th><td><b><%= balance != null ? String.format("%.2f", balance) : "0.00" %></b></td></tr>
            </table>

            <div style="margin-top:10px;" class="small">
                Verified Details<br>
                Mobile <%= mask(r.getGuestMobile(), 3, 2) %><br>
                NIC or Passport <%= mask(r.getGuestNicPassport(), 2, 2) %>
            </div>

            <div class="sign">
                <div class="line">Guest Signature</div>
                <div class="line">Hotel Signature</div>
            </div>

            <p class="small" style="margin-top:12px;">Thank you for choosing Ocean View Resort.</p>
        </div>

        <div class="no-print" style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;">
            <button class="btn" type="button" onclick="window.print()">Print Bill</button>
            <a class="btn2" href="<%= ctx %>/booking-info?keep=1">Back</a>
        </div>

        <% if (payments != null && !payments.isEmpty()) { %>
        <hr>
        <div>
            <h3 style="margin:0 0 8px 0;">Payments</h3>
            <table>
                <tr><th>Date</th><th>Amount</th><th>Method</th><th>Reference</th></tr>
                <% for (Payment p : payments) { %>
                <tr>
                    <td><%= p.getPaidAt() %></td>
                    <td><%= String.format("%.2f", p.getAmount()) %></td>
                    <td><%= p.getMethod() %></td>
                    <td><%= p.getReferenceNo() != null ? p.getReferenceNo() : "" %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

        <% } %>

    </div>

    <footer class="no-print">
        <div>Ocean View Resort Booking Info Page</div>
        <div class="small">This page is for guests to view their own booking and print a bill copy.</div>
    </footer>
</div>

<script>
    (function(){
        var form = document.getElementById("lookupForm");
        if(!form) return;

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
    })();
</script>

</body>
</html>