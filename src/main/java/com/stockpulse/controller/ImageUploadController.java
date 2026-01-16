package com.stockpulse.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Image Upload Controller
 * Handles product image uploads with multipart form data
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class ImageUploadController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/products";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Get the file part from the request
            Part filePart = request.getPart("image");
            
            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().write("{\"success\": false, \"error\": \"No file uploaded\"}");
                return;
            }
            
            // Validate file type
            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                response.getWriter().write("{\"success\": false, \"error\": \"Only image files are allowed\"}");
                return;
            }
            
            // Get original filename and extension
            String originalFileName = getFileName(filePart);
            String extension = "";
            int dotIndex = originalFileName.lastIndexOf('.');
            if (dotIndex > 0) {
                extension = originalFileName.substring(dotIndex);
            }
            
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
            
            // Return the relative path for storing in database
            String relativePath = UPLOAD_DIR + "/" + newFileName;
            
            response.getWriter().write("{\"success\": true, \"path\": \"" + relativePath + "\", \"filename\": \"" + newFileName + "\"}");
            
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
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
