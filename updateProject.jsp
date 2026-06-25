<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    if(session.getAttribute("user_id") == null){
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String name = (String) session.getAttribute("name"); // user name
    String role = (String) session.getAttribute("role"); // role if needed

    String projectIdStr = request.getParameter("id");
    if(projectIdStr == null){
        response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp");
        return;
    }
    int projectId = Integer.parseInt(projectIdStr);

    String title="", description="";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM projects WHERE id=?");
        ps.setInt(1, projectId);
        rs = ps.executeQuery();
        if(rs.next()){
            title = rs.getString("title");
            description = rs.getString("description");
        }
    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){ }
        try{ if(ps!=null) ps.close(); } catch(Exception e){ }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Project</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
    .navbar { background: linear-gradient(to right, #4facfe, #00f2fe); }
    .navbar-brand { font-size:26px; font-weight:bold; color:white !important; }
    .form-card { border-radius:20px; padding:30px; background:white; box-shadow:0 10px 25px rgba(0,0,0,0.1);}
    .btn-custom { background:#4facfe; border:none; }
    .btn-custom:hover { background:#00c6ff; }
    .thumb-img { height:100px; width:100px; object-fit:cover; margin:3px; }
</style>
</head>

<body>
<!-- 🔥 NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">

        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center">
            <i class="fas fa-project-diagram me-2"></i> Student Project Tracker
        </a>

        <!-- Right Side -->
        <div class="d-flex align-items-center ms-auto">
            <!-- User Name -->
            <span class="text-white fw-bold me-3">
                <i class="fas fa-user me-1"></i> <%= name %>
            </span>

            <!-- Back Button -->
            <a href="<%=request.getContextPath()%>/jsp/viewProjectDetail.jsp" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <!-- Logout -->
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="col-md-8 mx-auto form-card">
        <h3 class="text-center mb-4"><i class="fas fa-edit"></i> Update Project</h3>

        <form action="<%=request.getContextPath()%>/UpdateProjectServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%=projectId%>">

            <div class="mb-3">
                <label class="form-label"><i class="fas fa-heading"></i> Project Title</label>
                <input type="text" class="form-control" name="title" value="<%=title%>" required>
            </div>

            <div class="mb-3">
                <label class="form-label"><i class="fas fa-align-left"></i> Description</label>
                <textarea class="form-control" name="description" rows="4" required><%=description%></textarea>
            </div>

            <!-- Existing Images -->
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-image"></i> Existing Images</label>
                <div class="d-flex flex-wrap">
                <%
                    try{
                        ps = con.prepareStatement(
                            "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='image'"
                        );
                        ps.setInt(1, projectId);
                        rs = ps.executeQuery();
                        while(rs.next()){
                            int fileId = rs.getInt("id");
                            String nameImg = rs.getString("file_name");
                %>
                    <div class="text-center me-2 mb-2">
                        <img src="<%=request.getContextPath()%>/ViewImageServlet?id=<%=fileId%>" class="thumb-img" alt="Image">
                        <br>
                        <a href="<%=request.getContextPath()%>/DeleteFileServlet?id=<%=fileId%>" 
                           class="btn btn-sm btn-danger mt-1" 
                           onclick="return confirm('Delete this image?');">
                            <i class="fas fa-trash"></i>
                        </a>
                    </div>
                <%
                        }
                    } catch(Exception e){ e.printStackTrace(); } finally { try{ if(rs!=null) rs.close(); } catch(Exception e){} try{ if(ps!=null) ps.close(); } catch(Exception e){} }
                %>
                </div>
            </div>

            <!-- Add New Images -->
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-image"></i> Add New Images</label>
                <input type="file" class="form-control" name="images" accept="image/*" multiple>
                <small class="text-muted">Select multiple images to add</small>
            </div>

            <!-- Existing PDFs -->
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-file-pdf"></i> Existing PDFs</label>
                <div class="mb-2">
                <%
                    try{
                        ps = con.prepareStatement(
                            "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='pdf'"
                        );
                        ps.setInt(1, projectId);
                        rs = ps.executeQuery();
                        while(rs.next()){
                            int fileId = rs.getInt("id");
                            String namePdf = rs.getString("file_name");
                %>
                    <div class="d-flex align-items-center mb-1">
                        <a href="<%=request.getContextPath()%>/ViewPDFServlet?id=<%=fileId%>" 
                           class="btn btn-sm btn-success me-2" target="_blank">
                           <i class="fas fa-file-pdf"></i> <%=namePdf%>
                        </a>
                        <a href="<%=request.getContextPath()%>/DeleteFileServlet?id=<%=fileId%>" 
                           class="btn btn-sm btn-danger" 
                           onclick="return confirm('Delete this PDF?');">
                            <i class="fas fa-trash"></i>
                        </a>
                    </div>
                <%
                        }
                    } catch(Exception e){ e.printStackTrace(); } finally { try{ if(rs!=null) rs.close(); } catch(Exception e){} try{ if(ps!=null) ps.close(); } catch(Exception e){} }
                %>
                </div>
            </div>

            <!-- Add New PDFs -->
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-file-pdf"></i> Add New PDFs</label>
                <input type="file" class="form-control" name="pdfs" accept="application/pdf" multiple>
                <small class="text-muted">Select multiple PDF files to add</small>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-custom"><i class="fas fa-save"></i> Update Project</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>