<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$buyer_phone = $_POST['phone'];
$email = $_POST['email'];
$name = $_POST['name'];

$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$userid' ORDER BY seller_id ASC";
$result = $conn->query($sqlcart);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $seller_id = $row['seller_id'];
        $itemid = $row['item_id'];
        $phone = $row['phone'];

        $sql = "INSERT INTO `tbl_order`(`buyer_id`, `seller_id`, `order_status`, `item_id`, `phone`, `buyer_phone`) VALUES ('$userid','$seller_id','New','$itemid','$phone','$buyer_phone')";

        if ($conn->query($sql) === TRUE) {
            $sqldeletecart = "DELETE FROM `tbl_carts` WHERE user_id = '$userid'";
            $conn->query($sqldeletecart);

            $response = array('status' => 'success', 'data' => $sql);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => $sql);
            sendJsonResponse($response);
        }
    }
} else {
    $response = array('status' => 'failed', 'data' => 'No items in cart');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
