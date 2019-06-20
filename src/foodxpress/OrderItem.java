package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderItem {
    public int food_id;
    public int order_id;
    public int shop_id;
    public String food_name;
    public int quantity;
    public double subtotal;
    public String remark;

    public OrderItem(ResultSet rs) {
        try {
            food_id = rs.getInt("food_id");
            order_id = rs.getInt("order_id");
            shop_id = rs.getInt("shop_id");
            food_name = rs.getString("food_name");
            quantity = rs.getInt("quantity");
            subtotal = rs.getDouble("subtotal");
            remark = rs.getString("remark");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
