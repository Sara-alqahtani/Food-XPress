package foodxpress;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import com.sun.org.apache.xpath.internal.operations.Or;

import javax.swing.plaf.nimbus.State;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.servlet.http.*;

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

    public ArrayList<Order> getAllOrdersofUsers(String username){

        String sql="SELECT orders.*,shops.name as shop_name\n" +
                "FROM orders,shops\n" +
                "WHERE username= '"+ username+ "' AND orders.shop_id = shops.id"+ " \n" +
                "Order by order_datetime DESC;";
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

    public Shop getShopName (int shopId,int orderId){
        String sql= " SELECT name,shops.id,orders.id FROM shops,orders\n" +
                "WHERE shops.id='"+shopId+"' AND orders.id= '"+ orderId +"' AND shops.id= orders.shop_id;";
        System.out.println(sql);
        Shop shopname = null;
        try {
            Statement stm = provider.connection.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                shopname = new Shop(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shopname;
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

    public boolean updateUserInfo (String username, String mobile, String location){
        String sql = "update users set mobile = '"+ mobile + " ',location = '"+ location +
                "' where username = '"+ username + "';";
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

    public boolean changePassword (String username, String oldPassword, String newPassword){
        String sql = "update users set password = '"+ newPassword +
                "' where username = '"+ username + "'and password = '"+ oldPassword +"';";
//        System.out.println(sql);
        boolean isSuccess=false;

        try{
            Statement stm = provider.connection.createStatement();
            stm.executeUpdate(sql);
            isSuccess = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isSuccess;
    }
}
