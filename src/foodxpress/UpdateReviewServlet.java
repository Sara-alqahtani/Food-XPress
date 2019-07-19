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


        String oid = request.getParameter("order_id");
        String sid = request.getParameter("shop_id");

        boolean isReviewed = false;
        boolean isFoodRatingSuccess = false ;
        boolean isShopRatingSuccess = false;
        if ((oid!= null)&& (sid !=null)){
            try {
                Integer orderId = Integer.parseInt(request.getParameter("order_id"));
                Integer shopId = Integer.parseInt(request.getParameter("shop_id"));
                Integer foodId = Integer.parseInt( request.getParameter("food_id"));
                Integer rating = Integer.valueOf(request.getParameter("rating"));
                Integer shop_rating = Integer.valueOf(request.getParameter("ratingShop"));

                SQLProvider provider = new SQLProvider();
                Repository repository = new Repository(provider);


                isReviewed = repository.updateReviewStatus(shopId, orderId, isReviewed);
                isFoodRatingSuccess = repository.updateFoodRating(shopId, foodId, rating);
                isShopRatingSuccess = repository.updateShopRating(shopId, shop_rating);
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }


        if (isReviewed && isFoodRatingSuccess && isShopRatingSuccess){
            response.sendRedirect("order-list");
            return ;
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
