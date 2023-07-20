<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['buyerid'])){
	$buyerid = $_POST['buyerid'];	
	$sqlorder = "SELECT * FROM `tbl_order` WHERE buyer_id = '$buyerid'";
}

$result = $conn->query($sqlorder);
if ($result->num_rows > 0) {
    $oderitems["orders"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['buyer_id'] = $row['buyer_id'];
        $orderlist['seller_id'] = $row['seller_id'];
        $orderlist['order_date'] = $row['order_date'];
        $orderlist['order_status'] = $row['order_status'];
        $orderlist['item_id'] = $row['item_id'];
        $orderlist['seller_phone'] = $row['phone'];
        array_push($oderitems["orders"] ,$orderlist);
    }
    $response = array('status' => 'success', 'data' => $oderitems);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}