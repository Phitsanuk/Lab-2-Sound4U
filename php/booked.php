<?php
include_once("dbconnect.php");

$sqlloadpr ="SELECT * FROM tbl_booking ORDER BY datebooked DESC";
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
        $itemList[datebooked] = $row['datebooked'];
        array_push($response["Item"],$itemList);
    }
    echo json_encode($response);
}
else{
    echo "nodata";  }
    
?>