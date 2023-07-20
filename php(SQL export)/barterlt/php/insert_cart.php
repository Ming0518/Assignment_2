<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$item_id = $_POST['item_id'];
$userid = $_POST['userid'];
$sellerid = $_POST['sellerid'];
$phone = $_POST['phone'];

$sql = "INSERT INTO `tbl_carts`(`item_id`, `user_id`, `seller_id`,`phone`) VALUES ('$item_id','$userid','$sellerid','$phone')";

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>