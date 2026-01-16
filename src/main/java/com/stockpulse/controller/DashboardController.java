package com.stockpulse.controller;

import com.stockpulse.dao.CategoryDAO;
import com.stockpulse.dao.ProductDAO;
import com.stockpulse.dao.SupplierDAO;
import com.stockpulse.model.AbstractItem;
import com.stockpulse.model.PerishableItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Dashboard Controller
 * Displays inventory statistics and charts
 */
public class DashboardController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get dashboard statistics
            int totalProducts = productDAO.getTotalProductCount();
            BigDecimal totalStockValue = productDAO.getTotalStockValue();
            List<AbstractItem> lowStockProducts = productDAO.getLowStockProducts();
            List<PerishableItem> expiringProducts = productDAO.getExpiringSoonProducts();
            
            // Get data for Chart.js
            List<Object[]> stockByCategory = categoryDAO.getStockByCategory();
            
            // Build JSON for Chart.js
            StringBuilder categoryLabels = new StringBuilder("[");
            StringBuilder categoryData = new StringBuilder("[");
            for (int i = 0; i < stockByCategory.size(); i++) {
                Object[] row = stockByCategory.get(i);
                categoryLabels.append("\"").append(row[0]).append("\"");
                categoryData.append(row[1]);
                if (i < stockByCategory.size() - 1) {
                    categoryLabels.append(",");
                    categoryData.append(",");
                }
            }
            categoryLabels.append("]");
            categoryData.append("]");
            
            // Set attributes for JSP
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalStockValue", totalStockValue);
            request.setAttribute("lowStockProducts", lowStockProducts);
            request.setAttribute("lowStockCount", lowStockProducts.size());
            request.setAttribute("expiringProducts", expiringProducts);
            request.setAttribute("expiringCount", expiringProducts.size());
            request.setAttribute("categoryLabels", categoryLabels.toString());
            request.setAttribute("categoryData", categoryData.toString());
            request.setAttribute("supplierCount", supplierDAO.getAllSuppliers().size());
            request.setAttribute("categoryCount", categoryDAO.getAllCategories().size());
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
