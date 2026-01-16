package com.stockpulse.dao;

import com.stockpulse.model.Supplier;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Supplier operations
 */
public class SupplierDAO {

    private Connection connection;

    public SupplierDAO() throws SQLException {
        this.connection = DBConnection.getInstance().getConnection();
    }

    /**
     * Get all suppliers with product count
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT s.*, COUNT(p.id) as product_count " +
                "FROM suppliers s " +
                "LEFT JOIN products p ON s.id = p.supplier_id " +
                "GROUP BY s.id " +
                "ORDER BY s.company_name";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Supplier supplier = extractSupplier(rs);
                supplier.setProductCount(rs.getInt("product_count"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.err.println("Error getting suppliers: " + e.getMessage());
        }

        return suppliers;
    }

    /**
     * Get supplier by ID
     */
    public Supplier getSupplierById(int id) {
        String sql = "SELECT * FROM suppliers WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractSupplier(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting supplier: " + e.getMessage());
        }

        return null;
    }

    /**
     * Create a new supplier
     */
    public boolean createSupplier(Supplier supplier) {
        String sql = "INSERT INTO suppliers (company_name, contact_email, phone, address) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, supplier.getCompanyName());
            stmt.setString(2, supplier.getContactEmail());
            stmt.setString(3, supplier.getPhone());
            stmt.setString(4, supplier.getAddress());

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    supplier.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating supplier: " + e.getMessage());
        }

        return false;
    }

    /**
     * Update a supplier
     */
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE suppliers SET company_name = ?, contact_email = ?, phone = ?, address = ? WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, supplier.getCompanyName());
            stmt.setString(2, supplier.getContactEmail());
            stmt.setString(3, supplier.getPhone());
            stmt.setString(4, supplier.getAddress());
            stmt.setInt(5, supplier.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating supplier: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete a supplier
     */
    public boolean deleteSupplier(int id) {
        String sql = "DELETE FROM suppliers WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting supplier: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to extract Supplier from ResultSet
     */
    private Supplier extractSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setId(rs.getInt("id"));
        supplier.setCompanyName(rs.getString("company_name"));
        supplier.setContactEmail(rs.getString("contact_email"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setAddress(rs.getString("address"));
        supplier.setCreatedAt(rs.getTimestamp("created_at"));
        return supplier;
    }
}
