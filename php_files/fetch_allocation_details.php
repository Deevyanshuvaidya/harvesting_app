<?php
header('Content-Type: application/json');
include 'db_connection.php';

if (isset($_GET['harvestId'])) {
    $harvestId = $_GET['harvestId'];

    // Fetch allocation details
    $allocationQuery = "SELECT FARMER_ID, ALLOCATION_DATE FROM ALLOCATION_SSH WHERE HARVEST_ID = ?";
    $stmt = $conn->prepare($allocationQuery);
    $stmt->bind_param("i", $harvestId);
    $stmt->execute();
    $allocationResult = $stmt->get_result();
    
    if ($allocationResult->num_rows > 0) {
        $allocationRow = $allocationResult->fetch_assoc();
        $farmerId = $allocationRow['FARMER_ID'];
        $allocationDate = $allocationRow['ALLOCATION_DATE'];

        // Fetch farmer details
        $farmerQuery = "SELECT * FROM FARMER WHERE FARMER_ID = ?";
        $stmt = $conn->prepare($farmerQuery);
        $stmt->bind_param("i", $farmerId);
        $stmt->execute();
        $farmerResult = $stmt->get_result();

        if ($farmerResult->num_rows > 0) {
            $farmerDetails = $farmerResult->fetch_assoc();

            echo json_encode([
                'status' => 'success',
                'data' => [
                    'allocationDate' => $allocationDate,
                    'farmer' => $farmerDetails
                ]
            ]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Farmer not found.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No allocation found for this harvester.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Harvester ID is required.']);
}

?>
