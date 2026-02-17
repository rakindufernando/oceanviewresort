<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("pageTitle", "Transactions - Admin");
    List<String[]> tx = (List<String[]>) request.getAttribute("tx");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>All Transactions (Payments)</h2>
    <p class="small">Shows payment transactions made by staff.</p>

    <table>
        <tr><th>Date</th><th>Reservation No</th><th>Amount</th><th>Method</th><th>Reference</th><th>Received By</th></tr>
        <%
            if (tx != null) {
                for (String[] t : tx) {
        %>
        <tr>
            <td><%= t[0] %></td>
            <td><%= t[1] %></td>
            <td><%= t[2] %></td>
            <td><%= t[3] %></td>
            <td><%= t[4] != null ? t[4] : "" %></td>
            <td><%= t[5] %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
</div>

<jsp:include page="../partials/footer.jsp"/>
