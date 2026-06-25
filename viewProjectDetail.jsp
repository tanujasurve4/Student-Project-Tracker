<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    // Session check
    if(session.getAttribute("user_id") == null){
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    // Get project ID from query
    String projectIdStr = request.getParameter("id");
    if(projectIdStr == null){
        response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp");
        return;
    }
    int projectId = Integer.parseInt(projectIdStr);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Project Details</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
        .navbar { background: linear-gradient(to right, #4facfe, #00f2fe); }
        .navbar-brand { font-size: 24px; font-weight: bold; color: white !important; }
        .card { border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.1); transition: 0.3s; margin-bottom: 20px; }
        .card:hover { transform: translateY(-5px); }
        .gallery img { height: 120px; width: 120px; object-fit: cover; margin: 5px; border-radius: 8px; cursor: pointer; transition: 0.3s; }
        .gallery img:hover { transform: scale(1.1); }
        .rating { color: #ffc107; }

        /* Modal styles for image zoom with prev/next/download/close */
        .modal {
            display:none;
            position:fixed;
            top:0; left:0;
            width:100%; height:100%;
            background:rgba(0,0,0,0.9);
            z-index:1050;
            justify-content:center;
            align-items:center;
            flex-direction:column;
        }
        .modal img {
            max-width:80%;
            max-height:80%;
            border-radius:10px;
            transition: transform 0.3s ease;
        }
        .modal-controls {
            margin-top:15px;
        }
        .modal-controls .btn { margin: 0 5px; }
        .nav-btn {
            position:absolute;
            top:50%;
            transform:translateY(-50%);
            font-size:40px;
            color:white;
            cursor:pointer;
            user-select:none;
        }
        .nav-btn.prev { left:20px; }
        .nav-btn.next { right:20px; }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fs-5 d-flex align-items-center">
            <i class="fas fa-project-diagram me-2"></i> Project Details
        </a>

        <div class="d-flex align-items-center ms-auto">
            <span class="text-white fw-bold me-3">
                <i class="fas fa-user me-1"></i> <%= name %>
            </span>
            <a href="<%=request.getContextPath()%>/jsp/viewProjects.jsp" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container">
<%
try(Connection con = DBConnection.getConnection()) {

    // Project details
    PreparedStatement ps = con.prepareStatement("SELECT * FROM projects WHERE id=?");
    ps.setInt(1, projectId);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        String title = rs.getString("title");
        String description = rs.getString("description");
        String status = rs.getString("status");
%>

<div class="card p-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="text-primary"><%= title %></h3>
            <span class="badge bg-info text-dark">
                <i class="fas fa-info-circle"></i> Status: <%= status %>
            </span>
        </div>

        <div>
            <a href="updateProject.jsp?id=<%= projectId %>" class="btn btn-warning btn-sm me-1">
                <i class="fas fa-edit"></i> Edit
            </a>

            <a href="<%=request.getContextPath()%>/DeleteProjectServlet?id=<%= projectId %>" 
               class="btn btn-danger btn-sm"
               onclick="return confirm('Are you sure you want to delete this project?');">
                <i class="fas fa-trash-alt"></i> Delete
            </a>
        </div>
    </div>

    <p><%= description %></p>

    <!-- IMAGE -->
    <h5 class="mt-3">Project Images:</h5>
    <div class="gallery">
    <%
    PreparedStatement psImg = con.prepareStatement(
        "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='image'");
    psImg.setInt(1, projectId);
    ResultSet rsImg = psImg.executeQuery();

    boolean hasImage = false;
    while(rsImg.next()){
        hasImage = true;
    %>
        <img src="<%=request.getContextPath()%>/ViewImageServlet?id=<%=rsImg.getInt("id")%>"
             data-name="<%=rsImg.getString("file_name")%>">
    <%
    }
    if(!hasImage){ %>
        <p class="text-muted">No images uploaded</p>
    <% }
    rsImg.close(); psImg.close();
    %>
    </div>

    <!-- PDF -->
    <h5 class="mt-3">Project PDFs:</h5>
    <div>
    <%
    PreparedStatement psPdf = con.prepareStatement(
        "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='pdf'");
    psPdf.setInt(1, projectId);
    ResultSet rsPdf = psPdf.executeQuery();

    boolean hasPDF = false;
    while(rsPdf.next()){
        hasPDF = true;
    %>
        <div class="d-flex mb-1 align-items-center">
            <a href="<%=request.getContextPath()%>/ViewPDFServlet?id=<%=rsPdf.getInt("id")%>" target="_blank" class="btn btn-primary btn-sm me-2">View</a>
            <a href="<%=request.getContextPath()%>/DownloadPDFServlet?id=<%=rsPdf.getInt("id")%>" class="btn btn-success btn-sm me-2">Download</a>
            <span><%=rsPdf.getString("file_name")%></span>
        </div>
    <%
    }
    if(!hasPDF){ %>
        <p class="text-muted">No PDFs uploaded</p>
    <% }
    rsPdf.close(); psPdf.close();
    %>
    </div>

    <!-- ⭐ UPDATED RATING SECTION -->
<h5 class="mt-3">Teacher Feedback & Ratings:</h5>
<div>
<%
PreparedStatement psC = con.prepareStatement(
    "SELECT c.comment, t.name FROM comments c JOIN teachers t ON c.teacher_id=t.id WHERE c.project_id=? ORDER BY c.id DESC"
);
psC.setInt(1, projectId);
ResultSet rsC = psC.executeQuery();

// ✅ Get rating ONCE (outside loop)
int rating = 0;
PreparedStatement psR = con.prepareStatement(
    "SELECT rating FROM projects WHERE id=?"
);
psR.setInt(1, projectId);
ResultSet rsR = psR.executeQuery();

if(rsR.next()){
    rating = rsR.getInt("rating");
}
rsR.close();
psR.close();

boolean hasComments = false;

while(rsC.next()){
    hasComments = true;

    String teacherName = rsC.getString("name");
    String comment = rsC.getString("comment");
%>

<div class="alert alert-info p-2 mb-2">
    <b><i class="fas fa-user"></i> <%=teacherName%>:</b><br>
    <%=comment%><br>

    <!-- ⭐ Rating -->
    <span class="rating">
    <% for(int i=0;i<rating;i++){ %>
        <i class="fas fa-star"></i>
    <% } %>
    <% for(int i=rating;i<5;i++){ %>
        <i class="far fa-star"></i>
    <% } %>
    </span>
</div>

<%
}
if(!hasComments){
%>
    <p class="text-muted small">No feedback yet</p>
<%
}
rsC.close(); psC.close();
%>
</div>

</div>

<%
    } else {
%>
    <div class="alert alert-warning">Project not found!</div>
<%
    }
    rs.close(); ps.close();
} catch(Exception e){
    out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
}
%>
</div>

<!-- IMAGE MODAL -->
<div id="imgModal" class="modal">
    <span class="nav-btn prev" onclick="prevImage()">❮</span>
    <span class="nav-btn next" onclick="nextImage()">❯</span>
    <img id="modalImg">
    <div class="modal-controls">
        <button class="btn btn-light btn-sm" onclick="zoomImage()">Zoom</button>
        <a id="downloadBtn" class="btn btn-success btn-sm" download>Download</a>
        <button class="btn btn-danger btn-sm" onclick="closeModal()">Close</button>
    </div>
</div>

<script>
let modalImages = [];
let currentIndex = 0;
let zoom = 1;

// Collect all gallery images
document.querySelectorAll('.gallery img').forEach((img, index) => {
    modalImages.push(img.src);
    img.setAttribute('data-index', index);
    img.onclick = () => openModal(index);
});

function openModal(index){
    currentIndex = index;
    document.getElementById("imgModal").style.display = "flex";
    showModalImage();
}

function showModalImage(){
    let img = document.getElementById("modalImg");
    img.src = modalImages[currentIndex];
    document.getElementById("downloadBtn").href = modalImages[currentIndex];
    img.style.transform = "scale(1)";
    zoom = 1;
}

function closeModal(){
    document.getElementById("imgModal").style.display = "none";
}

function nextImage(){
    currentIndex = (currentIndex + 1) % modalImages.length;
    showModalImage();
}

function prevImage(){
    currentIndex = (currentIndex - 1 + modalImages.length) % modalImages.length;
    showModalImage();
}

function zoomImage(){
    let img = document.getElementById("modalImg");
    zoom = zoom === 1 ? 2 : 1;
    img.style.transform = "scale(" + zoom + ")";
}
</script>

</body>
</html>