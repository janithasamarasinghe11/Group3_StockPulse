package com.stockpulse.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Singleton
 * Demonstrates SINGLETON DESIGN PATTERN - only one instance exists.
 * 
 * Configuration is set for XAMPP MySQL:
 * - Host: localhost
 * - Port: 3306
 * - Database: stockpulse
 * - User: root
 * - Password: (empty)
 */
public class DBConnection {
    
    // Database configuration
    private static final String URL = "jdbc:mysql://localhost:3306/stockpulse?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";  // XAMPP default - no password
    
    // Singleton instance
    private static DBConnection instance;
    private Connection connection;
    
    /**
     * Private constructor - prevents external instantiation (Singleton)
     */
    private DBConnection() {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    /**
     * Get the singleton instance of DBConnection
     * Thread-safe implementation
     */
    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }
    
    /**
     * Get a database connection
     * Creates a new connection if the current one is closed or null
     */
    public Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("✓ Database connection established");
            } catch (SQLException e) {
                System.err.println("✗ Failed to connect to database: " + e.getMessage());
                throw e;
            }
        }
        return connection;
    }
    
    /**
     * Close the database connection
     */
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("✓ Database connection closed");
            } catch (SQLException e) {
                System.err.println("✗ Error closing connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test the database connection
     * @return true if connection is successful
     */
    public boolean testConnection() {
        try {
            Connection conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}
