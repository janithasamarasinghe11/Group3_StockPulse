package com.stockpulse.controller;

import com.stockpulse.dao.CategoryDAO;
import com.stockpulse.model.Category;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Category Controller
 * Handles Category CRUD operations (4th major functionality)
 */
public class CategoryController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                deleteCategory(request, response);
            } else if ("edit".equals(action)) {
                editCategory(request, response);
            } else {
                listCategories(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            try { listCategories(request, response); } catch (Exception ex) { throw new ServletException(ex); }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("update".equals(action)) {
                updateCategory(request, response);
            } else {
                createCategory(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            try { listCategories(request, response); } catch (Exception ex) { throw new ServletException(ex); }
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/categories.jsp").forward(request, response);
    }
    
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Category name is required");
            listCategories(request, response);
            return;
        }
        
        Category category = new Category();
        category.setName(name.trim());
        category.setDescription(description);
        
        CategoryDAO categoryDAO = new CategoryDAO();
        if (categoryDAO.createCategory(category)) {
            response.sendRedirect(request.getContextPath() + "/categories?message=Category created successfully&messageType=success");
        } else {
            request.setAttribute("error", "Failed to create category");
            listCategories(request, response);
        }
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Category name is required");
            listCategories(request, response);
            return;
        }
        
        Category category = new Category();
        category.setId(id);
        category.setName(name.trim());
        category.setDescription(description);
        
        CategoryDAO categoryDAO = new CategoryDAO();
        if (categoryDAO.updateCategory(category)) {
            response.sendRedirect(request.getContextPath() + "/categories?message=Category updated successfully&messageType=success");
        } else {
            request.setAttribute("error", "Failed to update category");
            listCategories(request, response);
        }
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        
        CategoryDAO categoryDAO = new CategoryDAO();
        if (categoryDAO.deleteCategory(id)) {
            response.sendRedirect(request.getContextPath() + "/categories?message=Category deleted successfully&messageType=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/categories?message=Failed to delete category&messageType=danger");
        }
    }
    
    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        
        CategoryDAO categoryDAO = new CategoryDAO();
        Category category = categoryDAO.getCategoryById(id);
        
        request.setAttribute("editCategory", category);
        listCategories(request, response);
    }
}
