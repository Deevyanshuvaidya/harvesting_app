<?php
header('Content-Type: application/json');
include 'db_connection.php';

$operatorId = $_GET['operatorId'];

$query = "SELECT h.HARVEST_ID, h.OWNED_BY, h.DISABLE, s.location AS OPERATOR_LOCATION
          FROM HARVEST h
          JOIN sshoperators s ON h.OPERATOR_ID = s.OPERATOR_ID
          WHERE h.OPERATOR_ID = $operatorId";

$result = mysqli_query($conn, $query);

if (mysqli_num_rows($result) > 0) {
    $harvesters = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $harvesters[] = $row;
    }
    echo json_encode(['status' => 'success', 'data' => $harvesters]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No harvesters found for this operator']);
}
?>
