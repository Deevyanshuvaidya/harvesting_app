<?php
header('Content-Type: application/json');

// Database connection credentials
$host = 'localhost'; // Change as needed
$db = 'shstra_app2'; // Change as needed
$user = 'root'; // Change as needed
$pass = ''; // Change as needed

// Create connection
$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed.']));
}

// Get input data from Flutter app
$data = json_decode(file_get_contents("php://input"), true);
if (isset($data['harvestId']) && isset($data['disable'])) {
    $harvestId = $data['harvestId'];
    $disable = $data['disable']; // 0 for enable, 1 for disable

    // Prepare SQL statement to update the DISABLE column in the HARVEST table
    $sql = "UPDATE HARVEST SET DISABLE = ? WHERE HARVEST_ID = ?";
    $stmt = $conn->prepare($sql);
    
    if ($stmt) {
        $stmt->bind_param('is', $disable, $harvestId);

        // Execute the query and check if the update was successful
        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'State updated successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to update state.']);
        }
        $stmt->close();
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to prepare statement.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input data.']);
}

// Close the connection
$conn->close();
?>
