package com.stockpulse.controller;

import com.stockpulse.dao.CategoryDAO;
import com.stockpulse.dao.ProductDAO;
import com.stockpulse.dao.SupplierDAO;
import com.stockpulse.model.AbstractItem;
import com.stockpulse.model.Category;
import com.stockpulse.model.DurableItem;
import com.stockpulse.model.PerishableItem;
import com.stockpulse.model.Supplier;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * Inventory Controller
 * Handles all product CRUD operations
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class InventoryController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/products";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get categories and suppliers for dropdowns
            List<Category> categories = categoryDAO.getAllCategories();
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            
            if ("edit".equals(action)) {
                // Edit mode - get product by ID
                int id = Integer.parseInt(request.getParameter("id"));
                AbstractItem product = productDAO.getProductById(id);
                request.setAttribute("editProduct", product);
            } else if ("delete".equals(action)) {
                // Delete product
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = productDAO.deleteProduct(id);
                request.setAttribute("message", success ? "Product deleted successfully" : "Failed to delete product");
                request.setAttribute("messageType", success ? "success" : "danger");
            }
            
            // Get products (with optional search/filter)
            String search = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String supplierFilter = request.getParameter("supplier");
            
            List<AbstractItem> products;
            
            if (search != null && !search.trim().isEmpty()) {
                products = productDAO.searchProducts(search.trim());
            } else if (categoryFilter != null && !categoryFilter.isEmpty()) {
                products = productDAO.getProductsByCategory(Integer.parseInt(categoryFilter));
            } else if (supplierFilter != null && !supplierFilter.isEmpty()) {
                products = productDAO.getProductsBySupplier(Integer.parseInt(supplierFilter));
            } else {
                products = productDAO.getAllProducts();
            }
            
            request.setAttribute("products", products);
            request.setAttribute("search", search);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("supplierFilter", supplierFilter);
            
            // Forward to inventory JSP
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            ProductDAO productDAO = new ProductDAO();
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String type = request.getParameter("type");
            
            // Validate
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Price must be greater than zero");
                doGet(request, response);
                return;
            }
            if (quantity < 0) {
                request.setAttribute("error", "Quantity cannot be negative");
                doGet(request, response);
                return;
            }
            
            AbstractItem product;
            
            // Create the appropriate product type (POLYMORPHISM)
            if ("PERISHABLE".equals(type)) {
                PerishableItem perishable = new PerishableItem();
                String expiryDateStr = request.getParameter("expiryDate");
                if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                    perishable.setExpiryDate(LocalDate.parse(expiryDateStr));
                }
                product = perishable;
            } else {
                DurableItem durable = new DurableItem();
                String warrantyStr = request.getParameter("warrantyPeriod");
                if (warrantyStr != null && !warrantyStr.isEmpty()) {
                    durable.setWarrantyPeriod(Integer.parseInt(warrantyStr));
                }
                product = durable;
            }
            
            // Set common fields
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setCategoryId(categoryId);
            product.setSupplierId(supplierId);
            
            // Handle priority toggle
            String useAutoPriorityStr = request.getParameter("useAutoPriority");
            boolean useAutoPriority = "on".equals(useAutoPriorityStr) || useAutoPriorityStr != null;
            product.setUseAutoPriority(useAutoPriority);
            
            if (!useAutoPriority) {
                String manualPriority = request.getParameter("manualPriority");
                if (manualPriority != null && !manualPriority.isEmpty()) {
                    product.setManualPriority(manualPriority);
                }
            }
            
            // Handle image upload
            String imagePath = null;
            try {
                Part filePart = request.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    // Validate file type
                    String contentType = filePart.getContentType();
                    if (contentType != null && (contentType.startsWith("image/") || contentType.equals("image/svg+xml"))) {
                        // Get original filename and extension
                        String originalFileName = getFileName(filePart);
                        String extension = "";
                        int dotIndex = originalFileName.lastIndexOf('.');
                        if (dotIndex > 0) {
                            extension = originalFileName.substring(dotIndex).toLowerCase();
                        }
                        
                        // Validate extension
                        if (extension.equals(".svg") || extension.equals(".png") || 
                            extension.equals(".jpg") || extension.equals(".jpeg") || extension.equals(".webp")) {
                            
                            // Generate unique filename
                            String newFileName = UUID.randomUUID().toString() + extension;
                            
                            // Create upload directory if it doesn't exist
                            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            
                            // Save the file
                            Path filePath = Paths.get(uploadPath, newFileName);
                            try (InputStream input = filePart.getInputStream()) {
                                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                            }
                            
                            imagePath = UPLOAD_DIR + "/" + newFileName;
                        }
                    }
                }
            } catch (Exception e) {
                // Log error but continue without image
                System.err.println("Error uploading image: " + e.getMessage());
            }
            
            // Set image path (either new, removed, or existing)
            String removeImage = request.getParameter("removeImage");
            
            if (imagePath != null) {
                // New image uploaded
                product.setImagePath(imagePath);
            } else if ("true".equals(removeImage)) {
                // Image explicitly removed
                product.setImagePath(null);
            } else if ("update".equals(action)) {
                // Preserve existing image path when editing
                String existingImagePath = request.getParameter("existingImagePath");
                if (existingImagePath != null && !existingImagePath.isEmpty()) {
                    product.setImagePath(existingImagePath);
                }
            }
            
            boolean success;
            String message;
            
            if ("update".equals(action)) {
                // Update existing product
                int id = Integer.parseInt(request.getParameter("id"));
                product.setId(id);
                success = productDAO.updateProduct(product);
                message = success ? "Product updated successfully" : "Failed to update product";
            } else {
                // Add new product
                success = productDAO.createProduct(product);
                message = success ? "Product added successfully" : "Failed to add product";
            }
            
            // Redirect to prevent form resubmission
            response.sendRedirect(request.getContextPath() + "/inventory?message=" + 
                                  java.net.URLEncoder.encode(message, "UTF-8") + 
                                  "&messageType=" + (success ? "success" : "danger"));
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Extract filename from Part header
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}
