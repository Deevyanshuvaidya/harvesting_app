<?php
header('Content-Type: application/json');

include 'db_connection.php'; // Ensure you have your DB connection

if (isset($_GET['harvestId']) && isset($_GET['operatorId'])) {
    $harvest_id = $_GET['harvestId'];
    $operator_id = $_GET['operatorId'];

    $sql = "SELECT * FROM ALLOCATION_SSH WHERE HARVEST_ID = ? AND OPERATOR_ID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $harvest_id, $operator_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        $farmer_id = $row['FARMER_ID'];
        
        // Fetch farmer details based on FARMER_ID
        $farmer_sql = "SELECT * FROM FARMER WHERE FARMER_ID = ?";
        $farmer_stmt = $conn->prepare($farmer_sql);
        $farmer_stmt->bind_param("s", $farmer_id);
        $farmer_stmt->execute();
        $farmer_result = $farmer_stmt->get_result();
        $farmer_data = $farmer_result->fetch_assoc();

        echo json_encode([
            'status' => 'success',
            'data' => [
                'allocationDate' => $row['ALLOCATION_DATE'],
                'farmer' => $farmer_data
            ]
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Allocation details not found'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Harvest ID not provided'
    ]);
}

$conn->close();
?>
