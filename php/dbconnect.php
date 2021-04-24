<?php
$servername = "localhost";
$username   = "crimsonw_sound4users";
$password   = "8P85E-b=(V61";
$dbname     = "crimsonw_sound4udb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>