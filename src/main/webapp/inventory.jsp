<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Inventory - StockPulse</title>
                <meta name="description" content="StockPulse Inventory Management - Manage your products">

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
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/inventory">
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
                    <div class="page-header d-flex justify-content-between align-items-center">
                        <div>
                            <h1><i class="bi bi-box-seam me-2"></i>Inventory</h1>
                            <p>Manage your products - Add, edit, or remove items from stock.</p>
                        </div>
                        <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addProductModal">
                            <i class="bi bi-plus-lg me-2"></i>Add Product
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

                    <!-- Search and Filter -->
                    <div class="content-card mb-4">
                        <div class="card-body-custom">
                            <form action="${pageContext.request.contextPath}/inventory" method="GET" class="row g-3">
                                <div class="col-md-4">
                                    <div class="search-input-group">
                                        <i class="bi bi-search"></i>
                                        <input type="text" class="form-control form-control-custom" name="search"
                                            placeholder="Search products..." value="${search}">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select form-control-custom" name="category">
                                        <option value="">All Categories</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}" ${categoryFilter==cat.id ? 'selected' : '' }>
                                                ${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select form-control-custom" name="supplier">
                                        <option value="">All Suppliers</option>
                                        <c:forEach items="${suppliers}" var="sup">
                                            <option value="${sup.id}" ${supplierFilter==sup.id ? 'selected' : '' }>
                                                ${sup.companyName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary-custom w-100">
                                        <i class="bi bi-funnel me-1"></i>Filter
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Products Table -->
                    <div class="content-card">
                        <div class="card-header-custom">
                            <h5><i class="bi bi-table me-2"></i>Products (${products.size()})</h5>
                        </div>
                        <div class="card-body-custom p-0">
                            <c:choose>
                                <c:when test="${empty products}">
                                    <div class="empty-state">
                                        <i class="bi bi-inbox"></i>
                                        <h4>No Products Found</h4>
                                        <p>Start by adding your first product.</p>
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
                                                    <th>Price</th>
                                                    <th>Qty</th>
                                                    <th>Supplier</th>
                                                    <th>Priority</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${products}" var="product">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center gap-3">
                                                                <c:choose>
                                                                    <c:when test="${not empty product.imagePath}">
                                                                        <img src="${pageContext.request.contextPath}/${product.imagePath}"
                                                                            alt="${product.name}"
                                                                            class="product-thumbnail"
                                                                            style="width:50px; height:50px; object-fit:cover; border-radius:8px; border:1px solid #e5e7eb;">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="product-thumbnail-placeholder"
                                                                            style="width:50px; height:50px; background:#f3f4f6; border-radius:8px; display:flex; align-items:center; justify-content:center; border:1px solid #e5e7eb;">
                                                                            <i class="bi bi-image text-muted"></i>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <div>
                                                                    <strong>${product.name}</strong>
                                                                    <c:if test="${not empty product.description}">
                                                                        <br><small
                                                                            class="text-muted">${product.description}</small>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><span
                                                                class="badge-type ${product.type.toLowerCase()}">${product.type}</span>
                                                        </td>
                                                        <td>${product.categoryName}</td>
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
                                                                <c:when test="${product.quantity < 15}">
                                                                    <span
                                                                        class="text-warning fw-bold">${product.quantity}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="fw-bold">${product.quantity}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>${product.supplierName}</td>
                                                        <td><span
                                                                class="badge-priority ${product.calculateRestockPriority().toLowerCase()}">${product.calculateRestockPriority()}</span>
                                                        </td>
                                                        <td>
                                                            <button class="btn-action edit" data-id="${product.id}"
                                                                onclick="editProduct(this.dataset.id)" title="Edit">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                            <button class="btn-action delete" data-id="${product.id}"
                                                                data-name="${product.name}"
                                                                onclick="confirmDelete(this.dataset.id, this.dataset.name)"
                                                                title="Delete">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
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

                <!-- Add Product Modal -->
                <div class="modal fade" id="addProductModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add New Product</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/inventory" method="POST"
                                enctype="multipart/form-data">
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Product Name *</label>
                                            <input type="text" class="form-control form-control-custom" name="name"
                                                required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Product Type *</label>
                                            <select class="form-select form-control-custom" name="type" id="productType"
                                                onchange="toggleTypeFields()" required>
                                                <option value="DURABLE">Durable (Electronics, Furniture, etc.)</option>
                                                <option value="PERISHABLE">Perishable (Food, Medicine, etc.)</option>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label-custom">Description</label>
                                            <textarea class="form-control form-control-custom" name="description"
                                                rows="2"></textarea>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label-custom">Product Image</label>
                                            <div class="image-upload-area" id="addImageUploadArea"
                                                onclick="document.getElementById('addImageInput').click()">
                                                <input type="file" id="addImageInput" name="imageFile"
                                                    accept=".svg,.png,.jpg,.jpeg,.webp,image/svg+xml,image/png,image/jpeg,image/webp"
                                                    style="display:none"
                                                    onchange="previewImage(this, 'addImagePreview', 'addImageUploadArea')">
                                                <input type="hidden" name="imagePath" id="addImagePath">
                                                <div id="addImagePreview" style="display:none;">
                                                    <img src="" alt="Preview"
                                                        style="max-width:100%; max-height:150px; border-radius:8px;">
                                                </div>
                                                <div id="addImageUploadPlaceholder">
                                                    <i class="bi bi-cloud-upload text-primary"
                                                        style="font-size:2rem;"></i>
                                                    <p class="text-muted small mb-0 mt-2">Click to upload image</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Price ($) *</label>
                                            <input type="number" step="0.01" min="0.01"
                                                class="form-control form-control-custom" name="price" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Quantity *</label>
                                            <input type="number" min="0" class="form-control form-control-custom"
                                                name="quantity" required>
                                        </div>
                                        <div class="col-md-4" id="warrantyField">
                                            <label class="form-label-custom">Warranty (months)</label>
                                            <input type="number" min="0" class="form-control form-control-custom"
                                                name="warrantyPeriod">
                                        </div>
                                        <div class="col-md-4" id="expiryField" style="display:none;">
                                            <label class="form-label-custom">Expiry Date</label>
                                            <input type="date" class="form-control form-control-custom"
                                                name="expiryDate">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Category *</label>
                                            <select class="form-select form-control-custom" name="categoryId" required>
                                                <c:forEach items="${categories}" var="cat">
                                                    <option value="${cat.id}">${cat.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Supplier *</label>
                                            <select class="form-select form-control-custom" name="supplierId" required>
                                                <c:forEach items="${suppliers}" var="sup">
                                                    <option value="${sup.id}">${sup.companyName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <hr class="my-3">
                                            <h6 class="mb-3"><i class="bi bi-speedometer me-2"></i>Priority Settings
                                            </h6>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-check form-switch mb-2">
                                                <input class="form-check-input" type="checkbox" name="useAutoPriority"
                                                    id="useAutoPriority" checked onchange="togglePriorityFields()">
                                                <label class="form-check-label" for="useAutoPriority">
                                                    <strong>Auto Priority</strong>
                                                    <small class="text-muted d-block">Calculate based on
                                                        stock/expiry</small>
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="manualPriorityField" style="display:none;">
                                            <label class="form-label-custom">Manual Priority</label>
                                            <select class="form-select form-control-custom" name="manualPriority"
                                                id="manualPriority">
                                                <option value="">-- Select --</option>
                                                <option value="HIGH">🔴 HIGH</option>
                                                <option value="MEDIUM">🟡 MEDIUM</option>
                                                <option value="LOW">🟢 LOW</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-custom"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="bi bi-check-lg me-1"></i>Add Product
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Edit Product Modal -->
                <div class="modal fade" id="editProductModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-pencil me-2"></i>Edit Product</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/inventory" method="POST" id="editForm"
                                enctype="multipart/form-data">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" id="editId">
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Product Name *</label>
                                            <input type="text" class="form-control form-control-custom" name="name"
                                                id="editName" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Product Type *</label>
                                            <select class="form-select form-control-custom" name="type" id="editType"
                                                onchange="toggleEditTypeFields()" required>
                                                <option value="DURABLE">Durable</option>
                                                <option value="PERISHABLE">Perishable</option>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label-custom">Description</label>
                                            <textarea class="form-control form-control-custom" name="description"
                                                id="editDescription" rows="2"></textarea>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label-custom">Product Image</label>
                                            <input type="hidden" name="existingImagePath" id="editExistingImagePath">
                                            <input type="hidden" name="removeImage" id="editRemoveImage" value="false">
                                            <div class="image-upload-area" id="editImageUploadArea"
                                                onclick="if(event.target.closest('.delete-image-btn')) return; document.getElementById('editImageInput').click()">
                                                <input type="file" id="editImageInput" name="imageFile"
                                                    accept=".svg,.png,.jpg,.jpeg,.webp,image/svg+xml,image/png,image/jpeg,image/webp"
                                                    style="display:none"
                                                    onchange="previewImage(this, 'editImagePreview', 'editImageUploadArea')">
                                                <div id="editImagePreview" style="display:none; position:relative;">
                                                    <img src="" alt="Preview"
                                                        style="max-width:100%; max-height:150px; border-radius:8px;">
                                                    <button type="button" class="btn btn-danger btn-sm delete-image-btn"
                                                        style="position:absolute; top:5px; right:5px; padding:2px 6px;"
                                                        onclick="removeProductImage()" title="Remove Image">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </div>
                                                <div id="editImageUploadPlaceholder">
                                                    <i class="bi bi-cloud-upload text-primary"
                                                        style="font-size:2rem;"></i>
                                                    <p class="text-muted small mb-0 mt-2">Click to upload or change
                                                        image</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Price ($) *</label>
                                            <input type="number" step="0.01" min="0.01"
                                                class="form-control form-control-custom" name="price" id="editPrice"
                                                required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Quantity *</label>
                                            <input type="number" min="0" class="form-control form-control-custom"
                                                name="quantity" id="editQuantity" required>
                                        </div>
                                        <div class="col-md-4" id="editWarrantyField">
                                            <label class="form-label-custom">Warranty (months)</label>
                                            <input type="number" min="0" class="form-control form-control-custom"
                                                name="warrantyPeriod" id="editWarranty">
                                        </div>
                                        <div class="col-md-4" id="editExpiryField" style="display:none;">
                                            <label class="form-label-custom">Expiry Date</label>
                                            <input type="date" class="form-control form-control-custom"
                                                name="expiryDate" id="editExpiry">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Category *</label>
                                            <select class="form-select form-control-custom" name="categoryId"
                                                id="editCategory" required>
                                                <c:forEach items="${categories}" var="cat">
                                                    <option value="${cat.id}">${cat.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Supplier *</label>
                                            <select class="form-select form-control-custom" name="supplierId"
                                                id="editSupplier" required>
                                                <c:forEach items="${suppliers}" var="sup">
                                                    <option value="${sup.id}">${sup.companyName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <hr class="my-3">
                                            <h6 class="mb-3"><i class="bi bi-speedometer me-2"></i>Priority Settings
                                            </h6>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-check form-switch mb-2">
                                                <input class="form-check-input" type="checkbox" name="useAutoPriority"
                                                    id="editUseAutoPriority" checked
                                                    onchange="toggleEditPriorityFields()">
                                                <label class="form-check-label" for="editUseAutoPriority">
                                                    <strong>Auto Priority</strong>
                                                    <small class="text-muted d-block">Calculate based on
                                                        stock/expiry</small>
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="editManualPriorityField" style="display:none;">
                                            <label class="form-label-custom">Manual Priority</label>
                                            <select class="form-select form-control-custom" name="manualPriority"
                                                id="editManualPriority">
                                                <option value="">-- Select --</option>
                                                <option value="HIGH">🔴 HIGH</option>
                                                <option value="MEDIUM">🟡 MEDIUM</option>
                                                <option value="LOW">🟢 LOW</option>
                                            </select>
                                        </div>
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

                <!-- Delete Confirmation Modal -->
                <div class="modal fade" id="deleteModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i
                                        class="bi bi-exclamation-triangle text-danger me-2"></i>Confirm Delete</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p>Are you sure you want to delete <strong id="deleteProductName"></strong>?</p>
                                <p class="text-muted small">This action cannot be undone.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-custom"
                                    data-bs-dismiss="modal">Cancel</button>
                                <a href="#" id="deleteLink" class="btn btn-danger">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    // Toggle type-specific fields in Add modal
                    function toggleTypeFields() {
                        const type = document.getElementById('productType').value;
                        document.getElementById('warrantyField').style.display = type === 'DURABLE' ? 'block' : 'none';
                        document.getElementById('expiryField').style.display = type === 'PERISHABLE' ? 'block' : 'none';
                    }

                    // Toggle type-specific fields in Edit modal
                    function toggleEditTypeFields() {
                        const type = document.getElementById('editType').value;
                        document.getElementById('editWarrantyField').style.display = type === 'DURABLE' ? 'block' : 'none';
                        document.getElementById('editExpiryField').style.display = type === 'PERISHABLE' ? 'block' : 'none';
                    }

                    // Toggle priority fields in Add modal
                    function togglePriorityFields() {
                        const isAuto = document.getElementById('useAutoPriority').checked;
                        document.getElementById('manualPriorityField').style.display = isAuto ? 'none' : 'block';
                    }

                    // Toggle priority fields in Edit modal
                    function toggleEditPriorityFields() {
                        const isAuto = document.getElementById('editUseAutoPriority').checked;
                        document.getElementById('editManualPriorityField').style.display = isAuto ? 'none' : 'block';
                    }

                    // Image preview function
                    function previewImage(input, previewId, areaId) {
                        const previewDiv = document.getElementById(previewId);
                        const placeholder = document.getElementById(areaId).querySelector('[id$="Placeholder"]');

                        // Reset remove flag if this is the edit input
                        if (input.id === 'editImageInput') {
                            document.getElementById('editRemoveImage').value = 'false';
                        }

                        if (input.files && input.files[0]) {
                            const reader = new FileReader();

                            reader.onload = function (e) {
                                previewDiv.querySelector('img').src = e.target.result;
                                previewDiv.style.display = 'block';
                                if (placeholder) placeholder.style.display = 'none';
                            };

                            reader.readAsDataURL(input.files[0]);
                        }
                    }

                    // Remove product image
                    function removeProductImage() {
                        // Set remove flag to true
                        document.getElementById('editRemoveImage').value = 'true';

                        // Clear file input
                        document.getElementById('editImageInput').value = '';

                        // Hide preview and show placeholder
                        document.getElementById('editImagePreview').style.display = 'none';
                        document.getElementById('editImageUploadPlaceholder').style.display = 'block';

                        // Clear existing path
                        document.getElementById('editExistingImagePath').value = '';
                    }

                    // Edit product - redirect to get product data
                    function editProduct(id) {
                        window.location.href = '${pageContext.request.contextPath}/inventory?action=edit&id=' + id;
                    }

                    // Confirm delete
                    function confirmDelete(id, name) {
                        document.getElementById('deleteProductName').textContent = name;
                        document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/inventory?action=delete&id=' + id;
                        new bootstrap.Modal(document.getElementById('deleteModal')).show();
                    }

                    // If we have an edit product, show the edit modal
                    <c:if test="${not empty editProduct}">
                        document.addEventListener('DOMContentLoaded', function() {
                            document.getElementById('editId').value = '${editProduct.id}';
                        document.getElementById('editName').value = '${editProduct.name}';
                        document.getElementById('editDescription').value = '${editProduct.description}';
                        document.getElementById('editPrice').value = '${editProduct.price}';
                        document.getElementById('editQuantity').value = '${editProduct.quantity}';
                        document.getElementById('editType').value = '${editProduct.type}';
                        document.getElementById('editCategory').value = '${editProduct.categoryId}';
                        document.getElementById('editSupplier').value = '${editProduct.supplierId}';
                        <c:if test="${editProduct.type == 'DURABLE'}">
                            document.getElementById('editWarranty').value = '${editProduct.warrantyPeriod}';
                        </c:if>
                        <c:if test="${editProduct.type == 'PERISHABLE'}">
                            document.getElementById('editExpiry').value = '${editProduct.expiryDate}';
                        </c:if>

                        // Load existing image if available
                        <c:if test="${not empty editProduct.imagePath}">
                            document.getElementById('editExistingImagePath').value = '${editProduct.imagePath}';
                            document.getElementById('editRemoveImage').value = 'false';
                            var editImagePreview = document.getElementById('editImagePreview');
                            var editImagePlaceholder = document.getElementById('editImageUploadPlaceholder');
                            editImagePreview.querySelector('img').src = '${pageContext.request.contextPath}/${editProduct.imagePath}';
                            editImagePreview.style.display = 'block';
                            editImagePlaceholder.style.display = 'none';
                        </c:if>

                        toggleEditTypeFields();
                        new bootstrap.Modal(document.getElementById('editProductModal')).show();
                    });
                    </c:if>
                </script>

                <!-- Toast Notifications -->
                <script src="${pageContext.request.contextPath}/js/toast.js"></script>
            </body>

            </html>