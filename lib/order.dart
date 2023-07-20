class Order {
  String? orderId;
  String? buyerId;
  String? sellerId;
  String? orderDate;
  String? orderStatus;
  String? itemId;
  String? sellerPhone;
  String? buyerPhone;

  Order(
      {this.orderId,
      this.buyerId,
      this.sellerId,
      this.orderDate,
      this.orderStatus,
      this.itemId,
      this.sellerPhone,
      this.buyerPhone});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    itemId = json['item_id'];
    sellerPhone = json['seller_phone'];
    buyerPhone = json['buyer_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['item_id'] = itemId;
    data['seller_phone'] = sellerPhone;
    data['buyer_phone'] = buyerPhone;

    return data;
  }
}
