package foodxpress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet(name = "foodxpress.CartServlet")
public class CartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = null;
        if (session.getAttribute("user") == null) {
            response.sendRedirect("welcome");
            return;
        } else {
            user = (User) session.getAttribute("user");
        }

        String cartXml = request.getParameter("cart");
        System.out.println(cartXml);
        Cart cart = null;
        response.setStatus(400);                    // return 400 Bad Request to client
        PrintWriter out = response.getWriter();
        try {
            JAXBContext ctx = JAXBContext.newInstance(Cart.class);
            Unmarshaller um = ctx.createUnmarshaller();
            StringReader reader = new StringReader(cartXml);
            cart = (Cart) um.unmarshal(reader);
        } catch (JAXBException e) {
            e.printStackTrace();
            out.println("Error checking out cart. Please try again.");
            return;
        }
//        // demonstrate info from client side is wrong
//        cart.itemList.cartItems.get(0).id = 100;
//        for (CartItem item : cart.itemList.cartItems) {
//            System.out.println(item.id);
//        }

        if (cart.shop_id < 1) {
            out.println("Invalid shop id.");
            return;
        }
        if (cart.itemList.cartItems.isEmpty()) {
            out.println("Cart must contain at least one item in order to checkout.");
            return;
        }
        for (CartItem item : cart.itemList.cartItems) {
            if (item.id < 1) {
                out.println("Invalid food choice.");
                return;
            }
            if (item.quantity < 1) {
                out.println("Food quantity must be at least one.");
                return;
            }
        }

        SQLProvider provider = new SQLProvider();
        Repository repository = new Repository(provider);
        HashMap<Integer, Food> foodMap = repository.getFoodPriceMap(cart.itemList, cart.shop_id);
        if (foodMap.size() != cart.itemList.cartItems.size()) {
            out.println("Error checking out cart. Please try again.");
            return;
        }

        double subtotal = 0;
        double sum;
        ArrayList<OrderItem> orderList = new ArrayList<>();
        for (CartItem item : cart.itemList.cartItems) {
            sum = foodMap.get(item.id).price * item.quantity;
            orderList.add(new OrderItem(item.id, foodMap.get(item.id).name, item.quantity, sum, item.remark));
            subtotal += sum;
        }
        Shop shop = repository.getShopInfo(cart.shop_id);
        double deliveryFee = shop.delivery_fee;
        double total = subtotal + deliveryFee;

        // start a new DB connection to perform transaction
        repository = new Repository(new SQLProvider());
        int orderId = repository.createOrder(user.username, cart.shop_id, subtotal, deliveryFee, total, orderList);
        if (orderId < 1) {
            out.println("Error checking out cart. Please try again.");
            return;
        }
        response.setStatus(200);                    // return 200 OK to client
        out.println("order-status?order_id=" + orderId + "&shop_id=" + cart.shop_id);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
