<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>

<%
    // Safe check for session
    if(session.getAttribute("user_id") != null){
        String role = (String) session.getAttribute("role");
        if("student".equals(role)){  
            response.sendRedirect("jsp/dashboard.jsp");
        } else if("admin".equals(role)){
            response.sendRedirect("jsp/adminDashboard.jsp");
        }
    }

    // Use session attributes to show messages
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");

    if(message != null) session.removeAttribute("message");
    if(error != null) session.removeAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Project Tracker - Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            min-height: 100vh;
            transition: 0.5s;
        }
        .dark-mode {
            background: linear-gradient(to right, #141e30, #243b55);
            color: white;
        }
        .header-title {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 30px;
            font-weight: bold;
            color: white;
        }
        .login-card {
            border-radius: 15px;
            padding: 30px;
            background: white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            animation: fadeIn 1s ease-in-out;
        }
        .dark-mode .login-card {
            background: #1e1e1e;
            color: white;
        }
        .btn-custom {
            background-color: #4facfe;
            border: none;
        }
        .btn-custom:hover {
            background-color: #00c6ff;
        }
        .toggle-btn {
            position: absolute;
            right: 10px;
            top: 38px;
            cursor: pointer;
        }
        .dark-toggle {
            position: absolute;
            top: 20px;
            right: 20px;
            cursor: pointer;
            font-size: 20px;
            color: white;
        }
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }
        /* Toast container */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
    </style>
</head>

<body>

<!-- Header -->
<div class="header-title">
    <i class="fas fa-project-diagram"></i> Student Project Tracker
</div>

<!-- Dark Mode Toggle -->
<div class="dark-toggle" onclick="toggleDarkMode()">
    <i class="fas fa-moon"></i>
</div>

<!-- Toast Container for Alerts -->
<div class="toast-container">
    <% if(message != null){ %>
        <div class="toast align-items-center text-bg-success border-0 show mb-2" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle"></i> <%= message %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    <% } %>

    <% if(error != null){ %>
        <div class="toast align-items-center text-bg-danger border-0 show mb-2" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-triangle"></i> <%= error %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    <% } %>
</div>

<!-- Login Card -->
<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="col-md-5 login-card">

        <h3 class="text-center mb-4">
            <i class="fas fa-user-circle"></i> Login
        </h3>

        <form action="<%=request.getContextPath()%>/LoginServlet" method="post">

            <div class="mb-3">
                <label><i class="fas fa-envelope"></i> Email</label>
                <input type="email" class="form-control" name="email" placeholder="Enter email" required>
            </div>

            <div class="mb-3 position-relative">
                <label><i class="fas fa-lock"></i> Password</label>
                <input type="password" id="password" class="form-control" name="password" placeholder="Enter password" required>
                <i class="fas fa-eye toggle-btn" onclick="togglePassword()"></i>
            </div>

            <div class="mb-3">
                <label><i class="fas fa-user-tag"></i> Role</label>
                <select class="form-select" name="role" required>
                    <option value="student">Student</option>
                    <option value="admin">Teacher</option>
                </select>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-custom">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </div>

        </form>

        <div class="text-center mt-3">
            <p>New User? 
                <a href="jsp/signup.jsp" style="text-decoration:none; font-weight:bold;">
                    Register Here
                </a>
            </p>
        </div>

    </div>
</div>

<script>
    function togglePassword() {
        let pass = document.getElementById("password");
        let icon = document.querySelector(".toggle-btn");
        if (pass.type === "password") {
            pass.type = "text";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            pass.type = "password";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        }
    }

    function toggleDarkMode() {
        document.body.classList.toggle("dark-mode");
    }

    // Initialize Bootstrap Toasts
    var toastElList = [].slice.call(document.querySelectorAll('.toast'));
    var toastList = toastElList.map(function(toastEl) {
        return new bootstrap.Toast(toastEl, { delay: 4000 });
    });
    toastList.forEach(toast => toast.show());
</script>

</body>
</html>