package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class Order {
    public int id;
    public int shop_id;
    public String username;
    public int promo_code;
    public Date datetime;
    public double subtotal;
    public double delivery_fee;
    public double discount;
    public double total;
    public OrderStatus status;
    public String shop_name;
    public boolean isReviewed;

    public Order(ResultSet rs) {
        try {
            id = rs.getInt("id");
            shop_id = rs.getInt("shop_id");
            username = rs.getString("username");
            promo_code = rs.getInt("promo_code");
            datetime = rs.getTimestamp("order_datetime");
            subtotal = rs.getDouble("subtotal");
            delivery_fee = rs.getDouble("delivery_fee");
            discount = rs.getDouble("discount");
            total = rs.getDouble("total");
            status = OrderStatus.valueOf(rs.getString("status").toUpperCase());
            shop_name = rs.getString("shop_name");
            isReviewed = rs.getBoolean("isReviewed");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
