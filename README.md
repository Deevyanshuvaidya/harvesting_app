
# 🌾 Harvesting App

A Flutter-based mobile application prototype for managing harvesting-related operations, including operators, farmers, harvest records, allocations, authentication, and location-based information.

The application is built with **Flutter and Dart** and communicates with a **PHP/MySQL backend** through HTTP APIs.

---

# 📌 Project Status

**Harvesting App** is a prototype mobile application developed to demonstrate a harvesting-management workflow.

The application provides functionality for managing:

```text
✅ Flutter Mobile Application
✅ PHP Backend
✅ MySQL Database
✅ User Registration
✅ Login
✅ Password Recovery
✅ OTP Support
✅ Dashboard
✅ Operator Management
✅ Farmer Management
✅ Harvest Management
✅ Harvest Allocation
✅ Map / Location Integration
✅ Local Notifications
✅ Permission Handling
````

> **Note:** This project is a prototype/reference implementation and may require additional security, testing, configuration, and infrastructure work before being used in a production environment.

---

# 🎯 Project Overview

The **Harvesting App** is designed to demonstrate how a mobile application can be connected to a backend API and relational database to manage harvesting-related information.

The application follows a simple architecture:

```text
Flutter Mobile App
        │
        ▼
     HTTP APIs
        │
        ▼
    PHP Backend
        │
        ▼
    MySQL Database
```

The mobile application communicates with the PHP backend using HTTP requests, while MySQL is used for storing application data.

---

# ✨ Main Features

## 👤 User Registration

Users can register through the mobile application.

Registration information can include:

* Name
* Email
* Phone number
* Location
* Industry type
* Industry name
* Unique ID
* Password

After successful registration, the user information is stored in the database.

---

## 🔐 Login

Registered users can log in to the application using their credentials.

Basic workflow:

```text
Enter Credentials
       ↓
Send Request to API
       ↓
Validate User
       ↓
Authentication Successful
       ↓
Open Application Dashboard
```

---

## 🔑 Password Recovery

The application includes password-recovery functionality.

OTP-based verification can be used to verify the user before allowing password-related operations.

---

## 📧 OTP Support

The application uses OTP functionality for verification-related workflows.

The project includes the following Flutter dependency:

```yaml
email_otp: ^3.0.2
```

---

# 👨‍🌾 Farmer Management

The application provides functionality for managing farmer-related information.

Farmer information can include:

* Farmer ID
* Farmer name
* Location
* Survey number
* Village
* Taluka
* District
* Pincode
* Acre information
* Document data

The information is stored in the MySQL database and can be retrieved through the backend API.

---

# 🌱 Harvest Management

The application provides functionality for managing harvest records.

A harvest record can be associated with an operator and can contain information such as:

* Harvest ID
* Operator ID
* Ownership information
* Active/disabled status

---

# 🔄 Harvest Allocation

The application provides functionality for allocating harvest records to farmers.

An allocation can contain:

* Harvest ID
* Farmer ID
* Allocation date
* Allocation status

Basic workflow:

```text
Harvest
   ↓
Select Farmer
   ↓
Create Allocation
   ↓
Store Allocation
   ↓
View Allocation
```

---

# 🗺️ Map / Location Integration

The application includes location-related functionality that can be used to display or manage location information.

Map-related functionality can be extended to support:

* Farmer locations
* Harvest locations
* Operational areas
* Location-based information

---

# 🔔 Local Notifications

The application supports local notifications using Flutter notification functionality.

Notifications can be used for events such as:

* Application updates
* Harvest-related notifications
* Allocation updates
* Operational reminders

---

# 📱 Permission Handling

The project uses Flutter's permission-handling functionality to request and manage required device permissions.

This can be useful for features that require access to:

* Location
* Notifications
* Other device capabilities

---

# 🛠️ Technology Stack

| Technology          | Purpose                           |
| ------------------- | --------------------------------- |
| Flutter             | Cross-platform mobile application |
| Dart                | Application programming language  |
| PHP                 | Backend/API development           |
| MySQL               | Database                          |
| XAMPP               | Local development server          |
| phpMyAdmin          | Database management               |
| HTTP                | Frontend-backend communication    |
| Email OTP           | OTP verification                  |
| Local Notifications | Notification functionality        |
| Permission Handler  | Device permission management      |

---

# 🏗️ Application Architecture

The project follows a basic client-server architecture.

```text
                   MOBILE DEVICE
                        │
                        ▼
              ┌──────────────────┐
              │  Flutter App     │
              │                  │
              │  Dart            │
              │  UI              │
              │  Business Logic  │
              └────────┬─────────┘
                       │
                       │ HTTP Requests
                       ▼
              ┌──────────────────┐
              │   PHP APIs       │
              │                  │
              │ Authentication   │
              │ Farmer APIs      │
              │ Harvest APIs     │
              │ Allocation APIs  │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ MySQL Database   │
              │                  │
              │ Operators        │
              │ Farmers          │
              │ Harvests         │
              │ Allocations      │
              └──────────────────┘
```

---

# 📂 Project Structure

A simplified project structure is:

```text
harvesting-app/
│
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── services/
│   ├── models/
│   └── other Dart files
│
├── php_file/
│   ├── authentication APIs
│   ├── farmer APIs
│   ├── harvest APIs
│   └── allocation APIs
│
├── assets/
│
├── pubspec.yaml
│
└── README.md
```

> The exact structure may vary depending on the current version of the project.

---

# ⚙️ Local Development Setup

The backend of the prototype can be run locally using **XAMPP**.

The following setup is required:

```text
Flutter
+
XAMPP
+
Apache
+
MySQL
+
phpMyAdmin
```

---

# 🖥️ Prerequisites

Before running the application, make sure the following are installed:

### Required

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* Android Emulator or physical Android device
* XAMPP
* MySQL
* phpMyAdmin
* Git

---

# 🚀 Setup Instructions

## 1. Clone the Repository

```bash
git clone <repository-url>
```

Navigate into the project:

```bash
cd harvesting-app
```

---

# 2. Start XAMPP

Open the XAMPP Control Panel.

Start:

```text
Apache
MySQL
```

Both services should be running before using the backend and database.

```text
XAMPP
 ├── Apache  → START
 └── MySQL   → START
```

---

# 3. Configure the PHP Backend

Open the XAMPP installation directory.

On a default Windows installation:

```text
C:\xampp\
```

Open:

```text
C:\xampp\htdocs\
```

Create a new folder:

```text
C:\xampp\htdocs\harvesting_api\
```

Copy the PHP backend files from the project's PHP directory into:

```text
C:\xampp\htdocs\harvesting_api\
```

The final structure should look similar to:

```text
C:\xampp\htdocs\
│
└── harvesting_api\
    ├── login.php
    ├── signup.php
    ├── farmer APIs
    ├── harvest APIs
    ├── allocation APIs
    └── other PHP files
```

---

# 4. Open phpMyAdmin

Open your browser and visit:

```text
http://localhost/phpmyadmin/
```

phpMyAdmin provides a web interface for managing the MySQL database.

---

# 5. Create the Database

Create a database named:

```text
HARVESTING_APP
```

Then create the required tables using the SQL provided below.

---

# 🗄️ Database Structure

The application uses the following main tables:

```text
HARVESTING_APP
│
├── operators
│
├── farmers
│
├── harvests
│
├── id_counter
│
└── allocations
```

Relationship overview:

```text
Operators
    │
    │
    ▼
Harvests
    │
    │
    ▼
Allocations
    │
    │
    ▼
Farmers
```

---

# 🧾 SQL Database Setup

Use the following SQL to create the database and required tables.

```sql
CREATE DATABASE HARVESTING_APP;

USE HARVESTING_APP;


CREATE TABLE FARMERS(
    FARMER_ID INT PRIMARY KEY,
    FARMER_NAME VARCHAR(50),
    LOCATION VARCHAR(20),
    SURVEY_NO VARCHAR(50),
    DOC_DATA LONGBLOB,
    VILLAGE VARCHAR(20),
    TALUKA VARCHAR(20),
    DISTRICT VARCHAR(20),
    PINCODE VARCHAR(6),
    ACERS FLOAT
);


CREATE TABLE OPERATORS (
    OPERATOR_ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    location VARCHAR(255) NOT NULL,
    industry_type VARCHAR(50) NOT NULL,
    industry_name VARCHAR(255),
    unique_id VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);


CREATE TABLE HARVESTS(
    HARVEST_ID INT PRIMARY KEY,
    OPERATOR_ID INT,
    OWNED_BY VARCHAR(50),
    DISABLE BOOLEAN,
    FOREIGN KEY (OPERATOR_ID) REFERENCES OPERATORS(OPERATOR_ID)
);


CREATE TABLE ID_COUNTER (
    id INT AUTO_INCREMENT PRIMARY KEY,
    last_number INT NOT NULL
);


INSERT INTO ID_COUNTER (last_number) VALUES (0);


CREATE TABLE ALLOCATIONS(
    id INT AUTO_INCREMENT PRIMARY KEY,
    HARVEST_ID INT UNIQUE,
    FARMER_ID INT,
    ALLOCATION_DATE DATE,
    STATUS VARCHAR(30),
    FOREIGN KEY (HARVEST_ID) REFERENCES HARVESTS(HARVEST_ID),
    FOREIGN KEY (FARMER_ID) REFERENCES FARMERS(FARMER_ID)
);
```

---

# 🔗 Backend Connection

After configuring the PHP backend and database, the Flutter application needs to communicate with the local machine running XAMPP.

Find the API URLs or IP addresses used by the Dart files.

Replace the development IP address with the **IPv4 address of your computer**.

---

# 🌐 Find Your IPv4 Address

On Windows, open Command Prompt:

```bash
ipconfig
```

Look for:

```text
IPv4 Address
```

Example:

```text
IPv4 Address . . . . . . : 192.168.1.100
```

Use your own IPv4 address in the application's API configuration.

> Do not copy the example IP address above. Use the IPv4 address of the computer running the PHP backend.

---

# 📱 Physical Device Configuration

If the application is being tested on a physical Android device:

```text
Mobile Device
      │
      │ Wi-Fi / Network
      ▼
Computer
      │
      ▼
XAMPP
      │
      ▼
PHP API
      │
      ▼
MySQL
```

The mobile device and the computer running XAMPP should generally be connected to the same local network for direct local API communication.

---

# 📦 Flutter Dependencies

Make sure the required dependencies are available in `pubspec.yaml`.

Example:

```yaml
dependencies:
  flutter:
    sdk: flutter

  email_otp: ^3.0.2
  permission_handler:
  flutter_local_notifications:
  http:
```

After updating dependencies, run:

```bash
flutter pub get
```

---

# ▶️ Run the Application

After completing the backend, database, and Flutter configuration:

```bash
flutter pub get
```

Then check connected devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

You can run the application on:

* Android Emulator
* Physical Android Device
* Other supported Flutter platforms, depending on project configuration

---

# 👤 First-Time User Setup

When the application starts for the first time:

```text
Open Application
       ↓
Sign Up
       ↓
Enter User Information
       ↓
Submit Registration
       ↓
User Created
       ↓
Login
       ↓
Dashboard
```

After successful registration, the corresponding operator record should be created in the database.

---

# 🌾 Testing Harvest Data

For testing harvest-related screens, sample data may need to be inserted into the database.

The following tables are particularly important:

```text
HARVESTS
FARMERS
ALLOCATIONS
```

Sample/test records can be added through:

```text
phpMyAdmin
    ↓
HARVESTING_APP
    ↓
Select Table
    ↓
Insert
    ↓
Add Test Data
```

The Flutter application can then retrieve the data through the PHP APIs.

---

# 🔄 Application Workflow

The overall application workflow can be represented as:

```text
                    START
                      │
                      ▼
                Open Application
                      │
                      ▼
                 Registration
                      │
                      ▼
                  Login
                      │
                      ▼
                 Dashboard
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
       Farmers     Harvests   Allocations
          │           │           │
          └───────────┼───────────┘
                      │
                      ▼
              View / Manage Data
                      │
                      ▼
                     END
```

---

# 🧑‍🌾 Farmer Workflow

```text
Open Farmer Section
        ↓
Fetch Farmer Data
        ↓
Display Farmer Information
        ↓
View Location / Details
```

---

# 🌱 Harvest Workflow

```text
Open Harvest Section
        ↓
Fetch Harvest Records
        ↓
Display Harvest Information
        ↓
View Related Details
```

---

# 🔄 Allocation Workflow

```text
Select Harvest
      ↓
Select Farmer
      ↓
Create Allocation
      ↓
Set Allocation Date
      ↓
Set Status
      ↓
Save Allocation
```

---

# 🧪 Testing

Before considering the application ready for further use, test the following:

```text
[ ] Application starts successfully
[ ] Registration works
[ ] Login works
[ ] Password recovery works
[ ] OTP verification works
[ ] Dashboard loads correctly
[ ] Farmer data loads correctly
[ ] Harvest data loads correctly
[ ] Allocation data loads correctly
[ ] API requests work
[ ] Database connection works
[ ] Map/location functionality works
[ ] Notifications work
[ ] Required permissions work
```

---

# 🛠️ Troubleshooting

## Apache Is Not Running

Make sure Apache is started from XAMPP.

```text
XAMPP
  ↓
Apache
  ↓
Start
```

---

## MySQL Is Not Running

Start MySQL from the XAMPP Control Panel.

```text
XAMPP
  ↓
MySQL
  ↓
Start
```

---

## phpMyAdmin Not Opening

Verify that Apache and MySQL are running.

Then open:

```text
http://localhost/phpmyadmin/
```

---

## API Not Connecting From Mobile

Check:

1. Apache is running.
2. PHP files are inside the correct `htdocs` folder.
3. The computer's IPv4 address is correct.
4. The mobile device and computer are connected to the appropriate network.
5. The API URL in the Flutter application is correct.
6. Windows Firewall is not blocking the required connection.

---

## Database Error

Check:

```text
Database Name
Table Names
Column Names
MySQL Status
PHP Database Configuration
```

Make sure the database name and table structure match the application's PHP API configuration.

---

# 🔐 Security Considerations

This project is a prototype and should receive additional security improvements before production deployment.

Recommended improvements include:

* Password hashing
* Secure authentication
* Input validation
* Prepared SQL statements
* API authentication
* Authorization
* Secure API configuration
* Environment variables
* HTTPS
* Secure OTP implementation
* Rate limiting
* Error handling
* Database access restrictions
* Secure file/document handling

Do not store real production passwords or sensitive credentials directly in source code.

---

# 🔒 Sensitive Information

Do not commit the following information to a public repository:

```text
Database Passwords
API Keys
Private Tokens
Production Credentials
Personal Information
Private IP Addresses
Authentication Secrets
Production Database Information
```

Use environment-specific configuration for sensitive information.

---

# 🧠 Learning Outcomes

This project provides practical experience with:

* Flutter application development
* Dart programming
* Mobile UI development
* REST/API communication
* PHP backend development
* MySQL database management
* CRUD operations
* Authentication
* OTP verification
* Local notifications
* Permission handling
* Location-based functionality
* Database relationships
* Local development using XAMPP
* API integration
* Debugging
* Application testing

---

# 🏗️ Development Workflow

```text
Requirement Understanding
        ↓
Application Design
        ↓
Database Design
        ↓
Flutter UI Development
        ↓
PHP API Development
        ↓
MySQL Integration
        ↓
API Integration
        ↓
Testing
        ↓
Debugging
        ↓
Prototype Demonstration
```

---

# 📈 Future Improvements

The application can be extended with:

* Role-based authentication
* Advanced farmer management
* Advanced harvest management
* Real-time notifications
* Improved map functionality
* Document management
* Search and filtering
* Reports and analytics
* Cloud database
* Cloud API deployment
* Better security
* Automated testing
* Production deployment
* Admin dashboard
* Offline support
* Data synchronization

---

# 📌 Project Status

**Status: Prototype**

The application demonstrates a complete mobile-to-backend workflow using:

```text
📱 Flutter
      +
🎯 Dart
      +
🌐 PHP
      +
🗄️ MySQL
      +
🖥️ XAMPP
```

The project is suitable for learning, development, demonstration, and further extension.

---

# 👨‍💻 Developer

**Deevyanshu Vaidya**

GitHub:

[https://github.com/Deevyanshuvaidya](https://github.com/Deevyanshuvaidya)

---

# 📄 Copyright & Intellectual Property

© **2026 Deevyanshu Vaidya. All Rights Reserved.**

This project, including its original source code, application-specific implementation, architecture, documentation, database structure, and project-specific materials, is protected by applicable copyright and intellectual-property laws unless explicitly stated otherwise.

Unauthorized:

* Copying substantial portions of the source code
* Redistributing the project
* Publishing the project as your own work
* Claiming ownership of the original implementation
* Commercially using the project without permission
* Rebranding or republishing the project without authorization
* Creating derivative works from substantial portions of the project without authorization
* Removing copyright or attribution notices

may result in applicable copyright or intellectual-property issues.

Permission should be obtained from the applicable copyright holder before substantial reuse, redistribution, commercial usage, publication, or creation of derivative works.

### Third-Party Components

This project uses third-party technologies, frameworks, libraries, packages, and services.

Examples include:

* Flutter
* Dart
* PHP
* MySQL
* XAMPP
* phpMyAdmin
* Flutter packages
* Map-related services
* Notification libraries

Third-party components remain subject to their respective licenses, copyrights, and terms of use.

The project owner does not claim ownership of third-party software or services.

Users are responsible for complying with the applicable licenses and terms of third-party components.

---

# 📄 License

This project is **proprietary** and intended for educational, development, demonstration, portfolio, and authorized software-development use.

**All rights reserved unless explicitly stated otherwise by the project owner.**

No permission is granted to copy, modify, distribute, sublicense, publish, commercially exploit, or create derivative works from the project's original source code without explicit authorization from the applicable rights holder.

Third-party libraries, frameworks, dependencies, services, and other components remain governed by their respective licenses and terms.

Public availability of this repository does **not** automatically grant permission to reuse, modify, redistribute, or commercially exploit the original source code.

For licensing, redistribution, commercial usage, or permission requests, please contact the project owner.

---

# ⚠️ Disclaimer

This project is provided as a prototype for development, learning, demonstration, and authorized use.

The current implementation may contain:

* Development configurations
* Local API configurations
* Test data
* Environment-specific settings
* Prototype-level implementation
* Local network configurations
* Development dependencies

The application should not be considered production-ready without appropriate:

* Security review
* Testing
* Infrastructure configuration
* Database configuration
* API security
* Performance testing
* Data protection measures
* Production deployment configuration

Before deploying the application in a production environment, appropriate technical and security review should be performed.

---

# ⭐ Project Summary

**Harvesting App** is a Flutter-based mobile application prototype that demonstrates how a mobile application can communicate with a PHP backend and MySQL database.

The project brings together:

```text
📱 Flutter
      +
🎯 Dart
      +
🌐 PHP APIs
      +
🗄️ MySQL
      +
🖥️ XAMPP
      +
🗺️ Location Features
      +
🔐 Authentication
      +
📧 OTP
      +
🔔 Notifications
```

The application demonstrates practical implementation of mobile UI development, API integration, database management, authentication, farmer management, harvest management, and allocation workflows.

---

# 📌 Final Notice

This repository is provided for **development, educational, demonstration, and authorized use**.

All copyright, intellectual-property, licensing, and usage rights relating to the original project implementation remain with the applicable rights holder.

The project should not be interpreted as an open-source project merely because the repository is publicly accessible.

Any substantial reuse, redistribution, commercial use, publication, or derivative work should be performed only with appropriate authorization.

```
```
