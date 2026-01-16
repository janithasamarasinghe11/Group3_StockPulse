package com.stockpulse.controller;

import com.stockpulse.dao.ProductDAO;
import com.stockpulse.dao.SupplierDAO;
import com.stockpulse.model.AbstractItem;
import com.stockpulse.model.Supplier;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Supplier Controller
 * Handles supplier listing and product linkage
 */
public class SupplierController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            SupplierDAO supplierDAO = new SupplierDAO();
            ProductDAO productDAO = new ProductDAO();
            
            if ("view".equals(action)) {
                // View supplier details and their products
                int id = Integer.parseInt(request.getParameter("id"));
                Supplier supplier = supplierDAO.getSupplierById(id);
                List<AbstractItem> products = productDAO.getProductsBySupplier(id);
                
                request.setAttribute("selectedSupplier", supplier);
                request.setAttribute("supplierProducts", products);
            } else if ("delete".equals(action)) {
                // Delete supplier
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = supplierDAO.deleteSupplier(id);
                request.setAttribute("message", success ? "Supplier deleted successfully" : "Failed to delete supplier");
                request.setAttribute("messageType", success ? "success" : "danger");
            }
            
            // Get all suppliers
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();
            request.setAttribute("suppliers", suppliers);
            
            // Forward to suppliers JSP
            request.getRequestDispatcher("/suppliers.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/suppliers.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get form data
            String companyName = request.getParameter("companyName");
            String contactEmail = request.getParameter("contactEmail");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            Supplier supplier = new Supplier();
            supplier.setCompanyName(companyName);
            supplier.setContactEmail(contactEmail);
            supplier.setPhone(phone);
            supplier.setAddress(address);
            
            boolean success;
            String message;
            
            if ("update".equals(action)) {
                // Update existing supplier
                int id = Integer.parseInt(request.getParameter("id"));
                supplier.setId(id);
                success = supplierDAO.updateSupplier(supplier);
                message = success ? "Supplier updated successfully" : "Failed to update supplier";
            } else {
                // Add new supplier
                success = supplierDAO.createSupplier(supplier);
                message = success ? "Supplier added successfully" : "Failed to add supplier";
            }
            
            // Redirect to prevent form resubmission
            response.sendRedirect(request.getContextPath() + "/suppliers?message=" + 
                                  java.net.URLEncoder.encode(message, "UTF-8") + 
                                  "&messageType=" + (success ? "success" : "danger"));
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
