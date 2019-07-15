package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "foodxpress.UpdateReviewServlet")
public class UpdateReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer orderId = Utils.tryParseInt(request.getParameter("order_id"));
        Integer shopId = Utils.tryParseInt(request.getParameter("shop_id"));
        Integer rating = Integer.valueOf(request.getParameter("rating"));
        Integer shop_rating = Integer.valueOf(request.getParameter("rating2"));
        System.out.print("rating:" + rating);

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        boolean isReviewed = false;
        boolean isFoodRatingSuccess = false ;
        boolean isShopRatingSuccess = false;
        HttpSession session = request.getSession();

        if (orderId != null && orderId > 0 && shopId != null) {

            isReviewed= repository.updateReviewStatus(shopId, orderId, isReviewed);
            isFoodRatingSuccess = repository.updateFoodRating(shopId, orderId, rating);
            isShopRatingSuccess= repository.updateShopRating(shopId,shop_rating);
        }

        if (isReviewed && isFoodRatingSuccess & isShopRatingSuccess){
            response.sendRedirect("order-list");
            return;
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
