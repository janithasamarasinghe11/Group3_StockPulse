<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Suppliers - StockPulse</title>
                <meta name="description" content="StockPulse Supplier Directory - Manage your suppliers">

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
                                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                        <i class="bi bi-speedometer2"></i>Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/inventory">
                                        <i class="bi bi-box-seam"></i>Inventory
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/suppliers">
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
                    <div class="page-header d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="bi bi-truck me-2"></i>Supplier Directory</h1>
                            <p>Manage your suppliers and view their products.</p>
                        </div>
                        <button class="btn btn-primary-custom" data-bs-toggle="modal"
                            data-bs-target="#addSupplierModal">
                            <i class="bi bi-plus-lg me-2"></i>Add Supplier
                        </button>
                    </div>

                    <!-- Success/Error Messages -->
                    <c:if test="${not empty param.message}">
                        <div class="alert alert-custom ${param.messageType} mb-4">
                            <i
                                class="bi bi-${param.messageType == 'success' ? 'check-circle' : 'exclamation-circle'}-fill"></i>
                            <span>${param.message}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-custom ${messageType} mb-4">
                            <i
                                class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}-fill"></i>
                            <span>${message}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-custom danger mb-4">
                            <i class="bi bi-exclamation-circle-fill"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <div class="row">
                        <!-- Suppliers List -->
                        <div class="col-lg-5 mb-4">
                            <div class="content-card">
                                <div class="card-header-custom">
                                    <h5><i class="bi bi-building me-2"></i>Suppliers (${suppliers.size()})</h5>
                                </div>
                                <div class="card-body-custom">
                                    <c:choose>
                                        <c:when test="${empty suppliers}">
                                            <div class="empty-state">
                                                <i class="bi bi-building"></i>
                                                <h4>No Suppliers Yet</h4>
                                                <p>Add your first supplier to get started.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="d-flex flex-column gap-3">
                                                <c:forEach items="${suppliers}" var="supplier">
                                                    <div class="supplier-card ${selectedSupplier.id == supplier.id ? 'active' : ''}"
                                                        onclick="window.location.href='${pageContext.request.contextPath}/suppliers?action=view&id=${supplier.id}'">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <h5><i
                                                                        class="bi bi-building me-2"></i>${supplier.companyName}
                                                                </h5>
                                                                <p><i
                                                                        class="bi bi-envelope me-1"></i>${supplier.contactEmail}
                                                                </p>
                                                                <p><i class="bi bi-telephone me-1"></i>${supplier.phone}
                                                                </p>
                                                            </div>
                                                            <div>
                                                                <button class="btn-action edit" data-id="${supplier.id}"
                                                                    data-company="${supplier.companyName}"
                                                                    data-email="${supplier.contactEmail}"
                                                                    data-phone="${supplier.phone}"
                                                                    data-address="${supplier.address}"
                                                                    onclick="event.stopPropagation(); editSupplierFromData(this)"
                                                                    title="Edit">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <span class="product-count">
                                                            <i class="bi bi-box-seam me-1"></i>${supplier.productCount}
                                                            Products
                                                        </span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Supplier Products -->
                        <div class="col-lg-7 mb-4">
                            <div class="content-card">
                                <div class="card-header-custom">
                                    <h5>
                                        <i class="bi bi-box-seam me-2"></i>
                                        <c:choose>
                                            <c:when test="${not empty selectedSupplier}">
                                                Products from ${selectedSupplier.companyName}
                                            </c:when>
                                            <c:otherwise>
                                                Select a Supplier
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                </div>
                                <div class="card-body-custom">
                                    <c:choose>
                                        <c:when test="${empty selectedSupplier}">
                                            <div class="empty-state">
                                                <i class="bi bi-arrow-left-circle"></i>
                                                <h4>Select a Supplier</h4>
                                                <p>Click on a supplier to view their products.</p>
                                            </div>
                                        </c:when>
                                        <c:when test="${empty supplierProducts}">
                                            <div class="empty-state">
                                                <i class="bi bi-inbox"></i>
                                                <h4>No Products</h4>
                                                <p>This supplier has no products yet.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-container">
                                                <table class="custom-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>Type</th>
                                                            <th>Price</th>
                                                            <th>Qty</th>
                                                            <th>Priority</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${supplierProducts}" var="product">
                                                            <tr>
                                                                <td>
                                                                    <strong>${product.name}</strong>
                                                                    <br><small
                                                                        class="text-muted">${product.categoryName}</small>
                                                                </td>
                                                                <td><span
                                                                        class="badge-type ${product.type.toLowerCase()}">${product.type}</span>
                                                                </td>
                                                                <td>$
                                                                    <fmt:formatNumber value="${product.price}"
                                                                        pattern="#,##0.00" />
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${product.quantity < 5}">
                                                                            <span
                                                                                class="text-danger fw-bold">${product.quantity}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span>${product.quantity}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td><span
                                                                        class="badge-priority ${product.calculateRestockPriority().toLowerCase()}">${product.calculateRestockPriority()}</span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Supplier Details -->
                                            <div class="mt-4 p-3 bg-light rounded-3">
                                                <h6 class="mb-2"><i class="bi bi-info-circle me-1"></i>Supplier Details
                                                </h6>
                                                <p class="mb-1"><strong>Email:</strong> ${selectedSupplier.contactEmail}
                                                </p>
                                                <p class="mb-1"><strong>Phone:</strong> ${selectedSupplier.phone}</p>
                                                <p class="mb-0"><strong>Address:</strong> ${selectedSupplier.address}
                                                </p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Supplier Modal -->
                <div class="modal fade" id="addSupplierModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add New Supplier</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/suppliers" method="POST">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label-custom">Company Name *</label>
                                        <input type="text" class="form-control form-control-custom" name="companyName"
                                            required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Contact Email</label>
                                        <input type="email" class="form-control form-control-custom"
                                            name="contactEmail">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Phone</label>
                                        <input type="text" class="form-control form-control-custom" name="phone">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Address</label>
                                        <textarea class="form-control form-control-custom" name="address"
                                            rows="2"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-custom"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="bi bi-check-lg me-1"></i>Add Supplier
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Edit Supplier Modal -->
                <div class="modal fade" id="editSupplierModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-pencil me-2"></i>Edit Supplier</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/suppliers" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" id="editId">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label-custom">Company Name *</label>
                                        <input type="text" class="form-control form-control-custom" name="companyName"
                                            id="editCompanyName" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Contact Email</label>
                                        <input type="email" class="form-control form-control-custom" name="contactEmail"
                                            id="editContactEmail">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Phone</label>
                                        <input type="text" class="form-control form-control-custom" name="phone"
                                            id="editPhone">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Address</label>
                                        <textarea class="form-control form-control-custom" name="address"
                                            id="editAddress" rows="2"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-custom"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="bi bi-check-lg me-1"></i>Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    function editSupplier(id, companyName, email, phone, address) {
                        document.getElementById('editId').value = id;
                        document.getElementById('editCompanyName').value = companyName;
                        document.getElementById('editContactEmail').value = email;
                        document.getElementById('editPhone').value = phone;
                        document.getElementById('editAddress').value = address;
                        new bootstrap.Modal(document.getElementById('editSupplierModal')).show();
                    }

                    function editSupplierFromData(button) {
                        var id = button.dataset.id;
                        var companyName = button.dataset.company;
                        var email = button.dataset.email;
                        var phone = button.dataset.phone;
                        var address = button.dataset.address;
                        editSupplier(id, companyName, email, phone, address);
                    }
                </script>

                <!-- Toast Notifications -->
                <script src="${pageContext.request.contextPath}/js/toast.js"></script>
            </body>

            </html>