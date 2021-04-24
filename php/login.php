<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);

$sqllogin = "SELECT * FROM tbl_user WHERE email = '$email' AND password = '$passha1'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success";
    }
}else{
    echo "failed";
}

?>