<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shstra_app2";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error)));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $OPERATOR_ID = $_POST['OPERATOR_ID'];  // Get the unique ID from the request

    // Query to fetch the operator details by unique_id
    $query = "SELECT OPERATOR_NAME, OPERATOR_ID, VILLAGE FROM OPERATOR WHERE OPERATOR_ID = '$OPERATOR_ID'";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        // Fetch the operator's details
        $row = $result->fetch_assoc();

        // Return success with data
        echo json_encode(array("status" => "success", "data" => $row));
    } else {
        // Return error if no user is found
        echo json_encode(array("status" => "error", "message" => "No user found"));
    }
}

$conn->close();
?>
