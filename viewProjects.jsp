<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    if(session.getAttribute("user_id") == null){
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Projects</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: bold;
            color: white !important;
        }

        .card {
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.18);
        }

        .card h5 {
            font-weight: bold;
        }

        .card p {
            color: #555;
            flex-grow: 1;
        }

        .btn-info {
            transition: 0.3s;
        }

        .btn-info:hover {
            opacity: 0.9;
        }

        .gallery img {
            height: 100px;
            width: 100px;
            object-fit: cover;
            margin: 5px;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .gallery img:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1050;
            top:0;
            left:0;
            width:100%;
            height:100%;
            background: rgba(0,0,0,0.85);
            align-items: center;
            justify-content: center;
            padding: 15px;
        }
        .modal img {
            max-width: 95%;
            max-height: 95%;
            border-radius: 12px;
            transition: transform 0.3s ease;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }
        .modal-buttons {
            position: absolute;
            top: 15px;
            right: 20px;
        }
        .modal-buttons .btn {
            margin-left: 5px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }

        .container .row {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center">
            <i class="fas fa-project-diagram me-2"></i> Student Project Tracker
        </a>
        <div class="d-flex align-items-center ms-auto">
            <span class="text-white fw-bold me-3">
                <i class="fas fa-user me-1"></i> <%= name %>
            </span>

            <% if("admin".equals(role)){ %>
                <a href="<%=request.getContextPath()%>/jsp/adminDashboard.jsp" class="btn btn-light me-2">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/jsp/dashboard.jsp" class="btn btn-light me-2">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            <% } %>

            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">

        <%
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM projects WHERE user_id=?");
            ps.setInt(1, (Integer)session.getAttribute("user_id"));
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                int projectId = rs.getInt("id");
                String title = rs.getString("title");
                String desc = rs.getString("description");
        %>

        <div class="col-md-4 mb-4">
            <div class="card p-3 h-100">
                <h5 class="text-primary"><%= title %></h5>
                <p><%= desc.length() > 100 ? desc.substring(0,100)+"..." : desc %></p>
                <a href="javascript:void(0);" onclick="openProject(<%=projectId%>)" class="btn btn-info btn-sm mt-auto">
                    <i class="fas fa-eye"></i> View Project
                </a>
            </div>
        </div>

        <%
            }
            rs.close();
            ps.close();
        } catch(Exception e){
            out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
        }
        %>

    </div>
</div>

<!-- IMAGE MODAL -->
<div id="imgModal" class="modal">
    <div style="position:relative;">
        <img id="modalImg" src="">
        <div class="modal-buttons">
            <button class="btn btn-light btn-sm" onclick="zoomImage()">
                <i class="fas fa-search-plus"></i>
            </button>
            <a id="downloadBtn" href="#" class="btn btn-success btn-sm" download>
                <i class="fas fa-download"></i>
            </a>
            <button class="btn btn-danger btn-sm" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</div>

<script>
function openModal(src, fileName){
    const modal = document.getElementById('imgModal');
    const img = document.getElementById('modalImg');
    const downloadBtn = document.getElementById('downloadBtn');

    img.src = src;
    downloadBtn.href = src;
    downloadBtn.download = fileName;

    modal.style.display = 'flex';
    modal.style.alignItems = 'center';
    modal.style.justifyContent = 'center';
}

function closeModal(){
    const modal = document.getElementById('imgModal');
    modal.style.display = 'none';
    document.getElementById('modalImg').style.transform = "scale(1)";
}

function zoomImage(){
    const img = document.getElementById('modalImg');
    if(img.style.transform === "scale(2)"){
        img.style.transform = "scale(1)";
    } else {
        img.style.transform = "scale(2)";
    }
}

// Open Project (loads modal with all details)
function openProject(projectId){
    window.location.href = "<%=request.getContextPath()%>/jsp/viewProjectDetail.jsp?id=" + projectId;
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>