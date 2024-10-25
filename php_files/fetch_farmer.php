<?php
header("Content-Type: application/json");
include 'db_connection.php';

if (isset($_GET['farmerId'])) {
    $farmerId = $_GET['farmerId'];

    $sql = "SELECT * FROM FARMER WHERE FARMER_ID = '$farmerId'";
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
