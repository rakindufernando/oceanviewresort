<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.Guest" %>
<%
  request.setAttribute("pageTitle", "Guests - Receptionist");
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Guest> guests = (List<Guest>) request.getAttribute("guests");
  String ctx = request.getContextPath();
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2>Guest Management</h2>
  <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
  <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

  <div class="row">
    <div class="col">
      <form method="get" action="<%= ctx %>/app/reception/guests">
        <label>Search (Name / Mobile / NIC)</label>
        <div class="row">
          <div class="col"><input type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"></div>
          <div style="min-width:160px;">
            <button class="btn" type="submit">Search</button>
            <a class="btn2" href="<%= ctx %>/app/reception/guests">Clear</a>
          </div>
        </div>
      </form>
    </div>
    <div style="min-width:190px; display:flex; align-items:flex-end;">
      <a class="btn" href="<%= ctx %>/app/reception/guest/new">Add New Guest</a>
    </div>
  </div>

  <table>
    <tr>
      <th>ID</th><th>Name</th><th>Mobile</th><th>NIC/Passport</th><th>Email</th><th>Actions</th>
    </tr>
    <%
      if (guests != null) {
        for (Guest g : guests) {
    %>
    <tr>
      <td><%= g.getGuestId() %></td>
      <td><%= g.getFullName() %></td>
      <td><%= g.getMobile() %></td>
      <td><%= g.getNicPassport() %></td>
      <td><%= g.getEmail() != null ? g.getEmail() : "" %></td>
      <td>
        <a class="btn2" href="<%= ctx %>/app/reception/guest/view?id=<%= g.getGuestId() %>">View</a>
        <a class="btn2" href="<%= ctx %>/app/reception/guest/edit?id=<%= g.getGuestId() %>">Edit</a>
        <a class="btn2" onclick="return confirm('Delete this guest?');"
           href="<%= ctx %>/app/reception/guest/delete?id=<%= g.getGuestId() %>">Delete</a>
      </td>
    </tr>
    <%
        }
      }
    %>
  </table>

  <p class="small">Mobile number and NIC/Passport must be unique (no duplicates).</p>
</div>

<jsp:include page="../partials/footer.jsp"/>
