package com.stockpulse.controller;

import com.stockpulse.dao.ProductDAO;
import com.stockpulse.dao.CategoryDAO;
import com.stockpulse.dao.SupplierDAO;
import com.stockpulse.model.AbstractItem;
import com.stockpulse.model.PerishableItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Report Controller
 * Handles report generation and CSV exports
 * This is the 3rd MAJOR FUNCTIONALITY for the project
 */
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "view";
        }

        try {
            switch (action) {
                case "exportLowStock":
                    exportLowStockCSV(request, response);
                    break;
                case "exportInventoryValue":
                    exportInventoryValueCSV(request, response);
                    break;
                case "exportExpiring":
                    exportExpiringCSV(request, response);
                    break;
                case "exportAll":
                    exportAllProductsCSV(request, response);
                    break;
                default:
                    showReports(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/reports.jsp").forward(request, response);
        }
    }

    /**
     * Show reports dashboard with all report data
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        List<AbstractItem> allProducts = productDAO.getAllProducts();
        // Categories and suppliers retrieved for potential future use
        categoryDAO.getAllCategories();
        supplierDAO.getAllSuppliers();

        // 1. Low Stock Report (quantity < 10)
        List<AbstractItem> lowStockItems = allProducts.stream()
                .filter(p -> p.getQuantity() < 10)
                .sorted((a, b) -> Integer.compare(a.getQuantity(), b.getQuantity()))
                .collect(Collectors.toList());

        // 2. Expiring Soon Report (within 14 days)
        List<AbstractItem> expiringItems = allProducts.stream()
                .filter(p -> p instanceof PerishableItem)
                .map(p -> (PerishableItem) p)
                .filter(p -> {
                    if (p.getExpiryDate() == null)
                        return false;
                    long days = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), p.getExpiryDate());
                    return days >= 0 && days <= 14;
                })
                .sorted((a, b) -> a.getExpiryDate().compareTo(b.getExpiryDate()))
                .collect(Collectors.toList());

        // 3. Inventory Value by Category
        Map<String, BigDecimal> valueByCategory = new HashMap<>();
        Map<String, Integer> countByCategory = new HashMap<>();
        for (AbstractItem item : allProducts) {
            String categoryName = item.getCategoryName() != null ? item.getCategoryName() : "Uncategorized";
            BigDecimal currentValue = valueByCategory.getOrDefault(categoryName, BigDecimal.ZERO);
            valueByCategory.put(categoryName, currentValue.add(item.getTotalValue()));
            countByCategory.put(categoryName, countByCategory.getOrDefault(categoryName, 0) + 1);
        }

        // 4. Inventory Value by Supplier
        Map<String, BigDecimal> valueBySupplier = new HashMap<>();
        Map<String, Integer> countBySupplier = new HashMap<>();
        for (AbstractItem item : allProducts) {
            String supplierName = item.getSupplierName() != null ? item.getSupplierName() : "No Supplier";
            BigDecimal currentValue = valueBySupplier.getOrDefault(supplierName, BigDecimal.ZERO);
            valueBySupplier.put(supplierName, currentValue.add(item.getTotalValue()));
            countBySupplier.put(supplierName, countBySupplier.getOrDefault(supplierName, 0) + 1);
        }

        // 5. Calculate totals
        BigDecimal totalInventoryValue = allProducts.stream()
                .map(AbstractItem::getTotalValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        int totalProducts = allProducts.size();
        int lowStockCount = lowStockItems.size();
        int expiringCount = expiringItems.size();

        // Set attributes
        request.setAttribute("lowStockItems", lowStockItems);
        request.setAttribute("expiringItems", expiringItems);
        request.setAttribute("valueByCategory", valueByCategory);
        request.setAttribute("countByCategory", countByCategory);
        request.setAttribute("valueBySupplier", valueBySupplier);
        request.setAttribute("countBySupplier", countBySupplier);
        request.setAttribute("totalInventoryValue", totalInventoryValue);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("expiringCount", expiringCount);
        request.setAttribute("allProducts", allProducts);

        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    /**
     * Export Low Stock items to CSV
     */
    private void exportLowStockCSV(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ProductDAO productDAO = new ProductDAO();
        List<AbstractItem> allProducts = productDAO.getAllProducts();

        List<AbstractItem> lowStockItems = allProducts.stream()
                .filter(p -> p.getQuantity() < 10)
                .sorted((a, b) -> Integer.compare(a.getQuantity(), b.getQuantity()))
                .collect(Collectors.toList());

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"low_stock_report.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("ID,Product Name,Type,Category,Supplier,Quantity,Price,Priority");

        for (AbstractItem item : lowStockItems) {
            writer.println(String.format("%d,\"%s\",%s,\"%s\",\"%s\",%d,%.2f,%s",
                    item.getId(),
                    escapeCsv(item.getName()),
                    item.getType(),
                    escapeCsv(item.getCategoryName()),
                    escapeCsv(item.getSupplierName()),
                    item.getQuantity(),
                    item.getPrice(),
                    item.calculateRestockPriority()));
        }

        writer.flush();
    }

    /**
     * Export Inventory Value by Category to CSV
     */
    private void exportInventoryValueCSV(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ProductDAO productDAO = new ProductDAO();
        List<AbstractItem> allProducts = productDAO.getAllProducts();

        // Calculate by category
        Map<String, BigDecimal> valueByCategory = new HashMap<>();
        Map<String, Integer> countByCategory = new HashMap<>();
        Map<String, Integer> quantityByCategory = new HashMap<>();

        for (AbstractItem item : allProducts) {
            String categoryName = item.getCategoryName() != null ? item.getCategoryName() : "Uncategorized";
            valueByCategory.put(categoryName,
                    valueByCategory.getOrDefault(categoryName, BigDecimal.ZERO).add(item.getTotalValue()));
            countByCategory.put(categoryName,
                    countByCategory.getOrDefault(categoryName, 0) + 1);
            quantityByCategory.put(categoryName,
                    quantityByCategory.getOrDefault(categoryName, 0) + item.getQuantity());
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"inventory_value_report.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("Category,Product Count,Total Quantity,Total Value");

        BigDecimal grandTotal = BigDecimal.ZERO;
        for (Map.Entry<String, BigDecimal> entry : valueByCategory.entrySet()) {
            writer.println(String.format("\"%s\",%d,%d,%.2f",
                    escapeCsv(entry.getKey()),
                    countByCategory.get(entry.getKey()),
                    quantityByCategory.get(entry.getKey()),
                    entry.getValue()));
            grandTotal = grandTotal.add(entry.getValue());
        }
        writer.println(String.format("\"TOTAL\",%d,%d,%.2f",
                allProducts.size(),
                allProducts.stream().mapToInt(AbstractItem::getQuantity).sum(),
                grandTotal));

        writer.flush();
    }

    /**
     * Export Expiring Soon items to CSV
     */
    private void exportExpiringCSV(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ProductDAO productDAO = new ProductDAO();
        List<AbstractItem> allProducts = productDAO.getAllProducts();

        List<PerishableItem> expiringItems = allProducts.stream()
                .filter(p -> p instanceof PerishableItem)
                .map(p -> (PerishableItem) p)
                .filter(p -> {
                    if (p.getExpiryDate() == null)
                        return false;
                    long days = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), p.getExpiryDate());
                    return days >= 0 && days <= 14;
                })
                .sorted((a, b) -> a.getExpiryDate().compareTo(b.getExpiryDate()))
                .collect(Collectors.toList());

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"expiring_items_report.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("ID,Product Name,Category,Supplier,Quantity,Price,Expiry Date,Days Until Expiry");

        for (PerishableItem item : expiringItems) {
            writer.println(String.format("%d,\"%s\",\"%s\",\"%s\",%d,%.2f,%s,%d",
                    item.getId(),
                    escapeCsv(item.getName()),
                    escapeCsv(item.getCategoryName()),
                    escapeCsv(item.getSupplierName()),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getExpiryDate(),
                    item.getDaysUntilExpiry()));
        }

        writer.flush();
    }

    /**
     * Export All Products to CSV
     */
    private void exportAllProductsCSV(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ProductDAO productDAO = new ProductDAO();
        List<AbstractItem> allProducts = productDAO.getAllProducts();

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"full_inventory_report.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("ID,Product Name,Description,Type,Category,Supplier,Quantity,Price,Total Value,Priority");

        for (AbstractItem item : allProducts) {
            writer.println(String.format("%d,\"%s\",\"%s\",%s,\"%s\",\"%s\",%d,%.2f,%.2f,%s",
                    item.getId(),
                    escapeCsv(item.getName()),
                    escapeCsv(item.getDescription()),
                    item.getType(),
                    escapeCsv(item.getCategoryName()),
                    escapeCsv(item.getSupplierName()),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getTotalValue(),
                    item.calculateRestockPriority()));
        }

        writer.flush();
    }

    /**
     * Escape CSV special characters
     */
    private String escapeCsv(String value) {
        if (value == null)
            return "";
        return value.replace("\"", "\"\"");
    }
}
