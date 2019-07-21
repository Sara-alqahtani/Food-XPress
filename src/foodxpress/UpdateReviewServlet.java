package foodxpress;

import javax.rmi.CORBA.Util;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "foodxpress.UpdateReviewServlet")
public class UpdateReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String[]> map = request.getParameterMap();
        HashMap<Integer, Integer> ratingMap = new HashMap<>();
        map.forEach((key, value) -> {
            if ( !(key.equals("order_id") || key.equals("shop_id") || key.equals("shop_rating")) ) {
                ratingMap.put(Integer.parseInt(key), Integer.parseInt(value[0]));
            }
            System.out.println(key + ": " + value[0]);
        });
        Integer order_id = Utils.tryParseInt(request.getParameter("order_id"));
        Integer shop_id = Utils.tryParseInt(request.getParameter("shop_id"));
        Integer shop_rating = Utils.tryParseInt(request.getParameter("shop_rating"));

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isSuccess = false;
        if (order_id != null && shop_id != null && shop_rating != null) {
            isSuccess = repository.updateRating(order_id, shop_id, shop_rating, ratingMap);
        }
        if (isSuccess) {
            response.sendRedirect("order-list");
        } else {
            PrintWriter out = response.getWriter();
            out.println("Error in updating rating. Please try again.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
