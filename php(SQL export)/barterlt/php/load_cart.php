<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
//SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate FROM Orders INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `info_items` ON tbl_carts.item_id = info_items.item_id WHERE tbl_carts.user_id = '$userid'";
}

$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
    $cartitems["carts"] = array();
	while ($row = $result->fetch_assoc()) {
        $cartlist = array();
        $cartlist['cart_id'] = $row['cart_id'];
        $cartlist['item_id'] = $row['item_id'];
        $cartlist['user_id'] = $row['user_id'];
        $cartlist['seller_id'] = $row['seller_id'];
        $cartlist['cart_date'] = $row['cart_date'];
        $cartlist['item_name'] = $row['name'];
        $cartlist['item_desc'] = $row['descrip'];
        $cartlist['item_value'] = $row['value'];
        array_push($cartitems["carts"] ,$cartlist);
    }
    $response = array('status' => 'success', 'data' => $cartitems);
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