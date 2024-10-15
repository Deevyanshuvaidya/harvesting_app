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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $location = $_POST['location'];
    $industry_type = $_POST['industry_type'];
    $industry_name = $_POST['industry_name'];
    $password = $_POST['password'];  // Capture the password from the POST request

    // Hash the password before storing it
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    // Begin transaction
    $conn->begin_transaction();
    try {
        // Fetch and update the last number
        $result = $conn->query("SELECT last_number FROM id_counter ORDER BY id DESC LIMIT 1");
        $row = $result->fetch_assoc();
        $last_number = $row['last_number'];
        $new_number = $last_number + 1;

        $conn->query("UPDATE id_counter SET last_number = $new_number");

        // Generate unique ID
        $unique_id = sprintf("OPRATER%03d%s", $new_number, substr($phone, -4));

        // Check if the user already exists
        $checkQuery = "SELECT * FROM sshoperators WHERE email = '$email' OR phone = '$phone'";
        $checkResult = $conn->query($checkQuery);

        if ($checkResult->num_rows > 0) {
            echo json_encode(array("status" => "error", "message" => "User already exists"));
        } else {
            $insertQuery = "INSERT INTO sshoperators (name, email, phone, location, industry_type, industry_name, unique_id, password)
                            VALUES ('$name', '$email', '$phone', '$location', '$industry_type', '$industry_name', '$unique_id', '$hashedPassword')";

            if ($conn->query($insertQuery) === TRUE) {
                echo json_encode(array("status" => "success", "message" => "Registration successful"));
            } else {
                echo json_encode(array("status" => "error", "message" => "Error: " . $conn->error));
            }
        }

        $conn->commit();
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(array("status" => "error", "message" => "Error: " . $e->getMessage()));
    }

    $conn->close();
}
?>
