package com.stockpulse.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * PerishableItem - Represents items with an expiry date.
 * Demonstrates INHERITANCE - extends AbstractItem.
 * Demonstrates POLYMORPHISM - implements calculateRestockPriority() differently.
 * 
 * Examples: Food items, medicines, dairy products
 */
public class PerishableItem extends AbstractItem {
    
    // Additional field specific to perishable items
    private LocalDate expiryDate;
    
    // Default constructor
    public PerishableItem() {
        super();
    }
    
    // Full constructor
    public PerishableItem(int id, String name, String description, BigDecimal price,
                          int quantity, int categoryId, int supplierId, LocalDate expiryDate) {
        super(id, name, description, price, quantity, categoryId, supplierId);
        this.expiryDate = expiryDate;
    }
    
    /**
     * POLYMORPHIC IMPLEMENTATION
     * For perishable items, priority is based on expiry date:
     * - HIGH: Expires within 7 days
     * - MEDIUM: Expires within 14 days
     * - LOW: Expires after 14 days
     */
    @Override
    public String calculateRestockPriority() {
        if (expiryDate == null) {
            return "LOW";
        }
        
        LocalDate today = LocalDate.now();
        long daysUntilExpiry = ChronoUnit.DAYS.between(today, expiryDate);
        
        if (daysUntilExpiry < 0) {
            return "EXPIRED";  // Already expired!
        } else if (daysUntilExpiry <= 7) {
            return "HIGH";     // Expires within a week
        } else if (daysUntilExpiry <= 14) {
            return "MEDIUM";   // Expires within two weeks
        } else {
            return "LOW";      // Still fresh
        }
    }
    
    @Override
    public String getType() {
        return "PERISHABLE";
    }
    
    /**
     * Check if the item is expired
     */
    public boolean isExpired() {
        return expiryDate != null && expiryDate.isBefore(LocalDate.now());
    }
    
    /**
     * Get days until expiry
     */
    public long getDaysUntilExpiry() {
        if (expiryDate == null) {
            return Long.MAX_VALUE;
        }
        return ChronoUnit.DAYS.between(LocalDate.now(), expiryDate);
    }
    
    // Getter and Setter for expiryDate
    public LocalDate getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    @Override
    public String toString() {
        return "PerishableItem{" +
                "id=" + getId() +
                ", name='" + getName() + '\'' +
                ", price=" + getPrice() +
                ", quantity=" + getQuantity() +
                ", expiryDate=" + expiryDate +
                ", priority=" + calculateRestockPriority() +
                '}';
    }
}
