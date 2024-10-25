<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app2";

// Disable error reporting in production (optional)
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(E_ALL);

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error));
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];  // This can be either OPERATOR_ID or email
    $password = $_POST['password'];

    // Prepare SQL to check username (either OPERATOR_ID or email)
    $stmt = $conn->prepare("SELECT OPERATOR_ID, USERNAME, PASSWORD FROM OPERATOR WHERE OPERATOR_ID = ? OR USERNAME = ?");
    $stmt->bind_param("ss", $username, $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 1) {
        $row = $result->fetch_assoc();
        $storedPassword = $row['PASSWORD'];  // Retrieve the password from the database

        // Directly compare the provided password with the stored one (without hashing)
        if ($password === $storedPassword) {
            echo json_encode(array("status" => "success", "message" => "Login successful", "OPERATOR_ID" => $row['OPERATOR_ID']));
        } else {
            echo json_encode(array("status" => "error", "message" => "Invalid password"));
        }
    } else {
        echo json_encode(array("status" => "error", "message" => "User not found"));
    }

    $stmt->close();
}

$conn->close();
?>
