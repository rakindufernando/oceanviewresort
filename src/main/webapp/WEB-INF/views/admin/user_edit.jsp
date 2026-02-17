<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
  request.setAttribute("pageTitle", "Edit User - Admin");
  String ctx = request.getContextPath();

  String[] userRow = (String[]) request.getAttribute("userRow");
  List<String[]> roles = (List<String[]>) request.getAttribute("roles");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2>Edit User</h2>

  <% if (userRow == null) { %>
  <div class="err">User not found.</div>
  <a class="btn2" href="<%= ctx %>/app/admin/users">Back</a>
  <% } else { %>
  <form method="post" action="<%= ctx %>/app/admin/user/edit">
    <input type="hidden" name="userId" value="<%= userRow[0] %>">

    <div class="row">
      <div class="col">
        <label>Username</label>
        <input type="text" name="username" value="<%= userRow[1] %>" required>
      </div>
      <div class="col">
        <label>Full Name</label>
        <input type="text" name="fullName" value="<%= userRow[2] %>" required>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>Role</label>
        <select name="roleId" required>
          <%
            if (roles != null) {
              for (String[] r : roles) {
                String sel = (userRow[3].equals(r[0])) ? "selected" : "";
          %>
          <option value="<%= r[0] %>" <%= sel %>><%= r[1] %></option>
          <%
              }
            }
          %>
        </select>
      </div>
      <div class="col">
        <label>Active</label>
        <select name="isActive">
          <option value="1" <%= "1".equals(userRow[4]) ? "selected" : "" %>>YES</option>
          <option value="0" <%= "0".equals(userRow[4]) ? "selected" : "" %>>NO</option>
        </select>
      </div>
    </div>

    <div style="margin-top:10px;">
      <button class="btn" type="submit">Update</button>
      <a class="btn2" href="<%= ctx %>/app/admin/users">Back</a>
    </div>
  </form>
  <% } %>
</div>

<jsp:include page="../partials/footer.jsp"/>
