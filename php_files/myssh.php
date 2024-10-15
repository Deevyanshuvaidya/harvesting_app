<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error)));
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $query = "SELECT name, email, phone, location, industry_type, industry_name, unique_id FROM sshoperators";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $operators = array();
        while ($row = $result->fetch_assoc()) {
            $operators[] = $row;
        }
        echo json_encode(array("status" => "success", "data" => $operators));
    } else {
        echo json_encode(array("status" => "error", "message" => "No operators found"));
    }
}

$conn->close();
?>
