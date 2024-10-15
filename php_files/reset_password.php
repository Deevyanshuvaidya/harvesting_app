<?php
$host = 'localhost';
$user = 'root';
$pass = '';
$db = 'shstra_app';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$email = $_POST['email'];
$new_password = password_hash($_POST['password'], PASSWORD_DEFAULT);

$sql = "UPDATE sshoperators SET password='$new_password' WHERE email='$email'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Password updated successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error updating password: ' . $conn->error]);
}

$conn->close();
?>
