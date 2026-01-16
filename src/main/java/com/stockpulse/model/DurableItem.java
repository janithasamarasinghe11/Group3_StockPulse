package com.stockpulse.model;

import java.math.BigDecimal;

/**
 * DurableItem - Represents items with a warranty period.
 * Demonstrates INHERITANCE - extends AbstractItem.
 * Demonstrates POLYMORPHISM - implements calculateRestockPriority() differently.
 * 
 * Examples: Electronics, furniture, appliances
 */
public class DurableItem extends AbstractItem {
    
    // Additional field specific to durable items (warranty in months)
    private int warrantyPeriod;
    
    // Default constructor
    public DurableItem() {
        super();
    }
    
    // Full constructor
    public DurableItem(int id, String name, String description, BigDecimal price,
                       int quantity, int categoryId, int supplierId, int warrantyPeriod) {
        super(id, name, description, price, quantity, categoryId, supplierId);
        this.warrantyPeriod = warrantyPeriod;
    }
    
    /**
     * POLYMORPHIC IMPLEMENTATION
     * For durable items, priority is based on stock quantity:
     * - HIGH: Less than 5 items in stock
     * - MEDIUM: Between 5 and 15 items
     * - LOW: More than 15 items in stock
     */
    @Override
    public String calculateRestockPriority() {
        int quantity = getQuantity();
        
        if (quantity < 5) {
            return "HIGH";     // Very low stock - urgent restock needed
        } else if (quantity <= 15) {
            return "MEDIUM";   // Moderate stock
        } else {
            return "LOW";      // Sufficient stock
        }
    }
    
    @Override
    public String getType() {
        return "DURABLE";
    }
    
    /**
     * Check if item needs restocking
     */
    public boolean needsRestock() {
        return getQuantity() < 5;
    }
    
    /**
     * Get warranty description
     */
    public String getWarrantyDescription() {
        if (warrantyPeriod == 0) {
            return "No warranty";
        } else if (warrantyPeriod == 1) {
            return "1 month warranty";
        } else if (warrantyPeriod < 12) {
            return warrantyPeriod + " months warranty";
        } else if (warrantyPeriod == 12) {
            return "1 year warranty";
        } else {
            int years = warrantyPeriod / 12;
            int months = warrantyPeriod % 12;
            if (months == 0) {
                return years + " year" + (years > 1 ? "s" : "") + " warranty";
            } else {
                return years + " year" + (years > 1 ? "s" : "") + " " + months + " month" + (months > 1 ? "s" : "") + " warranty";
            }
        }
    }
    
    // Getter and Setter for warrantyPeriod
    public int getWarrantyPeriod() {
        return warrantyPeriod;
    }
    
    public void setWarrantyPeriod(int warrantyPeriod) {
        if (warrantyPeriod >= 0) {
            this.warrantyPeriod = warrantyPeriod;
        } else {
            throw new IllegalArgumentException("Warranty period cannot be negative");
        }
    }
    
    @Override
    public String toString() {
        return "DurableItem{" +
                "id=" + getId() +
                ", name='" + getName() + '\'' +
                ", price=" + getPrice() +
                ", quantity=" + getQuantity() +
                ", warrantyPeriod=" + warrantyPeriod + " months" +
                ", priority=" + calculateRestockPriority() +
                '}';
    }
}
