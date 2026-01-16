-- StockPulse Database Schema
-- Run this script in phpMyAdmin to create all tables

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS users;

-- Users table for authentication
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'STAFF') NOT NULL DEFAULT 'STAFF',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers table
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Products table with support for Perishable and Durable items
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    category_id INT,
    supplier_id INT,
    type ENUM('PERISHABLE', 'DURABLE') NOT NULL,
    expiry_date DATE NULL,           -- Only for PERISHABLE items
    warranty_period INT NULL,         -- Only for DURABLE items (in months)
    manual_priority ENUM('HIGH', 'MEDIUM', 'LOW') NULL,  -- Manual priority override
    use_auto_priority BOOLEAN DEFAULT TRUE,              -- Toggle auto/manual priority
    image_path VARCHAR(255) NULL,                        -- Product image path
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

-- Insert default admin user (password: admin123)
-- BCrypt hash verified with BCrypt.checkpw() 
INSERT INTO users (username, password_hash, full_name, role) VALUES 
('admin', '$2a$10$xOuAYBU3tQzsqMlB74M2C.ZLzC140ThePQhLZNKXWW.BCQdwP5us.', 'System Administrator', 'ADMIN'),
('staff', '$2a$10$xOuAYBU3tQzsqMlB74M2C.ZLzC140ThePQhLZNKXWW.BCQdwP5us.', 'Staff Member', 'STAFF');

-- Insert sample categories
INSERT INTO categories (name, description) VALUES 
('Electronics', 'Electronic devices and accessories'),
('Groceries', 'Food and household items'),
('Furniture', 'Home and office furniture'),
('Clothing', 'Apparel and accessories'),
('Tools', 'Hardware and tools');

-- Insert sample suppliers
INSERT INTO suppliers (company_name, contact_email, phone, address) VALUES 
('TechCorp Ltd', 'sales@techcorp.com', '+1-555-0101', '123 Tech Street, Silicon Valley'),
('Fresh Foods Inc', 'orders@freshfoods.com', '+1-555-0102', '456 Farm Road, Countryside'),
('Global Supplies', 'info@globalsupplies.com', '+1-555-0103', '789 Commerce Ave, Metro City');

-- Insert sample products
INSERT INTO products (name, description, price, quantity, category_id, supplier_id, type, expiry_date, warranty_period) VALUES 
('Laptop Pro 15', 'High-performance laptop with 16GB RAM', 1299.99, 25, 1, 1, 'DURABLE', NULL, 24),
('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 150, 1, 1, 'DURABLE', NULL, 12),
('Organic Milk 1L', 'Fresh organic whole milk', 4.99, 50, 2, 2, 'PERISHABLE', DATE_ADD(CURDATE(), INTERVAL 5 DAY), NULL),
('Fresh Bread', 'Whole wheat bread loaf', 3.49, 30, 2, 2, 'PERISHABLE', DATE_ADD(CURDATE(), INTERVAL 3 DAY), NULL),
('Office Chair', 'Ergonomic office chair with lumbar support', 249.99, 8, 3, 3, 'DURABLE', NULL, 36),
('Desk Lamp', 'LED desk lamp with adjustable brightness', 45.99, 3, 3, 3, 'DURABLE', NULL, 18),
('Yogurt Pack', 'Greek yogurt 6-pack', 8.99, 40, 2, 2, 'PERISHABLE', DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL),
('Smartphone X', 'Latest smartphone with 128GB storage', 899.99, 4, 1, 1, 'DURABLE', NULL, 12);
