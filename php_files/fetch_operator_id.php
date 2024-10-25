<?php
header('Content-Type: application/json');

include 'db_connection.php'; // Ensure you have your DB connection

if (isset($_GET['OPERATOR_ID'])) {
    $operator_id = $_GET['OPERATOR_ID'];

    $sql = "SELECT * FROM OPERATOR WHERE OPERATOR_ID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $operator_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $operator_data = $result->fetch_assoc();
        echo json_encode([
            'status' => 'success',
            'data' => $operator_data
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Operator not found'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'OPERATOR_ID not provided'
    ]);
}

$conn->close();
?>
