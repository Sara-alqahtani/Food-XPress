package foodxpress;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import com.sun.org.apache.xpath.internal.operations.Or;

import javax.swing.plaf.nimbus.State;
import java.sql.Array;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Repository {
    private SQLProvider provider;
    public Repository(SQLProvider provider) {
        this.provider = provider;
    }

    public boolean register(String username, String password, String mobile, String location) {
        String sql = "INSERT INTO users (username, password, mobile, location) VALUES('" +
                username + "','" +
                password + "','" +
                mobile + "' ,'" +
                location + "'); ";
        System.out.println(sql);
        boolean isSuccess = false;
        try {
            Statement stm = provider.connection.createStatement();
            stm.executeUpdate(sql);
            isSuccess = true;
        } catch (MySQLIntegrityConstraintViolationException e) {
            System.out.println("User register failed: Username is taken");
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username='" +
                username + "' AND password='" +
                password + "';";
        System.out.println(sql);
        User user = null;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                user = new User(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public ArrayList<Shop> getAllShops() {
        String sql = "SELECT id, name, location, image, description, operation_start_time, operation_end_time, " +
                "delivery_time, delivery_fee, (rate_sum/rate_count) as rating " +
                "FROM shops " +
                "ORDER BY location ASC;";
        System.out.println(sql);
        ArrayList<Shop> shops = new ArrayList<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                shops.add(new Shop(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shops;
    }

    public ArrayList<String> getAllCategoriesInShop(int shopId) {
        String sql = "SELECT name " +
                "FROM category " +
                "WHERE shop_id=" +
                shopId + " ORDER BY name ASC;";
        System.out.println(sql);
        ArrayList<String> categories = new ArrayList<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                categories.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public ArrayList<Food> getAllFoodsInShop(int shopId) {
        String sql = "SELECT id, name, category, shop_id, price, prepare_time, image, description, " +
                "(rate_sum/rate_count) AS rating " +
                "FROM foods " +
                "WHERE shop_id=" +
                shopId + " ORDER BY category ASC;";
        System.out.println(sql);
        ArrayList<Food> foods = new ArrayList<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                foods.add(new Food(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return foods;
    }

    public Order getOrderInfo(int shopId, int orderId) {
        String sql = "SELECT * FROM orders WHERE id=" +
                orderId + " AND shop_id=" +
                shopId + ";";
        System.out.println(sql);
        Order order = null;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                order = new Order(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    public ArrayList<OrderItem> getAllOrderItemsInOrder(int shop_id, int order_id) {
        String sql = "SELECT * FROM order_items WHERE order_id=" +
                order_id + " AND shop_id=" +
                shop_id + " ORDER BY food_id;";
        System.out.println(sql);
        ArrayList<OrderItem> orderItems = new ArrayList<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                orderItems.add(new OrderItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItems;
    }
}
