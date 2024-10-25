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
if (isset($data['harvestId']) && isset($data['operatorId']) && isset($data['disable'])) {
    $harvestId = $data['harvestId'];
    $operatorId = $data['operatorId']; // Added operator ID
    $disable = $data['disable']; // 0 for enable, 1 for disable

    // Prepare SQL statement to update the DISABLE column in the HARVEST table based on both HARVEST_ID and OPERATOR_ID
    $sql = "UPDATE HARVEST SET DISABLE = ? WHERE HARVEST_ID = ? AND OPERATOR_ID = ?";
    $stmt = $conn->prepare($sql);
    
    if ($stmt) {
        $stmt->bind_param('iss', $disable, $harvestId, $operatorId); // Bind operatorId as well

        // Execute the query and check if the update was successful
        if ($stmt->execute()) {
            // If DISABLE is 0 (enabled), update the STATUS in the allocation_ssh table
            if ($disable == 0) {
                $sqlUpdateStatus = "UPDATE allocation_ssh SET STATUS = 'Not Allocated' WHERE HARVEST_ID = ? AND OPERATOR_ID = ?";
                $stmtUpdateStatus = $conn->prepare($sqlUpdateStatus);

                if ($stmtUpdateStatus) {
                    $stmtUpdateStatus->bind_param('ss', $harvestId, $operatorId);

                    if ($stmtUpdateStatus->execute()) {
                        echo json_encode(['status' => 'success', 'message' => 'State updated and allocation set to Not Allocated.']);
                    } else {
                        echo json_encode(['status' => 'error', 'message' => 'Failed to update allocation status.']);
                    }

                    $stmtUpdateStatus->close();
                } else {
                    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare allocation status statement.']);
                }
            } else {
                echo json_encode(['status' => 'success', 'message' => 'State updated successfully.']);
            }
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
