<?php
header('Content-Type: application/json');

include 'db_connection.php'; // Ensure you have your DB connection

if (isset($_GET['harvestId']) && isset($_GET['operatorId'])) {
    $harvest_id = $_GET['harvestId'];
    $operator_id = $_GET['operatorId'];

    // Modify the SQL query to use both harvestId and operatorId
    $sql = "SELECT STATUS FROM ALLOCATION_SSH WHERE HARVEST_ID = ? AND OPERATOR_ID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $harvest_id, $operator_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            'status' => 'success',
            'data' => $row
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Status not found'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Required parameters not provided'
    ]);
}

$conn->close();
?>
