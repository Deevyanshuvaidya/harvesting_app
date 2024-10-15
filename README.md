# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Wellcome to this peoject----
## Colaborators Instructions--->
1) Make sure that you have xaamp downloaded in your system. If not download it.
2) Open Xaamp interface and start the appache and mysql server. And whenever you want to use database start both servers.
3) Now open your C drive(By default windows drive) and in this open xampp folder then open htdocs folder.
4) Now Create the new api_app_testing folder in htdocs folder.(C:\xampp\htdocs\api_app_testing)
5) And in this new api_app_testing folder paste all php files which are present in php_file folder in above repository .
6) Now Create the database open your browser and search "http://localhost/phpmyadmin/" the phpmyadmin interface is open
   and in it create database name "SHSTRA_APP" and in it create following tables using following query.
   i) first create sshoperators,FARMER, Harvest, and in last ALLOCATION_SSH.
   ii) then create id_counter and fire query 'insert' which is next to it only first time .
7) Now your database and php are set.
8) now open command prompt and run ipconfig and copy ipv4 address and replace it in all dart file with "192.168.142.35".
   (While running the above command in cmd make sure that you are conected to internet otherwiae it will not shown the ipv4 address)
   9)Now your connection setup is all done with database.
10) before running the app make sure you have all dependencies in "pubspec.yaml" file if not then install it or pubget it.
    dependencies required---->

    dependencies:
    flutter:
    sdk: flutter
    email_otp: ^3.0.2
    permission_handler:
    flutter_local_notifications:
    http:

11) now run the app on emulator or on physical device.
12) open the app in emulator or on physical device and first signup in it.
13) After succeful registration your sshoperators table get updated and and now you can log in.
14) now for myssh page first manually add the dummy data in database tables like harvest,Farmer,ALLOCATION_SSH table and then
    you can fetch it in your app. (Use phpmyadmin interface for updating the table in data base)






## SQl QUERY--->

CREATE DATABASE SHSTRA_APP;


CREATE TABLE FARMER(
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


CREATE TABLE sshoperators (
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



CREATE TABLE HARVEST(
HARVEST_ID INT PRIMARY KEY,
OPERATOR_ID INT,
OWNED_BY VARCHAR(50),
DISABLE BOOLEAN,
FOREIGN KEY (OPERATOR_ID) REFERENCES sshoperators(OPERATOR_ID)
);



CREATE TABLE id_counter (
id INT AUTO_INCREMENT PRIMARY KEY,
last_number INT NOT NULL
);
INSERT INTO id_counter (last_number) VALUES (0);



CREATE TABLE ALLOCATION_SSH(
id INT AUTO_INCREMENT PRIMARY KEY,
HARVEST_ID INT Unique,
FARMER_ID INT,
ALLOCATION_DATE DATE,
STATUS VARCHAR(30),
FOREIGN KEY (HARVEST_ID) REFERENCES HARVEST(HARVEST_ID),
FOREIGN KEY (FARMER_ID) REFERENCES FARMER(FARMER_ID)
);