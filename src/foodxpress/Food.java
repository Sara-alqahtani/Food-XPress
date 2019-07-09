package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Food {
    public int id;
    public String name;
    public String category;
    public int shop_id;
    public double price;
    public int prepare_time;
    public String image_url;
    public String description;
    public double rating;

    public Food(int id, String name, double price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    public Food(ResultSet rs) {
        try {
            id = rs.getInt("id");
            name = rs.getString("name");
            category = rs.getString("category");
            shop_id = rs.getInt("shop_id");
            price = rs.getDouble("price");
            prepare_time = rs.getInt("prepare_time");
            image_url = rs.getString("image");
            description = rs.getString("description");
            if (rs.wasNull()) {
                description = "";
            }
            rating = rs.getDouble("rating");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
