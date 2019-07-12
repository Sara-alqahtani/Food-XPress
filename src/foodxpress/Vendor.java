package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Vendor {
    public String id;
    public int shop_id;

    public Vendor(ResultSet rs) {
        try {
            id = rs.getString("id");
            shop_id = rs.getInt("shop_id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
