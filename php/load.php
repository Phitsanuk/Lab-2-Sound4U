<?php
include_once("dbconnect.php");

$sqlloadpr ="SELECT * FROM tbl_item ORDER BY id DESC";
$result = $conn->query($sqlloadpr);

if($result ->num_rows >0){
    $response["Item"] = array();
    while ($row = $result -> fetch_assoc()){
        $itemList = array();
        $itemList[id] = $row['id'];
        $itemList[items] = $row['items'];
        $itemList[size] = $row['size'];
        $itemList[numspeaker] = $row['numspeaker'];
        $itemList[dj] = $row['dj'];
        $itemList[price] = $row['price'];
        array_push($response["Item"],$itemList);
    }
    echo json_encode($response);
}
else{
    echo "nodata";  }
    
?>