<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error - StockPulse</title>

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
            <div class="login-card text-center">
                <div class="login-logo">
                    <i class="bi bi-exclamation-triangle text-warning" style="font-size: 5rem;"></i>
                    <h1>Oops!</h1>
                    <p>Something went wrong</p>
                </div>

                <div class="alert alert-custom warning mb-4">
                    <i class="bi bi-info-circle-fill"></i>
                    <span>
                        <% Integer statusCode=(Integer) request.getAttribute("javax.servlet.error.status_code"); if
                            (statusCode !=null) { if (statusCode==404) { out.print("The page you're looking for doesn't
                            exist."); } else if (statusCode==500) { out.print("Internal server error. Please try again
                            later."); } else { out.print("Error " + statusCode + " occurred."); } } else { out.print("An
                            unexpected error occurred."); } %>
                    </span>
                </div>

                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary-custom">
                        <i class="bi bi-house me-2"></i>Go to Dashboard
                    </a>
                    <a href="javascript:history.back()" class="btn btn-outline-custom">
                        <i class="bi bi-arrow-left me-2"></i>Go Back
                    </a>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>