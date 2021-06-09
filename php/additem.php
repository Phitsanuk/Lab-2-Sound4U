<?php
include_once("dbconnect.php");
$id = rand(1000,9999);
$items= $_POST['items'];
$size = $_POST['size'];
$numspeaker = $_POST['numspeaker'];
$dj = $_POST['dj'];
$price = $_POST['price'];
$datebooked = $_POST['datebooked'];

$sqlinsert = "INSERT INTO tbl_booking(id,items,size,,numspeaker,dj,price,datebooked) VALUE('$id','$items','$size','$numspeaker','$dj','$price','$datebooked')";
if ($conn->query($sqlinsert) === TRUE) {
    echo "You've success"; }
else {
    echo "Failed"; }
?>