<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Categories - StockPulse</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
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
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/reports">
                                    <i class="bi bi-file-earmark-bar-graph"></i> Reports
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/categories">
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
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h1><i class="bi bi-tags me-2"></i>Categories</h1>
                        <p>Manage product categories</p>
                    </div>
                    <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="bi bi-plus-lg me-2"></i>Add Category
                    </button>
                </div>

                <!-- Messages -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-custom ${param.messageType} mb-4">
                        <i
                            class="bi bi-${param.messageType == 'success' ? 'check-circle' : 'exclamation-circle'}-fill"></i>
                        <span>${param.message}</span>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-custom danger mb-4">
                        <i class="bi bi-exclamation-circle-fill"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <!-- Categories Grid -->
                <div class="row g-4">
                    <c:forEach var="category" items="${categories}">
                        <div class="col-md-4 col-lg-3">
                            <div class="content-card h-100">
                                <div class="card-body-custom">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="stat-icon primary">
                                            <i class="bi bi-tag"></i>
                                        </div>
                                        <div class="dropdown">
                                            <button class="btn btn-sm" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li>
                                                    <a class="dropdown-item edit-category-btn" href="#"
                                                        data-id="${category.id}" data-name="${category.name}"
                                                        data-description="${category.description}">
                                                        <i class="bi bi-pencil me-2"></i>Edit
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item text-danger delete-category-btn" href="#"
                                                        data-id="${category.id}" data-name="${category.name}">
                                                        <i class="bi bi-trash me-2"></i>Delete
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <h5 class="mb-2">${category.name}</h5>
                                    <p class="text-muted small mb-3">${not empty category.description ?
                                        category.description : 'No description'}</p>
                                    <span class="badge bg-primary">${category.productCount} products</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <div class="col-12">
                            <div class="empty-state">
                                <i class="bi bi-tags"></i>
                                <h4>No Categories Yet</h4>
                                <p>Add your first category to organize products.</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Add Category Modal -->
            <div class="modal fade" id="addCategoryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add Category</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/categories" method="POST">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label-custom">Category Name *</label>
                                    <input type="text" class="form-control form-control-custom" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label-custom">Description</label>
                                    <textarea class="form-control form-control-custom" name="description"
                                        rows="3"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-custom"
                                    data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="bi bi-check-lg me-1"></i>Add Category
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Category Modal -->
            <div class="modal fade" id="editCategoryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-pencil me-2"></i>Edit Category</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/categories" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="editId">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label-custom">Category Name *</label>
                                    <input type="text" class="form-control form-control-custom" name="name"
                                        id="editName" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label-custom">Description</label>
                                    <textarea class="form-control form-control-custom" name="description"
                                        id="editDescription" rows="3"></textarea>
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
                            <h5 class="modal-title"><i class="bi bi-exclamation-triangle text-danger me-2"></i>Confirm
                                Delete</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete <strong id="deleteCategoryName"></strong>?</p>
                            <p class="text-muted small">Products in this category will have no category assigned.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                            <a href="#" id="deleteLink" class="btn btn-danger">
                                <i class="bi bi-trash me-1"></i>Delete
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function editCategory(id, name, description) {
                    document.getElementById('editId').value = id;
                    document.getElementById('editName').value = name;
                    document.getElementById('editDescription').value = description || '';
                    new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
                }

                function confirmDelete(id, name) {
                    document.getElementById('deleteCategoryName').textContent = name;
                    document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/categories?action=delete&id=' + id;
                    new bootstrap.Modal(document.getElementById('deleteModal')).show();
                }

                // Event delegation for edit and delete buttons
                document.addEventListener('DOMContentLoaded', function () {
                    // Edit category buttons
                    document.querySelectorAll('.edit-category-btn').forEach(function (btn) {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            var id = this.getAttribute('data-id');
                            var name = this.getAttribute('data-name');
                            var desc = this.getAttribute('data-description');
                            editCategory(id, name, desc);
                        });
                    });

                    // Delete category buttons
                    document.querySelectorAll('.delete-category-btn').forEach(function (btn) {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            var id = this.getAttribute('data-id');
                            var name = this.getAttribute('data-name');
                            confirmDelete(id, name);
                        });
                    });

                    <c:if test="${not empty editCategory}">
                    // Auto-open edit modal if editing
                        editCategory('${editCategory.id}', '${editCategory.name}', '${editCategory.description}');
                    </c:if>
                });
            </script>

            <!-- Toast Notifications -->
            <script src="${pageContext.request.contextPath}/js/toast.js"></script>
        </body>

        </html>