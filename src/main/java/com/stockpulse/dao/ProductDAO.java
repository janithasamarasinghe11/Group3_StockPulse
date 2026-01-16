package com.stockpulse.dao;

import com.stockpulse.model.AbstractItem;
import com.stockpulse.model.DurableItem;
import com.stockpulse.model.PerishableItem;

import java.math.BigDecimal;
import java.sql.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Product operations
 * Handles POLYMORPHIC products (PerishableItem and DurableItem)
 */
public class ProductDAO {

    private Connection connection;

    public ProductDAO() throws SQLException {
        this.connection = DBConnection.getInstance().getConnection();
    }

    /**
     * Get all products as polymorphic AbstractItem list
     */
    public List<AbstractItem> getAllProducts() {
        List<AbstractItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "ORDER BY p.name";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting products: " + e.getMessage());
        }

        return products;
    }

    /**
     * Get products by supplier ID
     */
    public List<AbstractItem> getProductsBySupplier(int supplierId) {
        List<AbstractItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.supplier_id = ? " +
                "ORDER BY p.name";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, supplierId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by supplier: " + e.getMessage());
        }

        return products;
    }

    /**
     * Get products by category ID
     */
    public List<AbstractItem> getProductsByCategory(int categoryId) {
        List<AbstractItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.category_id = ? " +
                "ORDER BY p.name";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by category: " + e.getMessage());
        }

        return products;
    }

    /**
     * Search products by name
     */
    public List<AbstractItem> searchProducts(String keyword) {
        List<AbstractItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.name LIKE ? OR p.description LIKE ? " +
                "ORDER BY p.name";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
        }

        return products;
    }

    /**
     * Get product by ID
     */
    public AbstractItem getProductById(int id) {
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractProduct(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting product: " + e.getMessage());
        }

        return null;
    }

    /**
     * Create a new product
     */
    public boolean createProduct(AbstractItem item) {
        String sql = "INSERT INTO products (name, description, price, quantity, category_id, supplier_id, type, expiry_date, warranty_period, manual_priority, use_auto_priority, image_path) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getDescription());
            stmt.setBigDecimal(3, item.getPrice());
            stmt.setInt(4, item.getQuantity());
            stmt.setInt(5, item.getCategoryId());
            stmt.setInt(6, item.getSupplierId());
            stmt.setString(7, item.getType());

            // Set type-specific fields
            if (item instanceof PerishableItem) {
                PerishableItem perishable = (PerishableItem) item;
                if (perishable.getExpiryDate() != null) {
                    stmt.setDate(8, Date.valueOf(perishable.getExpiryDate()));
                } else {
                    stmt.setNull(8, Types.DATE);
                }
                stmt.setNull(9, Types.INTEGER);
            } else if (item instanceof DurableItem) {
                DurableItem durable = (DurableItem) item;
                stmt.setNull(8, Types.DATE);
                stmt.setInt(9, durable.getWarrantyPeriod());
            }

            // Set priority toggle fields
            if (item.getManualPriority() != null) {
                stmt.setString(10, item.getManualPriority());
            } else {
                stmt.setNull(10, Types.VARCHAR);
            }
            stmt.setBoolean(11, item.isUseAutoPriority());

            // Set image path
            if (item.getImagePath() != null) {
                stmt.setString(12, item.getImagePath());
            } else {
                stmt.setNull(12, Types.VARCHAR);
            }

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    item.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
        }

        return false;
    }

    /**
     * Update a product
     */
    public boolean updateProduct(AbstractItem item) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, quantity = ?, " +
                "category_id = ?, supplier_id = ?, type = ?, expiry_date = ?, warranty_period = ?, " +
                "manual_priority = ?, use_auto_priority = ?, image_path = ? " +
                "WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getDescription());
            stmt.setBigDecimal(3, item.getPrice());
            stmt.setInt(4, item.getQuantity());
            stmt.setInt(5, item.getCategoryId());
            stmt.setInt(6, item.getSupplierId());
            stmt.setString(7, item.getType());

            // Set type-specific fields
            if (item instanceof PerishableItem) {
                PerishableItem perishable = (PerishableItem) item;
                if (perishable.getExpiryDate() != null) {
                    stmt.setDate(8, Date.valueOf(perishable.getExpiryDate()));
                } else {
                    stmt.setNull(8, Types.DATE);
                }
                stmt.setNull(9, Types.INTEGER);
            } else if (item instanceof DurableItem) {
                DurableItem durable = (DurableItem) item;
                stmt.setNull(8, Types.DATE);
                stmt.setInt(9, durable.getWarrantyPeriod());
            }

            // Set priority toggle fields
            if (item.getManualPriority() != null) {
                stmt.setString(10, item.getManualPriority());
            } else {
                stmt.setNull(10, Types.VARCHAR);
            }
            stmt.setBoolean(11, item.isUseAutoPriority());

            // Set image path
            if (item.getImagePath() != null) {
                stmt.setString(12, item.getImagePath());
            } else {
                stmt.setNull(12, Types.VARCHAR);
            }

            stmt.setInt(13, item.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete a product
     */
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get total count of all products
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) as count FROM products";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error getting product count: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Get total stock value (sum of price * quantity for all products)
     */
    public BigDecimal getTotalStockValue() {
        String sql = "SELECT SUM(price * quantity) as total_value FROM products";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                BigDecimal value = rs.getBigDecimal("total_value");
                return value != null ? value : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.err.println("Error getting total stock value: " + e.getMessage());
        }

        return BigDecimal.ZERO;
    }

    /**
     * Get low stock products (quantity < 10)
     */
    public List<AbstractItem> getLowStockProducts() {
        List<AbstractItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.quantity < 10 " +
                "ORDER BY p.quantity ASC";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting low stock products: " + e.getMessage());
        }

        return products;
    }

    /**
     * Get expiring soon products (perishables expiring within 7 days)
     */
    public List<PerishableItem> getExpiringSoonProducts() {
        List<PerishableItem> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, s.company_name as supplier_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.id " +
                "WHERE p.type = 'PERISHABLE' AND p.expiry_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) " +
                "ORDER BY p.expiry_date ASC";

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                products.add((PerishableItem) extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting expiring products: " + e.getMessage());
        }

        return products;
    }

    /**
     * Helper method to extract Product from ResultSet
     * Creates the correct subclass based on 'type' field (POLYMORPHISM)
     */
    private AbstractItem extractProduct(ResultSet rs) throws SQLException {
        String type = rs.getString("type");
        AbstractItem item;

        if ("PERISHABLE".equals(type)) {
            PerishableItem perishable = new PerishableItem();
            Date expiryDate = rs.getDate("expiry_date");
            if (expiryDate != null) {
                perishable.setExpiryDate(expiryDate.toLocalDate());
            }
            item = perishable;
        } else {
            DurableItem durable = new DurableItem();
            durable.setWarrantyPeriod(rs.getInt("warranty_period"));
            item = durable;
        }

        // Set common fields
        item.setId(rs.getInt("id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setSupplierId(rs.getInt("supplier_id"));
        item.setCategoryName(rs.getString("category_name"));
        item.setSupplierName(rs.getString("supplier_name"));

        // Set priority toggle fields (with null safety for older databases)
        try {
            item.setManualPriority(rs.getString("manual_priority"));
            item.setUseAutoPriority(rs.getBoolean("use_auto_priority"));
            item.setImagePath(rs.getString("image_path"));
        } catch (SQLException e) {
            // Columns may not exist - use defaults
            item.setUseAutoPriority(true);
        }

        return item;
    }
}
