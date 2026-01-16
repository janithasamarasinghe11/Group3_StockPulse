package com.stockpulse.model;

import java.sql.Timestamp;

/**
 * Supplier model class.
 * Demonstrates ENCAPSULATION with private fields and public getters/setters.
 */
public class Supplier {
    
    private int id;
    private String companyName;
    private String contactEmail;
    private String phone;
    private String address;
    private Timestamp createdAt;
    private int productCount;  // For dashboard display
    
    // Default constructor
    public Supplier() {}
    
    // Full constructor
    public Supplier(int id, String companyName, String contactEmail, String phone, String address) {
        this.id = id;
        this.companyName = companyName;
        this.contactEmail = contactEmail;
        this.phone = phone;
        this.address = address;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getContactEmail() {
        return contactEmail;
    }
    
    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public int getProductCount() {
        return productCount;
    }
    
    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
    
    @Override
    public String toString() {
        return "Supplier{" +
                "id=" + id +
                ", companyName='" + companyName + '\'' +
                ", contactEmail='" + contactEmail + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
