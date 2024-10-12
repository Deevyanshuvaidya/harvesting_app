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

 ## sql queries

1) sshoperators----->
   CREATE TABLE sshoperators (
   id INT AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   email VARCHAR(255) NOT NULL,
   phone VARCHAR(15) NOT NULL,
   location VARCHAR(255) NOT NULL,
   industry_type VARCHAR(50) NOT NULL,
   industry_name VARCHAR(255),
   unique_id VARCHAR(50) NOT NULL,
   password VARCHAR(255) NOT NULL  -- Added column for storing the hashed password
   );


2) id controler----->

CREATE TABLE id_counter (
id INT AUTO_INCREMENT PRIMARY KEY,
last_number INT NOT NULL
);

INSERT INTO id_counter (last_number) VALUES (0); 


3) sshharvester-->
   CREATE TABLE sshharvester (
   id INT AUTO_INCREMENT PRIMARY KEY,
   location VARCHAR(255) NOT NULL,
   industry_type VARCHAR(50) NOT NULL,
   industry_name VARCHAR(255),
   unique_id VARCHAR(50) NOT NULL
   );

4) CREATE TABLE sshharop (
   id INT AUTO_INCREMENT PRIMARY KEY,
   harvester_id VARCHAR(50) NOT NULL,
   location VARCHAR(255) NOT NULL,
   industry_type VARCHAR(50) NOT NULL,
   industry_name VARCHAR(255),
   oprator_name VARCHAR(255),
   oprator_id VARCHAR(50) NOT NULL
   );
##
