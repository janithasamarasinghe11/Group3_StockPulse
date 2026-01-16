<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Reports - StockPulse</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    .report-card {
                        background: var(--bg-card);
                        border-radius: var(--radius-lg);
                        box-shadow: var(--shadow-md);
                        transition: all var(--transition-normal);
                        border: 1px solid transparent;
                        overflow: hidden;
                    }

                    .report-card:hover {
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-lg);
                    }

                    .report-header {
                        background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%);
                        padding: 1.25rem 1.5rem;
                        border-bottom: 1px solid var(--bg-secondary);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .report-header h5 {
                        margin: 0;
                        font-weight: 600;
                        color: var(--text-primary);
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .report-body {
                        padding: 1.5rem;
                    }

                    .summary-stat {
                        text-align: center;
                        padding: 1.5rem;
                        background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%);
                        border-radius: var(--radius-lg);
                    }

                    .summary-stat h2 {
                        font-size: 2.5rem;
                        font-weight: 700;
                        margin: 0;
                        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                    }

                    .summary-stat p {
                        margin: 0.5rem 0 0;
                        color: var(--text-secondary);
                        font-weight: 500;
                    }

                    .nav-tabs-custom {
                        border: none;
                        background: var(--bg-secondary);
                        border-radius: var(--radius-lg);
                        padding: 0.5rem;
                        display: inline-flex;
                        gap: 0.5rem;
                    }

                    .nav-tabs-custom .nav-link {
                        border: none;
                        border-radius: var(--radius-md);
                        padding: 0.75rem 1.5rem;
                        color: var(--text-secondary);
                        font-weight: 500;
                        transition: all var(--transition-normal);
                    }

                    .nav-tabs-custom .nav-link:hover {
                        background: rgba(255, 255, 255, 0.5);
                        color: var(--text-primary);
                    }

                    .nav-tabs-custom .nav-link.active {
                        background: var(--bg-card);
                        color: var(--primary-color);
                        box-shadow: var(--shadow-sm);
                    }

                    .chart-wrapper {
                        position: relative;
                        height: 300px;
                    }

                    .export-btn {
                        background: linear-gradient(135deg, var(--success-color), #059669);
                        color: white;
                        border: none;
                        padding: 0.5rem 1rem;
                        border-radius: var(--radius-md);
                        font-weight: 500;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        text-decoration: none;
                        transition: all var(--transition-normal);
                    }

                    .export-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
                        color: white;
                    }

                    .priority-indicator {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.25rem;
                    }

                    .priority-indicator::before {
                        content: '';
                        width: 8px;
                        height: 8px;
                        border-radius: 50%;
                    }

                    .priority-indicator.high::before {
                        background: var(--danger-color);
                    }

                    .priority-indicator.medium::before {
                        background: var(--warning-color);
                    }

                    .priority-indicator.low::before {
                        background: var(--success-color);
                    }

                    .value-card {
                        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
                        color: white;
                        border-radius: var(--radius-lg);
                        padding: 1.5rem;
                    }

                    .value-card h3 {
                        font-size: 2rem;
                        font-weight: 700;
                        margin: 0;
                    }

                    .value-card p {
                        margin: 0.5rem 0 0;
                        opacity: 0.9;
                    }

                    .progress-bar-custom {
                        height: 8px;
                        border-radius: 4px;
                        background: var(--bg-secondary);
                        overflow: hidden;
                    }

                    .progress-bar-custom .fill {
                        height: 100%;
                        border-radius: 4px;
                        transition: width 0.5s ease;
                    }
                </style>
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
                                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                        <i class="bi bi-speedometer2"></i> Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/inventory">
                                        <i class="bi bi-box"></i> Inventory
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/suppliers">
                                        <i class="bi bi-truck"></i> Suppliers
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/reports">
                                        <i class="bi bi-file-earmark-bar-graph"></i> Reports
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                                        <i class="bi bi-tags"></i> Categories
                                    </a>
                                </li>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/users">
                                            <i class="bi bi-people"></i> Users
                                        </a>
                                    </li>
                                </c:if>
                            </ul>

                            <div class="dropdown user-dropdown">
                                <button class="btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-2"></i>${sessionScope.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><span class="dropdown-item-text text-muted">${sessionScope.role}</span></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i
                                                class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Main Content -->
                <div class="dashboard-container">
                    <!-- Page Header -->
                    <div class="page-header d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="bi bi-file-earmark-bar-graph me-2"></i>Reports</h1>
                            <p>Generate and export inventory reports</p>
                        </div>
                        <div class="dropdown">
                            <button class="export-btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-download"></i> Export CSV
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item"
                                        href="${pageContext.request.contextPath}/reports?action=exportAll">
                                        <i class="bi bi-table me-2"></i>Full Inventory
                                    </a></li>
                                <li><a class="dropdown-item"
                                        href="${pageContext.request.contextPath}/reports?action=exportLowStock">
                                        <i class="bi bi-exclamation-triangle me-2"></i>Low Stock Items
                                    </a></li>
                                <li><a class="dropdown-item"
                                        href="${pageContext.request.contextPath}/reports?action=exportInventoryValue">
                                        <i class="bi bi-currency-dollar me-2"></i>Inventory Value
                                    </a></li>
                                <li><a class="dropdown-item"
                                        href="${pageContext.request.contextPath}/reports?action=exportExpiring">
                                        <i class="bi bi-calendar-x me-2"></i>Expiring Items
                                    </a></li>
                            </ul>
                        </div>
                    </div>

                    <!-- Summary Stats -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="value-card">
                                <h3>
                                    <fmt:formatNumber value="${totalInventoryValue}" type="currency"
                                        currencySymbol="$" />
                                </h3>
                                <p><i class="bi bi-graph-up me-1"></i>Total Inventory Value</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat">
                                <h2>${totalProducts}</h2>
                                <p><i class="bi bi-box me-1"></i>Total Products</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat"
                                style="background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05));">
                                <h2
                                    style="background: linear-gradient(135deg, var(--danger-color), #dc2626); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">
                                    ${lowStockCount}</h2>
                                <p><i class="bi bi-exclamation-triangle me-1"></i>Low Stock Items</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="summary-stat"
                                style="background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(245, 158, 11, 0.05));">
                                <h2
                                    style="background: linear-gradient(135deg, var(--warning-color), #d97706); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">
                                    ${expiringCount}</h2>
                                <p><i class="bi bi-calendar-x me-1"></i>Expiring Soon</p>
                            </div>
                        </div>
                    </div>

                    <!-- Report Tabs -->
                    <ul class="nav nav-tabs-custom mb-4" id="reportTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="lowstock-tab" data-bs-toggle="tab"
                                data-bs-target="#lowstock" type="button">
                                <i class="bi bi-exclamation-circle me-1"></i>Low Stock
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="value-tab" data-bs-toggle="tab" data-bs-target="#value"
                                type="button">
                                <i class="bi bi-currency-dollar me-1"></i>Inventory Value
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="expiring-tab" data-bs-toggle="tab" data-bs-target="#expiring"
                                type="button">
                                <i class="bi bi-calendar-x me-1"></i>Expiring Soon
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="supplier-tab" data-bs-toggle="tab" data-bs-target="#supplier"
                                type="button">
                                <i class="bi bi-truck me-1"></i>By Supplier
                            </button>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content" id="reportTabsContent">
                        <!-- Low Stock Report -->
                        <div class="tab-pane fade show active" id="lowstock" role="tabpanel">
                            <div class="report-card">
                                <div class="report-header">
                                    <h5><i class="bi bi-exclamation-triangle text-danger"></i> Low Stock Report</h5>
                                    <a href="${pageContext.request.contextPath}/reports?action=exportLowStock"
                                        class="export-btn">
                                        <i class="bi bi-download"></i> Export
                                    </a>
                                </div>
                                <div class="report-body">
                                    <c:choose>
                                        <c:when test="${empty lowStockItems}">
                                            <div class="empty-state">
                                                <i class="bi bi-check-circle text-success"></i>
                                                <h4>All Stock Levels Good!</h4>
                                                <p>No products are running low on stock.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-container">
                                                <table class="custom-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>Type</th>
                                                            <th>Category</th>
                                                            <th>Supplier</th>
                                                            <th>Quantity</th>
                                                            <th>Price</th>
                                                            <th>Priority</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${lowStockItems}">
                                                            <tr>
                                                                <td>
                                                                    <strong>${item.name}</strong>
                                                                    <br><small
                                                                        class="text-muted">${item.description}</small>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge-type ${item.type == 'PERISHABLE' ? 'perishable' : 'durable'}">
                                                                        ${item.type}
                                                                    </span>
                                                                </td>
                                                                <td>${item.categoryName}</td>
                                                                <td>${item.supplierName}</td>
                                                                <td>
                                                                    <span
                                                                        class="fw-bold ${item.quantity < 5 ? 'text-danger' : 'text-warning'}">
                                                                        ${item.quantity}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${item.price}"
                                                                        type="currency" currencySymbol="$" />
                                                                </td>
                                                                <td>
                                                                    <c:set var="priority"
                                                                        value="${item.calculateRestockPriority()}" />
                                                                    <span
                                                                        class="badge-priority ${priority == 'HIGH' ? 'high' : (priority == 'MEDIUM' ? 'medium' : 'low')}">
                                                                        ${priority}
                                                                    </span>
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

                        <!-- Inventory Value Report -->
                        <div class="tab-pane fade" id="value" role="tabpanel">
                            <div class="row g-4">
                                <div class="col-lg-8">
                                    <div class="report-card">
                                        <div class="report-header">
                                            <h5><i class="bi bi-pie-chart text-primary"></i> Value by Category</h5>
                                            <a href="${pageContext.request.contextPath}/reports?action=exportInventoryValue"
                                                class="export-btn">
                                                <i class="bi bi-download"></i> Export
                                            </a>
                                        </div>
                                        <div class="report-body">
                                            <div class="chart-wrapper">
                                                <canvas id="categoryValueChart"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="report-card">
                                        <div class="report-header">
                                            <h5><i class="bi bi-list-task"></i> Category Breakdown</h5>
                                        </div>
                                        <div class="report-body">
                                            <c:forEach var="entry" items="${valueByCategory}">
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between mb-1">
                                                        <span class="fw-medium">${entry.key}</span>
                                                        <span class="text-muted">${countByCategory[entry.key]}
                                                            items</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="progress-bar-custom flex-grow-1 me-3">
                                                            <div class="fill"
                                                                style="width: ${(entry.value / totalInventoryValue * 100)}%; background: var(--primary-color);">
                                                            </div>
                                                        </div>
                                                        <span class="fw-bold">
                                                            <fmt:formatNumber value="${entry.value}" type="currency"
                                                                currencySymbol="$" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Expiring Soon Report -->
                        <div class="tab-pane fade" id="expiring" role="tabpanel">
                            <div class="report-card">
                                <div class="report-header">
                                    <h5><i class="bi bi-calendar-x text-warning"></i> Expiring Soon (Next 14 Days)</h5>
                                    <a href="${pageContext.request.contextPath}/reports?action=exportExpiring"
                                        class="export-btn">
                                        <i class="bi bi-download"></i> Export
                                    </a>
                                </div>
                                <div class="report-body">
                                    <c:choose>
                                        <c:when test="${empty expiringItems}">
                                            <div class="empty-state">
                                                <i class="bi bi-check-circle text-success"></i>
                                                <h4>No Items Expiring Soon!</h4>
                                                <p>All perishable items have expiry dates beyond 14 days.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-container">
                                                <table class="custom-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>Category</th>
                                                            <th>Supplier</th>
                                                            <th>Quantity</th>
                                                            <th>Expiry Date</th>
                                                            <th>Days Left</th>
                                                            <th>Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${expiringItems}">
                                                            <tr>
                                                                <td><strong>${item.name}</strong></td>
                                                                <td>${item.categoryName}</td>
                                                                <td>${item.supplierName}</td>
                                                                <td>${item.quantity}</td>
                                                                <td>${item.expiryDate}</td>
                                                                <td>
                                                                    <c:set var="daysLeft"
                                                                        value="${item.getDaysUntilExpiry()}" />
                                                                    <span
                                                                        class="fw-bold ${daysLeft <= 3 ? 'text-danger' : (daysLeft <= 7 ? 'text-warning' : 'text-info')}">
                                                                        ${daysLeft} days
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${daysLeft <= 3}">
                                                                            <span
                                                                                class="badge-priority high">URGENT</span>
                                                                        </c:when>
                                                                        <c:when test="${daysLeft <= 7}">
                                                                            <span
                                                                                class="badge-priority medium">WARNING</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge-priority low">OK</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
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

                        <!-- Supplier Value Report -->
                        <div class="tab-pane fade" id="supplier" role="tabpanel">
                            <div class="report-card">
                                <div class="report-header">
                                    <h5><i class="bi bi-truck text-info"></i> Inventory Value by Supplier</h5>
                                </div>
                                <div class="report-body">
                                    <div class="row g-4">
                                        <c:forEach var="entry" items="${valueBySupplier}">
                                            <div class="col-md-4">
                                                <div class="stat-card">
                                                    <div class="stat-icon info">
                                                        <i class="bi bi-building"></i>
                                                    </div>
                                                    <div class="stat-info">
                                                        <h3>
                                                            <fmt:formatNumber value="${entry.value}" type="currency"
                                                                currencySymbol="$" />
                                                        </h3>
                                                        <p>${entry.key}</p>
                                                        <small class="text-muted">${countBySupplier[entry.key]}
                                                            products</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Category Value Chart
                    document.addEventListener('DOMContentLoaded', function () {
                        var ctx = document.getElementById('categoryValueChart');
                        if (ctx) {
                            // Extract data from JSP
                            var categories = [];
                            var values = [];
                            var colors = [
                                'rgba(37, 99, 235, 0.8)',
                                'rgba(16, 185, 129, 0.8)',
                                'rgba(245, 158, 11, 0.8)',
                                'rgba(239, 68, 68, 0.8)',
                                'rgba(6, 182, 212, 0.8)',
                                'rgba(168, 85, 247, 0.8)'
                            ];

                            <c:forEach var="entry" items="${valueByCategory}" varStatus="status">
                                categories.push('${entry.key}');
                                values.push(${entry.value});
                            </c:forEach>

                            new Chart(ctx.getContext('2d'), {
                                type: 'doughnut',
                                data: {
                                    labels: categories,
                                    datasets: [{
                                        data: values,
                                        backgroundColor: colors,
                                        borderWidth: 2,
                                        borderColor: 'white'
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: {
                                                padding: 20,
                                                usePointStyle: true
                                            }
                                        }
                                    }
                                }
                            });
                        }
                    });
                </script>

                <!-- Toast Notifications -->
                <script src="${pageContext.request.contextPath}/js/toast.js"></script>
            </body>

            </html>