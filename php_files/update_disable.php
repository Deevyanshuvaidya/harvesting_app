<?php
header('Content-Type: application/json');
include 'db_connection.php';

$harvesterId = $_POST['harvester_id'];
$disable = $_POST['disable'];

$query = "UPDATE HARVEST SET DISABLE = $disable WHERE HARVEST_ID = $harvesterId";
if (mysqli_query($conn, $query)) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update status']);
}
?>
