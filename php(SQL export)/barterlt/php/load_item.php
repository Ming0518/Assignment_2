<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
$number_of_result=0;
$number_of_page=0 ;
include_once("dbconnect.php");

$results_per_page = 4;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloaditems = "SELECT * FROM `info_items` WHERE id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditems = "SELECT * FROM `info_items` WHERE name LIKE '%$search%'";
}else{
	$sqlloaditems = "SELECT * FROM `info_items`";
    $result = $conn->query($sqlloaditems);
    $number_of_result = $result->num_rows;
    $number_of_page = ceil($number_of_result / $results_per_page);
    $sqlloaditems = $sqlloaditems . " LIMIT $page_first_result , $results_per_page";
}

$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $items["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['id'];
        $itemlist['item_name'] = $row['name'];
        //$itemlist['catch_type'] = $row['catch_type'];
        $itemlist['item_desc'] = $row['descrip'];
        $itemlist['item_value'] = $row['value'];
        //$itemlist['catch_qty'] = $row['catch_qty'];
        $itemlist['item_lat'] = $row['lat'];
        $itemlist['item_long'] = $row['longt'];
        $itemlist['item_state'] = $row['state'];
        $itemlist['item_locality'] = $row['locality'];
		$itemlist['item_date'] = $row['date'];
        $itemlist['user_phone'] = $row['phone'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",);
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
