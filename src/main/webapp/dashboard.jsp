<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard - StockPulse</title>
                <meta name="description" content="StockPulse Dashboard - View inventory statistics and alerts">

                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Bootstrap Icons -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
                    rel="stylesheet">

                <!-- Custom CSS -->
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
            </head>

            <body>
                <!-- Navbar -->
                <nav class="navbar navbar-expand-lg">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-box-seam-fill"></i>
                            <span>StockPulse</span>
                        </a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item">
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                        <i class="bi bi-speedometer2"></i>Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/inventory">
                                        <i class="bi bi-box-seam"></i>Inventory
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/suppliers">
                                        <i class="bi bi-truck"></i>Suppliers
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/reports">
                                        <i class="bi bi-file-earmark-bar-graph"></i>Reports
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                                        <i class="bi bi-tags"></i>Categories
                                    </a>
                                </li>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/users">
                                            <i class="bi bi-people"></i>Users
                                        </a>
                                    </li>
                                </c:if>
                            </ul>

                            <div class="dropdown user-dropdown">
                                <button class="btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    ${sessionScope.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><span class="dropdown-item-text text-muted small">Logged in as
                                            ${sessionScope.role}</span></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item text-danger"
                                            href="${pageContext.request.contextPath}/logout">
                                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                                        </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Main Content -->
                <div class="dashboard-container fade-in">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1><i class="bi bi-speedometer2 me-2"></i>Dashboard</h1>
                        <p>Welcome back, ${sessionScope.fullName}! Here's your inventory overview.</p>
                    </div>

                    <!-- Error Alert -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-custom danger mb-4">
                            <i class="bi bi-exclamation-circle-fill"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon primary">
                                <i class="bi bi-box-seam"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${totalProducts}</h3>
                                <p>Total Products</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon success">
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                            <div class="stat-info">
                                <h3>$
                                    <fmt:formatNumber value="${totalStockValue}" pattern="#,##0.00" />
                                </h3>
                                <p>Total Stock Value</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon warning">
                                <i class="bi bi-exclamation-triangle"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${lowStockCount}</h3>
                                <p>Low Stock Alerts</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon danger">
                                <i class="bi bi-calendar-x"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${expiringCount}</h3>
                                <p>Expiring Soon</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon info">
                                <i class="bi bi-truck"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${supplierCount}</h3>
                                <p>Suppliers</p>
                            </div>
                        </div>
                    </div>

                    <!-- Charts and Alerts Row -->
                    <div class="row">
                        <!-- Stock by Category Chart -->
                        <div class="col-lg-7 mb-4">
                            <div class="content-card">
                                <div class="card-header-custom">
                                    <h5><i class="bi bi-bar-chart me-2"></i>Stock by Category</h5>
                                </div>
                                <div class="card-body-custom">
                                    <div class="chart-container">
                                        <canvas id="stockChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Low Stock Alerts -->
                        <div class="col-lg-5 mb-4">
                            <div class="content-card">
                                <div class="card-header-custom">
                                    <h5><i class="bi bi-exclamation-triangle text-warning me-2"></i>Low Stock Alerts
                                    </h5>
                                    <a href="${pageContext.request.contextPath}/inventory"
                                        class="btn btn-sm btn-outline-custom">View All</a>
                                </div>
                                <div class="card-body-custom">
                                    <c:choose>
                                        <c:when test="${empty lowStockProducts}">
                                            <div class="empty-state">
                                                <i class="bi bi-check-circle"></i>
                                                <h4>All Good!</h4>
                                                <p>No low stock alerts at the moment.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-container">
                                                <table class="custom-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>Qty</th>
                                                            <th>Priority</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${lowStockProducts}" var="product" begin="0"
                                                            end="4">
                                                            <tr>
                                                                <td>
                                                                    <strong>${product.name}</strong>
                                                                    <span
                                                                        class="badge-type ${product.type.toLowerCase()}">${product.type}</span>
                                                                </td>
                                                                <td><strong>${product.quantity}</strong></td>
                                                                <td><span
                                                                        class="badge-priority ${product.calculateRestockPriority().toLowerCase()}">${product.calculateRestockPriority()}</span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Expiring Soon -->
                    <c:if test="${not empty expiringProducts}">
                        <div class="content-card">
                            <div class="card-header-custom">
                                <h5><i class="bi bi-calendar-x text-danger me-2"></i>Expiring Soon (Within 7 Days)</h5>
                            </div>
                            <div class="card-body-custom">
                                <div class="table-container">
                                    <table class="custom-table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Category</th>
                                                <th>Quantity</th>
                                                <th>Expiry Date</th>
                                                <th>Days Left</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${expiringProducts}" var="product">
                                                <tr>
                                                    <td><strong>${product.name}</strong></td>
                                                    <td>${product.categoryName}</td>
                                                    <td>${product.quantity}</td>
                                                    <td>${product.expiryDate}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.daysUntilExpiry < 0}">
                                                                <span class="badge-priority high">EXPIRED</span>
                                                            </c:when>
                                                            <c:when test="${product.daysUntilExpiry <= 3}">
                                                                <span
                                                                    class="badge-priority high">${product.daysUntilExpiry}
                                                                    days</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge-priority medium">${product.daysUntilExpiry}
                                                                    days</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

                <!-- Chart.js -->
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

                <!-- Chart Initialization -->
                <script>
                    // Stock by Category Chart
                    var categoryLabels = JSON.parse('${categoryLabels}');
                    var categoryData = JSON.parse('${categoryData}');

                    var ctx = document.getElementById('stockChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: categoryLabels,
                            datasets: [{
                                label: 'Stock Quantity',
                                data: categoryData,
                                backgroundColor: [
                                    'rgba(37, 99, 235, 0.8)',
                                    'rgba(16, 185, 129, 0.8)',
                                    'rgba(245, 158, 11, 0.8)',
                                    'rgba(239, 68, 68, 0.8)',
                                    'rgba(6, 182, 212, 0.8)',
                                    'rgba(168, 85, 247, 0.8)'
                                ],
                                borderColor: [
                                    'rgba(37, 99, 235, 1)',
                                    'rgba(16, 185, 129, 1)',
                                    'rgba(245, 158, 11, 1)',
                                    'rgba(239, 68, 68, 1)',
                                    'rgba(6, 182, 212, 1)',
                                    'rgba(168, 85, 247, 1)'
                                ],
                                borderWidth: 2,
                                borderRadius: 8,
                                borderSkipped: false
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(0, 0, 0, 0.05)'
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    }
                                }
                            }
                        }
                    });
                </script>

                <!-- Toast Notifications -->
                <script src="${pageContext.request.contextPath}/js/toast.js"></script>
            </body>

            </html>