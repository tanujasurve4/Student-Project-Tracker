# 🎓 Student Project Tracker

## 📌 Overview

**Student Project Tracker** is a Java-based web application designed to simplify project monitoring and communication between students and faculty.

It provides separate login portals for **Students** and **Teachers (Admin)**, allowing efficient project submission, review, feedback, and progress tracking throughout the academic session.

---

## 🎥 Project Demo

▶️ **[Watch Student Project Tracker Demo](https://drive.google.com/file/d/1R3-_QQXsM5oOcTwTag8ftXkhsgk0zHiE/view?usp=sharing)**


---

## ✨ Features

### 👨‍🎓 Student Module

- 🔐 Secure student login
- 📤 Upload project documents, images, and videos
- ✏️ Update project details throughout the project lifecycle
- 💬 View teacher comments and improvement suggestions
- ⭐ Check project ratings and review status
- 🔔 Receive notifications about deadlines and project updates
- 📥 Download project files and documentation
- 🔍 View uploaded images with zoom functionality

### 👨‍🏫 Admin / Teacher Module

- 🔐 Secure admin login
- 📋 View all submitted student projects
- 📊 Monitor project progress
- 📄 Review uploaded documents
- ⭐ Provide ratings and comments
- 💡 Suggest improvements
- 🔔 Send deadline notifications
- 🗂️ Manage project records and uploaded files

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| ☕ Java | Application development |
| ⚙️ Java Servlets | Backend processing |
| 🔗 JDBC | Database connectivity |
| 🗄️ MySQL | Database management |
| 🌐 HTML | Web page structure |
| 🎨 CSS | User interface styling |
| ⚡ JavaScript | Client-side functionality |
| 🐱 Apache Tomcat | Web application server |

---

## 📂 Main Files

- `AddProjectServlet.java` – Upload student projects
- `DeleteProjectServlet.java` – Delete project records
- `AddNoticeServlet.java` – Publish notices and deadlines
- `DeleteNoticeServlet.java` – Remove notices
- `AddCommentServlet.java` – Add teacher comments
- `DeleteCommentServlet.java` – Delete comments
- `DownloadPDFServlet.java` – Download project documents
- `DownloadImageServlet.java` – Download project images
- `DBConnection.java` – Database connectivity

---

## 🔄 How It Works

```text
              👨‍🎓 Student
                  │
                  ▼
          Student Login
                  │
                  ▼
        Upload Project Files
       /        |        \
   Documents  Images    Videos
                  │
                  ▼
          👨‍🏫 Teacher/Admin
                  │
                  ▼
        Review Student Project
                  │
          ┌───────┴────────┐
          ▼                ▼
       Rating           Feedback
          │                │
          └───────┬────────┘
                  ▼
        👨‍🎓 Student Views
       Comments & Suggestions
                  │
                  ▼
        Update Project
                  │
                  ▼
        Project Completion
