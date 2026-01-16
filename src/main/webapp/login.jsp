<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - StockPulse</title>
    <meta name="description" content="StockPulse Inventory Management System - Secure Login">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <!-- Logo -->
            <div class="login-logo">
                <i class="bi bi-box-seam-fill"></i>
                <h1>StockPulse</h1>
                <p>Inventory Management System</p>
            </div>
            
            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="alert alert-custom danger fade-in mb-4">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            
            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label-custom">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0">
                            <i class="bi bi-person text-secondary"></i>
                        </span>
                        <input type="text" 
                               class="form-control form-control-custom border-start-0" 
                               id="username" 
                               name="username" 
                               placeholder="Enter your username"
                               value="${username}"
                               required>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="password" class="form-label-custom">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0">
                            <i class="bi bi-lock text-secondary"></i>
                        </span>
                        <input type="password" 
                               class="form-control form-control-custom border-start-0" 
                               id="password" 
                               name="password" 
                               placeholder="Enter your password"
                               required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary-custom w-100 py-2">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                </button>
            </form>
            
            <!-- Demo Credentials -->
            <div class="mt-4 p-3 bg-light rounded-3 text-center">
                <small class="text-secondary">
                    <strong>Demo Credentials:</strong><br>
                    Username: <code>admin</code> | Password: <code>admin123</code>
                </small>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
