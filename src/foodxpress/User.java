package foodxpress;

import java.sql.ResultSet;
import java.sql.SQLException;

public class User {
    public String username;
    public String mobile;
    public PickUpLocation location;
    public String image_url;

    public User(ResultSet rs) {
        try {
            username = rs.getString("username");
            mobile = rs.getString("mobile");
            location = PickUpLocation.valueOf(rs.getString("location"));
            image_url = rs.getString("image");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
