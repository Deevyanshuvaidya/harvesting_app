<?php
header('Content-Type: application/json');
require 'db_connection.php'; // Include your database connection

// Get the JSON input
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['harvestId']) && isset($data['operatorId'])) {
    $harvestId = $data['harvestId'];
    $operatorId = $data['operatorId'];

    // Update the allocation_ssh table and set status to Available
    $query = "UPDATE allocation_ssh SET STATUS = 'Not Allocated' WHERE HARVEST_ID = ? AND OPERATOR_ID = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('ss', $harvestId, $operatorId);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Task marked as completed.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to update status.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input data.']);
}
?>
