-- Run this in phpMyAdmin to add new columns to existing database
-- Execute these ALTER statements to update the products table

ALTER TABLE products 
ADD COLUMN manual_priority ENUM('HIGH', 'MEDIUM', 'LOW') NULL AFTER warranty_period,
ADD COLUMN use_auto_priority BOOLEAN DEFAULT TRUE AFTER manual_priority,
ADD COLUMN image_path VARCHAR(255) NULL AFTER use_auto_priority;

-- Verify the changes
DESCRIBE products;
