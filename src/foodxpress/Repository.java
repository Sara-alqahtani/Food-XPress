package foodxpress;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import com.sun.org.apache.xpath.internal.operations.Or;

import javax.xml.transform.Result;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

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
//        System.out.println(sql);
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
        String sql = "SELECT username, mobile, location, image FROM users WHERE username='" +
                username + "' AND password='" +
                password + "';";
//        System.out.println(sql);
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

    public boolean updateUserInfo(String username, String mobile, String location){
        String sql = "UPDATE users SET mobile='"+ mobile + " ', location='"+ location +
                "' WHERE username='"+ username + "';";
        System.out.println(sql);
        boolean isSuccess = false;
        try {
            Statement stm = provider.connection.createStatement();
            stm.executeUpdate(sql);
            isSuccess = true;
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public boolean changePassword(String username, String oldPassword, String newPassword){
        String sql = "SELECT username FROM users WHERE username='" +
                username + "' AND password='" +
                oldPassword + "';";
        boolean isSuccess = false;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                sql = "UPDATE users SET password='"+ newPassword +
                        "' WHERE username='"+ username + "' AND password='"+ oldPassword +"';";
//                System.out.println(sql);
                stm.executeUpdate(sql);
                isSuccess = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
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

    public Shop getShopInfo(int shopId) {
        String sql = "SELECT id, name, location, image, description, operation_start_time, operation_end_time, " +
                "delivery_time, delivery_fee, (rate_sum/rate_count) as rating " +
                "FROM shops " +
                "WHERE id=" +
                shopId + ";";
        System.out.println(sql);
        Shop shop = null;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                shop = new Shop(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shop;
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

    public HashMap<Integer, Food> getFoodPriceMap(CartItemList itemList, int shopId) {
        String sql = "SELECT id, name, price FROM foods WHERE shop_id=" +
                shopId + " AND id IN (";
        StringBuilder sb = new StringBuilder(sql);
        for (int i = 0; i < itemList.cartItems.size(); i++) {
            sb.append(itemList.cartItems.get(i).id);
            if (i < itemList.cartItems.size() - 1) {
                sb.append(", ");
            }
        }
        sb.append(")");
        sql = sb.toString();
        System.out.println(sql);
        HashMap<Integer, Food> foodMap = new HashMap<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                Food food = new Food(rs.getInt("id"), rs.getString("name"), rs.getDouble("price"));
                foodMap.put(food.id, food);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return foodMap;
    }

    public ArrayList<Order> getAllOrdersofUser(String username){
        String sql="SELECT orders.*, shops.name AS shop_name " +
                "FROM orders, shops " +
                "WHERE username='"+ username+ "' AND orders.shop_id=shops.id " +
                "ORDER BY order_datetime DESC;";
        System.out.println(sql);
        ArrayList<Order> orderlist = new ArrayList<>();

        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                orderlist.add(new Order(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderlist;
    }

    public Order getOrderInfo(int shopId, int orderId) {
        String sql = "SELECT orders.*, shops.name AS shop_name FROM orders INNER JOIN shops " +
                "WHERE orders.shop_id=shops.id AND orders.id=" +
                orderId + " AND orders.shop_id=" +
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

    public int createOrder(String username, int shopId, double subtotal, double deliveryFee, double total, ArrayList<OrderItem> orderList) {
        int orderId;
        try {
            provider.connection.setAutoCommit(false);       // start transaction
            String sql = "SELECT (@new_id := next_order_id) AS new_id FROM shops WHERE id=" + shopId + ";";
            System.out.println(sql);
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                orderId = rs.getInt("new_id");
            } else {
                throw new SQLException("New order id not returned.");
            }
            sql = "INSERT INTO orders (shop_id, username, subtotal, delivery_fee, discount, total, status) \n" +
                    "VALUES (" + shopId + ", '" + username + "', " +
                    subtotal + ", " +
                    deliveryFee + ", 0, " +
                    total + ", '" +
                    OrderStatus.values()[0].toString().toLowerCase() + "');";
            System.out.println(sql);
            stm.executeUpdate(sql);
            sql = "INSERT INTO order_items (order_id, shop_id, food_id, food_name, quantity, subtotal, remark) VALUES \n";
            StringBuilder sb = new StringBuilder(sql);
            for (int i = 0; i < orderList.size(); i++) {
                OrderItem item = orderList.get(i);
                sb.append("(@new_id, ");
                sb.append(shopId);
                sb.append(", ");
                sb.append(item.food_id);
                sb.append(", '");
                sb.append(item.food_name);
                sb.append("', ");
                sb.append(item.quantity);
                sb.append(", ");
                sb.append(item.subtotal);
                sb.append(", ");
                sb.append(item.remark);
                sb.append(")");
                if (i < orderList.size() - 1) {
                    sb.append(",\n");
                }
            }
            sb.append(";\n");
            sql = sb.toString();
            System.out.println(sql);
            stm.executeUpdate(sql);
            provider.connection.commit();                   // commit transaction
            provider.connection.setAutoCommit(true);        // end transaction
        } catch (SQLException e) {
            orderId = -1;
            e.printStackTrace();
            try {
                provider.connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return orderId;
    }

    public Vendor vendorLogin(String vendorId, String password) {
        String sql = "SELECT id, shop_id FROM vendors WHERE id='" +
                vendorId + "' AND password='" +
                password + "';";
//        System.out.println(sql);
        Vendor vendor = null;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                vendor = new Vendor(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vendor;
    }

    public boolean vendorChangePassword(String vendorId, String oldPassword, String newPassword){
        String sql = "SELECT id FROM vendors WHERE id='" +
                vendorId + "' AND password='" +
                oldPassword + "';";
        boolean isSuccess = false;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                sql = "UPDATE vendors SET password='"+ newPassword +
                        "' WHERE id='"+ vendorId + "' AND password='"+ oldPassword +"';";
//                System.out.println(sql);
                stm.executeUpdate(sql);
                isSuccess = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public ArrayList<Order> getAllOrdersOfShop(int shopId) {
        String sql = "SELECT orders.*, shops.name AS shop_name FROM orders INNER JOIN shops " +
                "WHERE orders.shop_id=shops.id AND shop_id=" +
                shopId + " ORDER BY order_datetime DESC;";
        System.out.println(sql);
        ArrayList<Order> orders = new ArrayList<>();
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            while (rs.next()) {
                orders.add(new Order(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatus(int shopId, int orderId, OrderStatus status) {
        String sql = "UPDATE orders SET status='" +
                status.toString().toLowerCase() +
                "' WHERE shop_id=" +
                shopId + " AND id=" +
                orderId + ";";
        System.out.println(sql);
        boolean isSuccess = false;
        try {
            Statement stm = provider.connection.createStatement();
            stm.executeUpdate(sql);
            isSuccess = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public User getUserInfo(String username) {
        String sql = "SELECT username, mobile, location, image FROM users WHERE username='" +
                username + "';";
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
}
