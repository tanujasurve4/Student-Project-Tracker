<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // ✅ Session check
    if(session.getAttribute("user_id") == null){
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // Get user info
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    // Get success/error messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Project</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
    .navbar { background: linear-gradient(to right, #4facfe, #00f2fe); }
    .navbar-brand { font-size:26px; font-weight:bold; color:white !important; }
    .form-card { border-radius:20px; padding:30px; background:white; box-shadow:0 10px 25px rgba(0,0,0,0.1);}
    .btn-custom { background:#4facfe; border:none; }
    .btn-custom:hover { background:#00c6ff; }
    .file-label { font-weight:bold; }
    #imagePreview img { margin:3px; border-radius:5px; object-fit:cover; height:80px; width:80px; }
</style>
</head>

<body>

<!-- 🔥 Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">
        <!-- Brand -->
        <a class="navbar-brand fs-5 d-flex align-items-center">
            <i class="fas fa-project-diagram me-2"></i> Student Project Tracker
        </a>

        <!-- Right Side -->
        <div class="d-flex align-items-center ms-auto">
            <span class="text-white fw-bold me-3">
                <i class="fas fa-user me-1"></i> <%= name %>
            </span>

            <!-- Back Button -->
            <% if("admin".equals(role)){ %>
                <a href="<%=request.getContextPath()%>/jsp/adminDashboard.jsp" class="btn btn-light me-2">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/jsp/dashboard.jsp" class="btn btn-light me-2">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            <% } %>

            <!-- Logout -->
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">

    <!-- Success/Error Alerts -->
    <% if(success != null){ %>
        <div class="alert alert-success text-center">✅ Project Uploaded Successfully!</div>
    <% } %>
    <% if(error != null){ %>
        <div class="alert alert-danger text-center">
            <% if("empty".equals(error)) { %>All fields are required!<% } %>
            <% if("image".equals(error)) { %>Invalid Image File!<% } %>
            <% if("pdf".equals(error)) { %>Only PDF allowed!<% } %>
            <% if("failed".equals(error)) { %>Upload Failed!<% } %>
            <% if("server".equals(error)) { %>Server Error!<% } %>
        </div>
    <% } %>

    <!-- Add Project Form -->
    <div class="container d-flex justify-content-center mt-3">
        <div class="col-md-6 form-card">
            <h3 class="text-center mb-4"><i class="fas fa-upload"></i> Add New Project</h3>
            <form action="<%=request.getContextPath()%>/AddProjectServlet" method="post" enctype="multipart/form-data">

                <!-- Title -->
                <div class="mb-3">
                    <label class="form-label file-label"><i class="fas fa-heading"></i> Project Title</label>
                    <input type="text" class="form-control" name="title" placeholder="Enter project title" required>
                </div>

                <!-- Description -->
                <div class="mb-3">
                    <label class="form-label file-label"><i class="fas fa-align-left"></i> Description</label>
                    <textarea class="form-control" name="description" rows="4" placeholder="Enter project description" required></textarea>
                </div>

                <!-- Images -->
                <div class="mb-3">
                    <label class="form-label file-label"><i class="fas fa-image"></i> Upload Images</label>
                    <input type="file" class="form-control" name="images" accept="image/*" multiple>
                    <small class="text-muted">You can select multiple images.</small>
                    <div id="imagePreview" class="mt-2 d-flex flex-wrap"></div>
                </div>

                <!-- PDFs -->
                <div class="mb-3">
                    <label class="form-label file-label"><i class="fas fa-file-pdf"></i> Upload PDFs</label>
                    <input type="file" class="form-control" name="pdfs" accept="application/pdf" multiple>
                    <small class="text-muted">You can select multiple PDF files.</small>
                    <div id="pdfPreview" class="mt-2"></div>
                </div>

                <!-- Submit -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-custom"><i class="fas fa-upload"></i> Upload Project</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-hide alerts
    setTimeout(() => {
        let alert = document.querySelector('.alert');
        if(alert){ alert.style.display = "none"; }
    }, 3000);

    // Image preview
    const imagesInput = document.querySelector('input[name="images"]');
    const imagePreview = document.getElementById('imagePreview');
    imagesInput.addEventListener('change', function(){
        imagePreview.innerHTML = '';
        Array.from(this.files).forEach(file => {
            const img = document.createElement('img');
            img.src = URL.createObjectURL(file);
            imagePreview.appendChild(img);
        });
    });

    // PDF preview (names)
    const pdfsInput = document.querySelector('input[name="pdfs"]');
    const pdfPreview = document.getElementById('pdfPreview');
    pdfsInput.addEventListener('change', function(){
        pdfPreview.innerHTML = '';
        Array.from(this.files).forEach(file => {
            const div = document.createElement('div');
            div.textContent = file.name;
            div.classList.add('badge','bg-secondary','me-1','mb-1','p-2');
            pdfPreview.appendChild(div);
        });
    });
</script>

</body>
</html>