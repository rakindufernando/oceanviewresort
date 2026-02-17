<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("pageTitle", "User Management - Admin");
    String ctx = request.getContextPath();

    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");

    List<String[]> users = (List<String[]>) request.getAttribute("users");
    List<String[]> roles = (List<String[]>) request.getAttribute("roles");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>User Management (Admin)</h2>

    <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
    <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

    <h3>Add New User</h3>
    <form method="post" action="<%= ctx %>/app/admin/users">
        <div class="row">
            <div class="col">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="col">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <div class="col">
                <label>Full Name</label>
                <input type="text" name="fullName" required>
            </div>
            <div class="col">
                <label>Role</label>
                <select name="roleId" required>
                    <%
                        if (roles != null) {
                            for (String[] r : roles) {
                    %>
                    <option value="<%= r[0] %>"><%= r[1] %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>
        <div style="margin-top:10px;">
            <button class="btn" type="submit">Add User</button>
        </div>
    </form>

    <hr>

    <h3>All Users</h3>
    <table>
        <tr><th>ID</th><th>Username</th><th>Full Name</th><th>Role</th><th>Active</th><th>Actions</th></tr>
        <%
            if (users != null) {
                for (String[] u : users) {
                    String id = u[0];
                    String active = u[4];
                    boolean isActive = "1".equals(active) || "true".equalsIgnoreCase(active);
        %>
        <tr>
            <td><%= id %></td>
            <td><%= u[1] %></td>
            <td><%= u[2] %></td>
            <td><%= u[3] %></td>
            <td><%= isActive ? "YES" : "NO" %></td>
            <td>
                <a class="btn2" href="<%= ctx %>/app/admin/user/edit?id=<%= id %>">Edit</a>
                <a class="btn2" href="<%= ctx %>/app/admin/user/reset?id=<%= id %>"
                   onclick="return confirm('Reset password to ocean123?');">Reset</a>

                <% if (isActive) { %>
                <a class="btn2" href="<%= ctx %>/app/admin/user/toggle?id=<%= id %>&active=0"
                   onclick="return confirm('Disable this user?');">Disable</a>
                <% } else { %>
                <a class="btn2" href="<%= ctx %>/app/admin/user/toggle?id=<%= id %>&active=1"
                   onclick="return confirm('Enable this user?');">Enable</a>
                <% } %>

                <a class="btn2" href="<%= ctx %>/app/admin/user/delete?id=<%= id %>"
                   onclick="return confirm('Delete this user? If fails, disable user.');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
</div>

<jsp:include page="../partials/footer.jsp"/>
