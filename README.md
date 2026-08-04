# Student Project Tracker

## Overview

Student Project Tracker is a Java-based web application designed to simplify project monitoring and communication between students and faculty. It provides separate login portals for students and teachers (admin), allowing efficient project submission, review, feedback, and progress tracking throughout the academic session.

## Features

### Student Module
- Secure student login
- Upload project documents, images, and videos
- Update project details throughout the project lifecycle
- View teacher comments and improvement suggestions
- Check project ratings and review status
- Receive notifications about deadlines and project updates
- Download project files and documentation
- View uploaded images with zoom functionality

### Admin (Teacher) Module
- Secure admin login
- View all submitted student projects
- Monitor project progress
- Review uploaded documents
- Provide ratings and comments
- Suggest improvements
- Send deadline notifications
- Manage project records and uploaded files

## Technologies Used

- Java
- Java Servlets
- JDBC
- MySQL
- HTML
- CSS
- JavaScript
- Apache Tomcat

## Main Files

- `AddProjectServlet.java` – Upload student projects
- `DeleteProjectServlet.java` – Delete project records
- `AddNoticeServlet.java` – Publish notices and deadlines
- `DeleteNoticeServlet.java` – Remove notices
- `AddCommentServlet.java` – Add teacher comments
- `DeleteCommentServlet.java` – Delete comments
- `DownloadPDFServlet.java` – Download project documents
- `DownloadImageServlet.java` – Download project images
- `DBConnection.java` – Database connectivity

## How It Works

1. Students log in to their portal.
2. Students upload project files, images, videos, and documentation.
3. Teachers log in through the admin portal.
4. Teachers review projects, monitor progress, assign ratings, and provide feedback.
5. Students view comments, ratings, and improvement suggestions.
6. Students update their projects based on teacher feedback until completion.

## Installation

1. Clone the repository.
2. Import the project into Eclipse or IntelliJ IDEA.
3. Configure Apache Tomcat.
4. Create the MySQL database.
5. Update database credentials in `DBConnection.java`.
6. Run the application on Tomcat.
7. Access the Student and Admin login pages.

## Future Enhancements

- Email notifications
- Dashboard with project analytics
- Search and filter projects
- Mobile-responsive interface
- Cloud file storage
- Authentication using JWT or OAuth

