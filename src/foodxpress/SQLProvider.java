package foodxpress;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLProvider {
    static final String JDBC_CLASS_NAME = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/foodxpress";
    static final String USERNAME = Credential.USERNAME;
    static final String PASSWORD = Credential.PASSWORD;

    Connection connection;

    public SQLProvider() {
        //Load the driver class
        try {
            Class.forName(JDBC_CLASS_NAME);
        } catch (ClassNotFoundException ex) {
            System.out.println("Unable to load the class. Terminating the program");
            System.exit(-1);
        }
        //get the connection
        try {
            connection = DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
        } catch (SQLException ex) {
            System.out.println("Error getting connection: " + ex.getMessage());
            System.exit(-1);
        }
    }
}
