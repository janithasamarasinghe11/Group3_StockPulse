<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Management - StockPulse</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                    rel="stylesheet">
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
                                    <a class="nav-link" href="${pageContext.request.contextPath}/reports">
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
                                        <a class="nav-link active" href="${pageContext.request.contextPath}/users">
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
                            <h1><i class="bi bi-people me-2"></i>User Management</h1>
                            <p>Manage staff accounts and access</p>
                        </div>
                        <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="bi bi-person-plus me-2"></i>Add User
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

                    <!-- Users Table -->
                    <div class="content-card">
                        <div class="card-header-custom">
                            <h5><i class="bi bi-people me-2"></i>All Users (${users.size()})</h5>
                        </div>
                        <div class="card-body-custom p-0">
                            <div class="table-container">
                                <table class="custom-table">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Username</th>
                                            <th>Role</th>
                                            <th>Created</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="stat-icon ${user.role == 'ADMIN' ? 'primary' : 'info'} me-3"
                                                            style="width: 40px; height: 40px;">
                                                            <i class="bi bi-person"></i>
                                                        </div>
                                                        <strong>${user.fullName}</strong>
                                                    </div>
                                                </td>
                                                <td><code>${user.username}</code></td>
                                                <td>
                                                    <span
                                                        class="badge ${user.role == 'ADMIN' ? 'bg-primary' : 'bg-secondary'}">
                                                        ${user.role}
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td>
                                                    <button class="btn-action edit edit-user-btn" data-id="${user.id}"
                                                        data-fullname="${user.fullName}" data-role="${user.role}"
                                                        title="Edit">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <c:if test="${user.id != sessionScope.userId}">
                                                        <button class="btn-action delete delete-user-btn"
                                                            data-id="${user.id}" data-fullname="${user.fullName}"
                                                            title="Delete">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add User Modal -->
                <div class="modal fade" id="addUserModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Add New User</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/users" method="POST">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label-custom">Username *</label>
                                        <input type="text" class="form-control form-control-custom" name="username"
                                            required pattern="[a-zA-Z0-9_]+"
                                            title="Letters, numbers, and underscores only">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Password *</label>
                                        <input type="password" class="form-control form-control-custom" name="password"
                                            required minlength="6">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Full Name *</label>
                                        <input type="text" class="form-control form-control-custom" name="fullName"
                                            required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Role *</label>
                                        <select class="form-select form-control-custom" name="role" required>
                                            <option value="STAFF">Staff</option>
                                            <option value="ADMIN">Admin</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-custom"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="bi bi-check-lg me-1"></i>Create User
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Edit User Modal -->
                <div class="modal fade" id="editUserModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-pencil me-2"></i>Edit User</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/users" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" id="editId">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label-custom">Full Name *</label>
                                        <input type="text" class="form-control form-control-custom" name="fullName"
                                            id="editFullName" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">New Password</label>
                                        <input type="password" class="form-control form-control-custom"
                                            name="newPassword" minlength="6" placeholder="Leave blank to keep current">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label-custom">Role *</label>
                                        <select class="form-select form-control-custom" name="role" id="editRole"
                                            required>
                                            <option value="STAFF">Staff</option>
                                            <option value="ADMIN">Admin</option>
                                        </select>
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
                                <p>Are you sure you want to delete <strong id="deleteUserName"></strong>?</p>
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

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function editUser(id, fullName, role) {
                        document.getElementById('editId').value = id;
                        document.getElementById('editFullName').value = fullName;
                        document.getElementById('editRole').value = role;
                        new bootstrap.Modal(document.getElementById('editUserModal')).show();
                    }

                    function confirmDelete(id, name) {
                        document.getElementById('deleteUserName').textContent = name;
                        document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/users?action=delete&id=' + id;
                        new bootstrap.Modal(document.getElementById('deleteModal')).show();
                    }

                    // Event delegation for edit and delete buttons
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('.edit-user-btn').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                var id = this.getAttribute('data-id');
                                var fullName = this.getAttribute('data-fullname');
                                var role = this.getAttribute('data-role');
                                editUser(id, fullName, role);
                            });
                        });

                        document.querySelectorAll('.delete-user-btn').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                var id = this.getAttribute('data-id');
                                var fullName = this.getAttribute('data-fullname');
                                confirmDelete(id, fullName);
                            });
                        });
                    });
                </script>

                <!-- Toast Notifications -->
                <script src="${pageContext.request.contextPath}/js/toast.js"></script>
            </body>

            </html>