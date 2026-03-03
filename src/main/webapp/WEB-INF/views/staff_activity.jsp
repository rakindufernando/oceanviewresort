<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    request.setAttribute("pageTitle", "Staff Activity - Ocean View Resort");

    List<String[]> logs = (List<String[]>) request.getAttribute("logs");
    List<String[]> users = (List<String[]>) request.getAttribute("users");

    String selectedUser = request.getParameter("userId") != null ? request.getParameter("userId") : "";
    String from = request.getParameter("from") != null ? request.getParameter("from") : "";
    String to = request.getParameter("to") != null ? request.getParameter("to") : "";
    String q = request.getParameter("q") != null ? request.getParameter("q") : "";
    String limit = request.getParameter("limit") != null ? request.getParameter("limit") : "200";

    boolean defaultToday = request.getAttribute("defaultToday") != null;

    String actionUrl = (String) request.getAttribute("actionUrl");
    if (actionUrl == null) actionUrl = request.getContextPath() + "/app/admin/staff-activity";
%>

<jsp:include page="partials/header.jsp"/>

<div class="card">
    <h2>Staff Activity</h2>
    <p class="small">This page shows staff actions like adding guests, creating reservations, payments, cancellations and admin tasks.</p>

    <%
        if (defaultToday) {
    %>
    <div class="small">Showing today logs by default. Use filters to change the date range.</div>
    <%
        }
    %>

    <form method="get" action="<%= actionUrl %>" id="activityForm">
        <div class="row">
            <div class="col">
                <label>Staff User</label>
                <select name="userId">
                    <option value="">All Users</option>
                    <%
                        if (users != null) {
                            for (String[] u : users) {
                                String id = u.length > 0 ? u[0] : "";
                                String username = u.length > 1 ? u[1] : "";
                                String fullName = u.length > 2 ? u[2] : "";
                                String userRole = u.length > 3 ? u[3] : "";
                                String isActive = u.length > 4 ? u[4] : "";

                                boolean active = "1".equals(isActive) || "true".equalsIgnoreCase(isActive);
                                if (!active) continue;

                                String label = fullName != null && !fullName.trim().isEmpty() ? fullName : username;
                                label = label + " (" + userRole + ")";
                    %>
                    <option value="<%= esc(id) %>" <%= id.equals(selectedUser) ? "selected" : "" %>><%= esc(label) %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="col">
                <label>From Date</label>
                <input type="date" name="from" id="fromDate" value="<%= esc(from) %>">
            </div>

            <div class="col">
                <label>To Date</label>
                <input type="date" name="to" id="toDate" value="<%= esc(to) %>">
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Search Keyword</label>
                <input type="text" name="q" value="<%= esc(q) %>" placeholder="ex ADD_GUEST, OV, mobile">
            </div>

            <div class="col">
                <label>Show Rows</label>
                <select name="limit">
                    <option value="50" <%= "50".equals(limit) ? "selected" : "" %>>50</option>
                    <option value="100" <%= "100".equals(limit) ? "selected" : "" %>>100</option>
                    <option value="200" <%= "200".equals(limit) ? "selected" : "" %>>200</option>
                    <option value="500" <%= "500".equals(limit) ? "selected" : "" %>>500</option>
                </select>
            </div>

            <div class="col" style="display:flex; gap:10px; align-items:flex-end;">
                <button class="btn" type="submit">Search</button>
                <button class="btn2" type="button" id="btnToday">Today</button>
                <a class="btn2" href="<%= actionUrl %>">Reset</a>
            </div>
        </div>
    </form>

    <hr>

    <table>
        <tr>
            <th>Date Time</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Role</th>
            <th>Action</th>
            <th>Entity</th>
            <th>Entity Id</th>
            <th>Details</th>
        </tr>

        <%
            if (logs != null && !logs.isEmpty()) {
                for (String[] a : logs) {
                    String c0 = a.length > 0 ? a[0] : "";
                    String c1 = a.length > 1 ? a[1] : "";
                    String c2 = a.length > 2 ? a[2] : "";
                    String c3 = a.length > 3 ? a[3] : "";
                    String c4 = a.length > 4 ? a[4] : "";
                    String c5 = a.length > 5 ? a[5] : "";
                    String c6 = a.length > 6 ? a[6] : "";
                    String c7 = a.length > 7 ? a[7] : "";
        %>
        <tr>
            <td><%= esc(c0) %></td>
            <td><%= esc(c1) %></td>
            <td><%= esc(c2) %></td>
            <td><%= esc(c3) %></td>
            <td><%= esc(c4) %></td>
            <td><%= esc(c5) %></td>
            <td><%= esc(c6) %></td>
            <td><%= esc(c7) %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" class="small">No activity logs found for selected filters.</td>
        </tr>
        <%
            }
        %>
    </table>
</div>

<script>
    (function () {
        var btn = document.getElementById("btnToday");
        var form = document.getElementById("activityForm");
        if (!btn || !form) return;

        btn.addEventListener("click", function () {
            var d = new Date();
            var yyyy = d.getFullYear();
            var mm = String(d.getMonth() + 1).padStart(2, "0");
            var dd = String(d.getDate()).padStart(2, "0");
            var v = yyyy + "-" + mm + "-" + dd;

            document.getElementById("fromDate").value = v;
            document.getElementById("toDate").value = v;

            form.submit();
        });
    })();
</script>

<jsp:include page="partials/footer.jsp"/>