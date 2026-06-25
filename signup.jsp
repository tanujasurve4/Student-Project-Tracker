<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Project Tracker - Signup</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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

        .signup-card {
            border-radius: 15px;
            padding: 30px;
            background: white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            animation: fadeIn 1s ease-in-out;
        }

        .dark-mode .signup-card {
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

<div class="container d-flex justify-content-center align-items-center">

    <div class="col-md-5 signup-card mt-5 mb-5">

        <h3 class="text-center mb-4">
            <i class="fas fa-user-plus"></i> Signup
        </h3>

        <form action="<%=request.getContextPath()%>/SignupServlet" method="post">

            <!-- Role -->
            <div class="mb-3">
                <label><i class="fas fa-user-tag"></i> Role</label>
                <select class="form-select" name="role" id="role" onchange="toggleFields()">
                    <option value="student">Student</option>
                    <option value="admin">Teacher</option>
                </select>
            </div>

            <!-- Common Fields -->
            <div class="mb-3">
                <label><i class="fas fa-user"></i> Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>

            <div class="mb-3">
                <label><i class="fas fa-envelope"></i> Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>

            <div class="mb-3 position-relative">
                <label><i class="fas fa-lock"></i> Password</label>
                <input type="password" id="password" class="form-control" name="password" required>
                <i class="fas fa-eye toggle-btn" onclick="togglePassword()"></i>
            </div>

            <!-- Student Fields -->
            <div id="studentFields">

                <div class="mb-3">
                    <label><i class="fas fa-id-card"></i> Roll No</label>
                    <input type="text" class="form-control" name="roll">
                </div>

                <div class="mb-3">
                    <label><i class="fas fa-calendar"></i> Year</label>
                    <input type="text" class="form-control" name="year">
                </div>

                <div class="mb-3">
                    <label><i class="fas fa-users"></i> Division</label>
                    <input type="text" class="form-control" name="div">
                </div>

                <div class="mb-3">
                    <label><i class="fas fa-building"></i> Department</label>
                    <input type="text" class="form-control" name="dept">
                </div>

            </div>

            <!-- Teacher Fields -->
            <div id="teacherFields" style="display:none;">
                <div class="mb-3">
                    <label><i class="fas fa-chalkboard-teacher"></i> Department</label>
                    <input type="text" class="form-control" name="teacherDept">
                </div>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-custom">
                    <i class="fas fa-user-plus"></i> Register
                </button>
            </div>

        </form>

        <div class="text-center mt-3">
            <p>Already have an account? 
                <a href="../index.jsp" style="text-decoration:none; font-weight:bold;">
                    Login Here
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

    function toggleFields() {
        let role = document.getElementById("role").value;

        let studentFields = document.getElementById("studentFields");
        let teacherFields = document.getElementById("teacherFields");

        if (role === "student") {
            studentFields.style.display = "block";
            teacherFields.style.display = "none";
        } else {
            studentFields.style.display = "none";
            teacherFields.style.display = "block";
        }
    }

    // Run on page load
    window.onload = toggleFields;
</script>

</body>
</html>