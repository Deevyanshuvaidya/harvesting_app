<?php
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed']));
}

if (isset($_GET['farmerId'])) {
    $farmerId = $_GET['farmerId'];

    $sql = "SELECT * FROM FARMER WHERE FARMER_ID = $farmerId";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $farmer = $result->fetch_assoc();
        echo json_encode(['status' => 'success', 'data' => $farmer]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No farmer found']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
}

$conn->close();
?>
