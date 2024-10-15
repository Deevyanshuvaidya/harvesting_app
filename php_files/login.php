<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error)));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];  // This can be either SSH unique ID or email
    $password = $_POST['password'];

    // Prepare SQL to check username (either SSH unique ID or email)
    $stmt = $conn->prepare("SELECT unique_id, email, password FROM sshoperators WHERE unique_id = ? OR email = ?");
    $stmt->bind_param("ss", $username, $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 1) {
        $row = $result->fetch_assoc();
        $hashedPassword = $row['password'];

        // Verify the password
        if (password_verify($password, $hashedPassword)) {
            echo json_encode(array("status" => "success", "message" => "Login successful", "unique_id" => $row['unique_id']));
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
