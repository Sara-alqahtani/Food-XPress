package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "foodxpress.UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer orderId = Utils.tryParseInt(request.getParameter("order_id"));
        OrderStatus status = Utils.tryParseEnum(OrderStatus.class, request.getParameter("status"));
        HttpSession session = request.getSession();
        Vendor vendor = (Vendor) session.getAttribute("vendor");

        if (orderId != null && orderId > 0 && status != null) {
            SQLProvider provider = new SQLProvider();
            Repository repository = new Repository(provider);
            repository.updateOrderStatus(vendor.shop_id, orderId, status);
            response.sendRedirect("vendor-home?order_id=" + orderId);
            return;
        }
        PrintWriter out = response.getWriter();
        out.println("Error updating order status.");
    }
}
