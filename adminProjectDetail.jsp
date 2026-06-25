<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    String name = (String) session.getAttribute("name");

    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))){
        response.sendRedirect("../index.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if(idStr == null || idStr.isEmpty()){
        out.println("<p class='alert alert-danger'>Invalid Project ID!</p>");
        return;
    }

    int projectId = Integer.parseInt(idStr);
%>

<!DOCTYPE html>
<html>
<head>
<title>Project Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body { background: #eef2f3; }

img { cursor:pointer; border-radius:5px; transition:0.3s; }
img:hover { transform: scale(1.1); }

.star-rating { display:flex; font-size:1.5rem; }
.star-rating input { display:none; }
.star-rating label { color:#ddd; cursor:pointer; }
.star-rating input:checked ~ label,
.star-rating label:hover,
.star-rating label:hover ~ label { color:#ffc107; }

/* 🔥 IMAGE MODAL */
#imgModal {
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
#imgModal img {
    max-width:80%;
    max-height:80%;
    border-radius:10px;
    transition: transform 0.3s ease;
}
.modal-controls { margin-top:15px; }
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
<div class="container mt-4">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4" 
     style="background: linear-gradient(90deg, #ff7e5f, #feb47b); box-shadow: 0 4px 6px rgba(0,0,0,0.2);">

    <div class="container-fluid">

        <!-- LEFT SIDE: Project Details -->
        <a class="navbar-brand fs-5 d-flex align-items-center">
            <i class="fas fa-project-diagram me-2"></i> Project Details
        </a>

        <!-- RIGHT SIDE -->
        <div class="d-flex align-items-center ms-auto">

            <!-- Professor Name -->
            <span class="text-white fw-bold me-3">
                <i class="fas fa-user me-1"></i> <%= name %>
            </span>

            <!-- Back Button -->
            <a href="<%=request.getContextPath()%>/jsp/viewAllProjects.jsp" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <!-- Logout Button -->
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>

        </div>

    </div>
</nav>

<%
try(Connection con = DBConnection.getConnection()){

PreparedStatement ps = con.prepareStatement(
"SELECT p.*, s.name AS student_name FROM projects p JOIN students s ON p.user_id=s.user_id WHERE p.id=?");
ps.setInt(1, projectId);
ResultSet rs = ps.executeQuery();

if(rs.next()){
%>

<div class="card p-4 shadow-sm">

<h3 class="text-primary"><%= rs.getString("title") %></h3>
<p><b>Student:</b> <%= rs.getString("student_name") %></p>
<p><b>Description:</b> <%= rs.getString("description") %></p>

<!-- ✅ IMAGES IN ONE ROW -->
<h5 class="mt-3">Project Images</h5>
<div class="d-flex overflow-auto" style="gap:10px; white-space:nowrap;">
<%
PreparedStatement psImg = con.prepareStatement(
"SELECT id,file_name FROM project_files WHERE project_id=? AND file_type='image'");
psImg.setInt(1, projectId);
ResultSet rsImg = psImg.executeQuery();

boolean hasImg=false;
while(rsImg.next()){
hasImg=true;
%>
<img src="<%=request.getContextPath()%>/ViewImageServlet?id=<%=rsImg.getInt("id")%>" 
     data-name="<%=rsImg.getString("file_name")%>" height="100" style="cursor:pointer; border-radius:5px;">
<% }
if(!hasImg){ %>
<p class="text-muted">No Images</p>
<% }
rsImg.close();
psImg.close();
%>
</div>

<!-- ✅ PDF -->
<h5 class="mt-3">Project PDFs</h5>
<%
PreparedStatement psPdf = con.prepareStatement(
"SELECT id,file_name FROM project_files WHERE project_id=? AND file_type='pdf'");
psPdf.setInt(1, projectId);
ResultSet rsPdf = psPdf.executeQuery();

boolean hasPdf=false;
while(rsPdf.next()){
hasPdf=true;
%>
<div class="mb-1">
<a href="<%=request.getContextPath()%>/ViewPDFServlet?id=<%=rsPdf.getInt("id")%>" class="btn btn-primary btn-sm">View</a>
<a href="<%=request.getContextPath()%>/DownloadPDFServlet?id=<%=rsPdf.getInt("id")%>" class="btn btn-success btn-sm">Download</a>
<%= rsPdf.getString("file_name") %>
</div>
<% }
if(!hasPdf){ %>
<p class="text-muted">No PDFs</p>
<% }
rsPdf.close();
psPdf.close();
%>

<!-- 🔥 UI SECTION (Status, Rating, Comments) -->
<div class="mt-4 p-4 border rounded bg-white shadow-sm">

<h5 class="text-primary">Project Status & Feedback</h5>

<form action="<%=request.getContextPath()%>/UpdateStatusServlet" method="post">
<input type="hidden" name="project_id" value="<%=projectId%>">

<select name="status" class="form-select mb-2">
<option>Planned</option>
<option>In Progress</option>
<option>Completed</option>
</select>

<%
int currentRating = rs.getInt("rating");   // ✅ get rating from DB
%>

<div class="star-rating mb-2">
<% for(int i=1;i<=5;i++){ %>
    <input type="radio" id="star<%=i%>" name="rating" value="<%=i%>" 
           <%= (currentRating == i) ? "checked" : "" %> />
    <label for="star<%=i%>">&#9733;</label>
<% } %>
</div>

<button class="btn btn-primary btn-sm">Update</button>
</form>

<!-- COMMENT -->
<form action="<%=request.getContextPath()%>/AddCommentServlet" method="post" class="mt-3">
<input type="hidden" name="project_id" value="<%=projectId%>">
<textarea name="comment" class="form-control mb-2" placeholder="Write feedback..." required></textarea>
<button class="btn btn-success btn-sm">Submit</button>
</form>

<!-- COMMENTS -->
<%
PreparedStatement psC = con.prepareStatement(
"SELECT c.id,c.comment,t.name FROM comments c JOIN teachers t ON c.teacher_id=t.id WHERE c.project_id=?");
psC.setInt(1, projectId);
ResultSet rsC = psC.executeQuery();

while(rsC.next()){
%>

<div class="alert alert-info d-flex justify-content-between">
<div><b><%=rsC.getString("name")%>:</b> <%=rsC.getString("comment")%></div>

<div>
<a href="<%=request.getContextPath()%>/jsp/editComment.jsp?id=<%=rsC.getInt("id")%>&project_id=<%=projectId%>" class="btn btn-warning btn-sm">✏️</a>

<a href="<%=request.getContextPath()%>/DeleteCommentServlet?id=<%=rsC.getInt("id")%>" 
   class="btn btn-danger btn-sm"
   onclick="return confirm('Delete this comment?');">🗑</a>
</div>
</div>

<% }
rsC.close();
psC.close();
%>

</div>
</div>

<%
}
}catch(Exception e){
out.println(e.getMessage());
}
%>

</div>

<!-- IMAGE MODAL -->
<div id="imgModal">
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
document.querySelectorAll('img[data-name]').forEach((img, index) => {
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