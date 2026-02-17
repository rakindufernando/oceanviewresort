package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.PaymentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/admin/transactions")
public class AdminTransactionsServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<String[]> tx = paymentDAO.listAllTransactions();
        req.setAttribute("tx", tx);

        req.getRequestDispatcher("/WEB-INF/views/admin/transactions.jsp").forward(req, resp);
    }
}
