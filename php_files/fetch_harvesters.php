<?php
header('Content-Type: application/json');

include 'db_connection.php'; // Ensure you have your DB connection

if (isset($_GET['operatorId'])) {
    $operator_id = $_GET['operatorId'];

    $sql = "SELECT HARVEST_ID, OPERATOR_ID, OPERATOR_NAME,DISABLE FROM HARVEST WHERE OPERATOR_ID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $operator_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $harvesters = [];
    while ($row = $result->fetch_assoc()) {
        $harvesters[] = $row;
    }

    echo json_encode([
        'status' => 'success',
        'data' => $harvesters
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Operator ID not provided'
    ]);
}

$conn->close();
?>
