package lk.oceanviewresort.web;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/app/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession(false);
        String fullName = (String) session.getAttribute("fullName");
        String role = (String) session.getAttribute("role");

        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String ctx = req.getContextPath();

        out.println("<!DOCTYPE html><html><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Dashboard</title>");
        out.println("<link rel='stylesheet' href='" + req.getContextPath() + "/assets/app.css'>");
        out.println("<script src='" + req.getContextPath() + "/assets/app.js' defer></script>");
        out.println("</head><body class='dashboard-servlet'>");
        out.println("<div class='container'>");
        out.println("<h1>Ocean View Resort - Dashboard</h1>");
        out.println("<p>Welcome: " + fullName + " (" + role + ")</p>");

        String err = req.getParameter("error");
        if (err != null) out.println("<p style='color:red;'>" + err + "</p>");

        out.println("<p><a href='" + req.getContextPath() + "/logout'>Logout</a></p>");
        out.println("<hr>");

        out.println("<h3>Common</h3><ul>");
        out.println("<li><a href='" + req.getContextPath() + "/app/help'>Help</a></li>");
        out.println("</ul>");

        if ("RECEPTIONIST".equals(role)) {
            out.println("<h3>Receptionist Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/guests'>Guest Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/reservations'>Reservation Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/reception/billing'>Billing + Payments</a></li>");
            out.println("</ul>");
        }

        if ("MANAGER".equals(role)) {
            out.println("<h3>Manager Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/manager/reservations'>View Reservations</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/manager/reports'>Reports</a></li>");
            out.println("</ul>");
        }

        if ("ADMIN".equals(role)) {
            out.println("<h3>Admin Functions</h3><ul>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/users'>User Management</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/reservations'>Delete Reservations</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/transactions'>Transactions</a></li>");
            out.println("<li><a href='" + req.getContextPath() + "/app/admin/reports'>Reports</a></li>");
            out.println("</ul>");
        }

        // --- Room Availability widget (insert after app.js builds layout) ---
        out.println("<script>");
        out.println("window.addEventListener('load', function(){");
        out.println("  setTimeout(function(){");

        out.println("    if(document.getElementById('dashCheckIn')) return;"); // stop duplicates

        out.println("    var ctx = '" + ctx + "';");
        out.println("  function money(v){");
        out.println("    v = Number(v || 0);");
        out.println("    return 'LKR ' + v.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2});");
        out.println("  }");

        out.println("  function loadIncomeStats(){");
        out.println("    var a = document.getElementById('incToday');");
        out.println("    var b = document.getElementById('txToday');");
        out.println("    var c = document.getElementById('incMonth');");
        out.println("    var d = document.getElementById('txMonth');");
        out.println("    if(!a || !b || !c || !d) return;");

        out.println("    fetch(ctx + '/app/income-stats')");
        out.println("      .then(function(res){ return res.json(); })");
        out.println("      .then(function(data){");
        out.println("        if(!data.ok){");
        out.println("          a.innerText = money(0); b.innerText = '0'; c.innerText = money(0); d.innerText = '0';");
        out.println("          return;");
        out.println("        }");
        out.println("        a.innerText = money(data.todayTotal);");
        out.println("        b.innerText = String(data.todayCount || 0);");
        out.println("        c.innerText = money(data.monthTotal);");
        out.println("        d.innerText = String(data.monthCount || 0);");
        out.println("      })");
        out.println("      .catch(function(){");
        out.println("        a.innerText = money(0); b.innerText = '0'; c.innerText = money(0); d.innerText = '0';");
        out.println("      });");
        out.println("  }");

        out.println("  function loadTodayIncome(){");
        out.println("    var el = document.getElementById('todayIncomeVal');");
        out.println("    if(!el) return;");
        out.println("    fetch(ctx + '/app/today-income')");
        out.println("      .then(function(res){ return res.json(); })");
        out.println("      .then(function(data){");
        out.println("        if(!data.ok){ el.innerText = 'LKR 0.00'; return; }");
        out.println("        var v = Number(data.total || 0);");
        out.println("        el.innerText = 'LKR ' + v.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2});");
        out.println("      })");
        out.println("      .catch(function(){ el.innerText = 'LKR 0.00'; });");
        out.println("  }");


        out.println("    // Try to find the main content area created by app.js");
        out.println("    var target = document.querySelector('.content-area') ||");
        out.println("                 document.querySelector('.app-content') ||");
        out.println("                 document.querySelector('.page-content') ||");
        out.println("                 document.querySelector('.main-content') ||");
        out.println("                 document.querySelector('.content') ||");
        out.println("                 document.querySelector('main') ||");
        out.println("                 document.querySelector('.container') || document.body;");

        out.println("    var html = `");
        out.println("    <div style='margin-top:16px; padding:14px; border:1px solid #cfeaff; border-radius:12px; background:#ffffff;'>");
        out.println("      <h3 style='margin:0 0 6px 0; color:#0b4f86;'>Room Availability</h3>");
        out.println("      <div style='font-size:13px; color:#4b6b7a; margin-bottom:10px;'>Select dates to see available room counts (by room type).</div>");
        // --- Income Summary (Today + This Month) ---
        out.println("<div style='margin:10px 0 14px; display:grid; grid-template-columns:repeat(auto-fit, minmax(180px, 1fr)); gap:10px;'>");

        out.println("  <div style='padding:12px; border:1px solid #cfeaff; border-radius:12px; background:#ffffff;'>");
        out.println("    <div style='font-size:12px; color:#4b6b7a;'>Today's Income</div>");
        out.println("    <div id='incToday' style='font-size:20px; font-weight:bold; color:#0b4f86; margin-top:6px;'>Loading...</div>");
        out.println("  </div>");

        out.println("  <div style='padding:12px; border:1px solid #cfeaff; border-radius:12px; background:#ffffff;'>");
        out.println("    <div style='font-size:12px; color:#4b6b7a;'>Today's Transactions</div>");
        out.println("    <div id='txToday' style='font-size:20px; font-weight:bold; color:#0b4f86; margin-top:6px;'>Loading...</div>");
        out.println("  </div>");

        out.println("  <div style='padding:12px; border:1px solid #cfeaff; border-radius:12px; background:#ffffff;'>");
        out.println("    <div style='font-size:12px; color:#4b6b7a;'>This Month Income</div>");
        out.println("    <div id='incMonth' style='font-size:20px; font-weight:bold; color:#0b4f86; margin-top:6px;'>Loading...</div>");
        out.println("  </div>");

        out.println("  <div style='padding:12px; border:1px solid #cfeaff; border-radius:12px; background:#ffffff;'>");
        out.println("    <div style='font-size:12px; color:#4b6b7a;'>This Month Transactions</div>");
        out.println("    <div id='txMonth' style='font-size:20px; font-weight:bold; color:#0b4f86; margin-top:6px;'>Loading...</div>");
        out.println("  </div>");

        out.println("</div>");

        out.println("  <div style='margin:10px 0 14px; padding:10px; border:1px dashed #cfeaff; border-radius:10px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:8px;'>");
        out.println("    <div>");
        out.println("      <div style='font-size:12px; color:#4b6b7a;'>Today's Total Income</div>");
        out.println("      <div id='todayIncomeVal' style='font-size:22px; font-weight:bold; color:#0b4f86;'>Loading...</div>");
        out.println("    </div>");
        out.println("    <div style='font-size:12px; color:#4b6b7a;'>Sum of payments received today</div>");
        out.println("  </div>");
        out.println("      <div style='display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end;'>");
        out.println("        <div>");
        out.println("          <div style='font-size:12px; margin-bottom:4px;'>Check-In</div>");
        out.println("          <input type='date' id='dashCheckIn' style='padding:8px; border:1px solid #cfeaff; border-radius:10px;'/>");
        out.println("        </div>");
        out.println("        <div>");
        out.println("          <div style='font-size:12px; margin-bottom:4px;'>Check-Out</div>");
        out.println("          <input type='date' id='dashCheckOut' style='padding:8px; border:1px solid #cfeaff; border-radius:10px;'/>");
        out.println("        </div>");
        out.println("        <button type='button' id='dashCheckBtn' style='padding:9px 14px; border:none; border-radius:10px; background:#2aa7ff; color:white; cursor:pointer;'>Check</button>");
        out.println("      </div>");
        out.println("      <div id='dashAvailMsg' style='display:none; margin-top:10px; padding:10px; border-radius:10px; background:#fff0f0; border:1px solid #ffcccc; color:#7a1c1c; font-size:13px;'></div>");
        out.println("      <div id='dashAvailGrid' style='margin-top:12px; display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:10px;'></div>");
        out.println("    </div>`;");

        out.println("    target.insertAdjacentHTML('beforeend', html);");

        out.println("    function pad(n){ return (n<10?'0':'')+n; }");
        out.println("    function setDefaultDates(){");
        out.println("  loadTodayIncome();");
        out.println("  loadIncomeStats();");
        out.println("      var d=new Date();");
        out.println("      var today=d.getFullYear()+'-'+pad(d.getMonth()+1)+'-'+pad(d.getDate());");
        out.println("      d.setDate(d.getDate()+1);");
        out.println("      var tom=d.getFullYear()+'-'+pad(d.getMonth()+1)+'-'+pad(d.getDate());");
        out.println("      document.getElementById('dashCheckIn').value=today;");
        out.println("      document.getElementById('dashCheckOut').value=tom;");
        out.println("    }");

        out.println("    function showMsg(text){");
        out.println("      var box=document.getElementById('dashAvailMsg');");
        out.println("      box.style.display='block';");
        out.println("      box.innerHTML=text;");
        out.println("    }");

        out.println("    function clearMsg(){");
        out.println("      var box=document.getElementById('dashAvailMsg');");
        out.println("      box.style.display='none';");
        out.println("      box.innerHTML='';");
        out.println("    }");

        out.println("    function esc(t){");
        out.println("      if(!t) return '';");
        out.println("      return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;');");
        out.println("    }");

        out.println("    function renderRooms(rooms){");
        out.println("      var grid=document.getElementById('dashAvailGrid');");
        out.println("      grid.innerHTML='';");
        out.println("      if(!rooms || rooms.length===0){ showMsg('No room types found.'); return; }");
        out.println("      rooms.forEach(function(r){");
        out.println("        var div=document.createElement('div');");
        out.println("        div.style.border='1px solid ' + (r.status==='FULLY_BOOKED' ? '#ffcccc' : '#cfeaff');");
        out.println("        div.style.background=(r.status==='FULLY_BOOKED' ? '#fff6f6' : '#ffffff');");
        out.println("        div.style.borderRadius='12px';");
        out.println("        div.style.padding='12px';");
        out.println("        div.innerHTML =");
        out.println("          \"<div style='font-weight:bold; color:#0b4f86; margin-bottom:6px;'>\"+esc(r.roomType)+\"</div>\" +");
        out.println("          \"<div style='font-size:12px; color:#4b6b7a;'>Total: \"+r.total+\" | Booked: \"+r.booked+\"</div>\" +");
        out.println("          \"<div style='font-size:26px; font-weight:bold; margin-top:8px; color:#0b4f86;'>\"+r.available+\"</div>\" +");
        out.println("          \"<div style='font-size:12px; color:#4b6b7a;'>\"+(r.status==='FULLY_BOOKED'?'Fully Booked':'Available')+\"</div>\";");
        out.println("        grid.appendChild(div);");
        out.println("      });");
        out.println("    }");

        out.println("    function loadAvailability(){");
        out.println("      clearMsg();");
        out.println("      var ci=document.getElementById('dashCheckIn').value;");
        out.println("      var co=document.getElementById('dashCheckOut').value;");
        out.println("      if(!ci || !co){ showMsg('Please select check-in and check-out dates.'); return; }");
        out.println("      fetch(ctx + '/app/availability?checkIn=' + encodeURIComponent(ci) + '&checkOut=' + encodeURIComponent(co))");
        out.println("        .then(function(res){ return res.json(); })");
        out.println("        .then(function(data){");
        out.println("          if(!data.ok){ showMsg('Error: ' + (data.message||'UNKNOWN')); return; }");
        out.println("          renderRooms(data.rooms);");
        out.println("        })");
        out.println("        .catch(function(){ showMsg('Error loading availability.'); });");
        out.println("    }");

        out.println("    setDefaultDates();");
        out.println("    loadAvailability();");
        out.println("    document.getElementById('dashCheckBtn').addEventListener('click', loadAvailability);");

        out.println("  }, 250);"); // wait a bit for app.js layout
        out.println("});");
        out.println("</script>");

        out.println("</body></html>");

    }
}
