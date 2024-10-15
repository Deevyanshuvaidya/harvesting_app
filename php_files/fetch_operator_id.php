<?php
header('Content-Type: application/json');
include 'db_connection.php';

$uniqueId = $_GET['uniqueId'];

$query = "SELECT OPERATOR_ID FROM sshoperators WHERE unique_id = '$uniqueId'";
$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode(['status' => 'success', 'data' => $row]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Operator not found']);
}
?>
