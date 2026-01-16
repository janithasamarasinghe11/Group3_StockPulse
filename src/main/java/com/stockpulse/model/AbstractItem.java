package com.stockpulse.model;

import java.math.BigDecimal;

/**
 * Abstract base class for inventory items.
 * Demonstrates ABSTRACTION - defines common properties and 
 * abstract method for polymorphic behavior.
 * 
 * All fields are PRIVATE with PUBLIC getters/setters (ENCAPSULATION).
 */
public abstract class AbstractItem {
    
    // Private fields for encapsulation
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private int quantity;
    private int categoryId;
    private int supplierId;
    private String categoryName;
    private String supplierName;
    
    // Priority toggle fields
    private String manualPriority;     // "HIGH", "MEDIUM", "LOW" or null
    private boolean useAutoPriority = true;  // Toggle for auto/manual
    private String imagePath;          // Product image path
    
    // Default constructor
    public AbstractItem() {}
    
    // Parameterized constructor
    public AbstractItem(int id, String name, String description, BigDecimal price, 
                        int quantity, int categoryId, int supplierId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.supplierId = supplierId;
    }
    
    /**
     * ABSTRACT METHOD - Must be implemented by subclasses.
     * Demonstrates POLYMORPHISM - each subclass calculates priority differently.
     * @return Priority level: "HIGH", "MEDIUM", or "LOW"
     */
    public abstract String calculateRestockPriority();
    
    /**
     * Abstract method to get the item type.
     * @return "PERISHABLE" or "DURABLE"
     */
    public abstract String getType();
    
    /**
     * Calculate total value of this item in stock
     * @return price * quantity
     */
    public BigDecimal getTotalValue() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }
    
    /**
     * Get effective priority - respects the auto/manual toggle
     * If useAutoPriority is true, uses calculated priority
     * If false, uses manualPriority (falls back to calculated if null)
     */
    public String getEffectivePriority() {
        if (useAutoPriority) {
            return calculateRestockPriority();
        } else {
            return manualPriority != null ? manualPriority : calculateRestockPriority();
        }
    }
    
    // ============= GETTERS & SETTERS (Encapsulation) =============
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        if (price != null && price.compareTo(BigDecimal.ZERO) > 0) {
            this.price = price;
        } else {
            throw new IllegalArgumentException("Price must be greater than zero");
        }
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        if (quantity >= 0) {
            this.quantity = quantity;
        } else {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public int getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getSupplierName() {
        return supplierName;
    }
    
    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }
    
    public String getManualPriority() {
        return manualPriority;
    }
    
    public void setManualPriority(String manualPriority) {
        this.manualPriority = manualPriority;
    }
    
    public boolean isUseAutoPriority() {
        return useAutoPriority;
    }
    
    public void setUseAutoPriority(boolean useAutoPriority) {
        this.useAutoPriority = useAutoPriority;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    @Override
    public String toString() {
        return "Item{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", type=" + getType() +
                '}';
    }
}
