package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;

public class Shop {
    public int id;
    public String name;
    public ShopLocation location;
    public String image_url;
    public String description;
    public Time operation_start_time;
    public Time operation_end_time;
    public int delivery_time;
    public double delivery_fee;
    public double rating;

    public Shop(ResultSet rs) {
        try {
            id = rs.getInt("id");
            name = rs.getString("name");
            location = ShopLocation.valueOf(rs.getString("location").replace('#', '_'));
            image_url = rs.getString("image");
            description = rs.getString("description");
            operation_start_time = rs.getTime("operation_start_time");
            operation_end_time = rs.getTime("operation_end_time");
            delivery_time = rs.getInt("delivery_time");
            delivery_fee = rs.getDouble("delivery_fee");
            rating = rs.getDouble("rating");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
