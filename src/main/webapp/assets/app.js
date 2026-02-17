

(function () {
    // prevent double run (fixes double icons)
    if (window.__ov_ui_loaded) return;
    window.__ov_ui_loaded = true;

    function cleanText(s){
        if (!s) return "";
        return s.replace(/\s+/g, " ").trim();
    }

    function iconForHref(href){
        href = href || "";
        if (href.indexOf("/app/dashboard") !== -1) return "🏠";
        if (href.indexOf("/app/help") !== -1) return "❓";

        if (href.indexOf("/reception/guests") !== -1) return "👤";
        if (href.indexOf("/reception/reservations") !== -1) return "🛏️";
        if (href.indexOf("/reception/billing") !== -1) return "🧾";

        if (href.indexOf("/manager/reservations") !== -1) return "📄";
        if (href.indexOf("/manager/reports") !== -1) return "📊";

        if (href.indexOf("/admin/users") !== -1) return "👥";
        if (href.indexOf("/admin/reservations") !== -1) return "🗑️";
        if (href.indexOf("/admin/transactions") !== -1) return "💳";
        if (href.indexOf("/admin/reports") !== -1) return "📊";

        return "📌";
    }

    function decorateNav(nav){
        if (!nav || nav.getAttribute("data-ov-done") === "1") return;

        var links = nav.querySelectorAll("a");
        for (var i = 0; i < links.length; i++) {
            var a = links[i];

            // if already decorated, skip
            if (a.querySelector(".miIcon")) continue;

            var href = a.getAttribute("href") || "";
            var text = cleanText(a.textContent);

            var icon = iconForHref(href);
            a.innerHTML = "<span class='miIcon'>" + icon + "</span><span class='miText'>" + text + "</span>";
        }


        var currentPath = window.location.pathname;
        for (var j = 0; j < links.length; j++) {
            try {
                var pth = new URL(links[j].href, window.location.href).pathname;
                if (pth === currentPath) links[j].classList.add("active");
            } catch (e) { }
        }

        nav.setAttribute("data-ov-done", "1");
    }


    function upgradeJspPages(){
        var header = document.querySelector("header");
        var nav = document.querySelector("header nav");
        var container = document.querySelector(".container");


        if (header && nav && container) {
            document.body.classList.add("ov-app");
            decorateNav(nav);
        }
    }


    function upgradeDashboardServlet(){
        if (!document.body.classList.contains("dashboard-servlet")) return;


        if (document.querySelector("header nav[data-ov-done='1']")) return;


        var allLinks = document.querySelectorAll("a");
        var logoutHref = null;
        var menu = [];

        for (var i = 0; i < allLinks.length; i++) {
            var href = allLinks[i].getAttribute("href") || "";
            var text = cleanText(allLinks[i].textContent);
            if (!href) continue;

            if (href.indexOf("/logout") !== -1) {
                logoutHref = href;
            } else {
                menu.push({ href: href, text: text });
            }
        }


        var welcome = "";
        var ps = document.querySelectorAll("p");
        for (var p = 0; p < ps.length; p++) {
            var t = cleanText(ps[p].textContent);
            if (t.indexOf("Welcome:") === 0) { welcome = t; break; }
        }


        var errorText = "";
        for (var e = 0; e < ps.length; e++) {
            var st = (ps[e].getAttribute("style") || "");
            var tt = cleanText(ps[e].textContent);
            if (st.indexOf("color:red") !== -1 && tt) { errorText = tt; break; }
        }


        var fullName = "";
        var role = "";
        if (welcome) {
            var x = welcome.replace("Welcome:", "").trim();
            var open = x.lastIndexOf("(");
            var close = x.lastIndexOf(")");
            if (open !== -1 && close !== -1 && close > open) {
                role = x.substring(open + 1, close).trim();
                fullName = x.substring(0, open).trim();
            } else {
                fullName = x;
            }
        }


        var header = document.createElement("header");

        var top = document.createElement("div");
        top.className = "top";

        var left = document.createElement("div");
        left.innerHTML = "<h1>Ocean View Resort</h1><div class='sub'>Hotel Reservation &amp; Billing System (oceanviewresort.lk)</div>";

        var right = document.createElement("div");
        right.className = "small";

        if (fullName) {
            right.innerHTML = "Logged in as <b>" + fullName + "</b>" + (role ? " (" + role + ")" : "");
        } else {
            right.innerHTML = "Logged in";
        }

        if (logoutHref) {
            right.innerHTML += " | <a href='" + logoutHref + "'>Logout</a>";
        }

        top.appendChild(left);
        top.appendChild(right);
        header.appendChild(top);


        var nav = document.createElement("nav");


        var dash = document.createElement("a");
        dash.href = window.location.pathname;
        dash.textContent = "Dashboard";
        nav.appendChild(dash);


        var seen = {};
        for (var k = 0; k < menu.length; k++) {
            var key = menu[k].href + "|" + menu[k].text;
            if (seen[key]) continue;
            seen[key] = true;

            var a = document.createElement("a");
            a.href = menu[k].href;
            a.textContent = menu[k].text;
            nav.appendChild(a);
        }

        header.appendChild(nav);


        var container = document.createElement("div");
        container.className = "container";

        var card = document.createElement("div");
        card.className = "card";
        card.innerHTML = "<h2>Dashboard</h2><div class='small'>Select a function from the left menu.</div>";

        if (errorText) {
            var err = document.createElement("div");
            err.className = "err";
            err.textContent = errorText;
            card.insertBefore(err, card.children[1]);
        }

        container.appendChild(card);


        var footer = document.createElement("footer");
        footer.innerHTML =
            "<div>Ocean View Resort | Hotel Reservation & Billing System</div>" +
            "<div class='small'>Developed by Rakindu Fernando</div>";


        document.body.innerHTML = "";
        document.body.classList.add("ov-app");
        document.body.appendChild(header);
        document.body.appendChild(container);
        document.body.appendChild(footer);


        decorateNav(nav);
    }

    document.addEventListener("DOMContentLoaded", function () {
        upgradeDashboardServlet();
        upgradeJspPages();
    });
})();
