<?php
header('Content-Type: application/json');

$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "shstra_app"; // Replace with your database name

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

$harvestId = $_GET['harvestId'];

$sql = "SELECT STATUS FROM ALLOCATION_SSH WHERE HARVEST_ID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $harvestId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(['status' => 'success', 'data' => $row]);
} else {
    echo json_encode(['status' => 'success', 'data' => ['STATUS' => 'Available']]);
}

$stmt->close();
$conn->close();
?>
