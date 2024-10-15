<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error)));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $uniqueId = $_POST['unique_id'];

    $query = "SELECT name, unique_id, location FROM sshoperators WHERE unique_id = '$uniqueId'";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(array("status" => "success", "data" => $row));
    } else {
        echo json_encode(array("status" => "error", "message" => "No user found"));
    }

    $conn->close();
}
?>
