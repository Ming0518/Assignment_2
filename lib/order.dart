class Cart {
  String? orderId;
  String? itemId;
  String? itemName;
  String? itemDesc;
  String? itemVal;
  String? userId;
  String? sellerId;
  String? cartDate;

  Cart(
      {this.orderId,
      this.itemId,
      this.itemName,
      this.itemDesc,
      this.itemVal,
      this.userId,
      this.sellerId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    orderId = json['cart_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemDesc = json['item_desc'];
    itemVal = json['item_value'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = orderId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_desc'] = itemDesc;
    data['item_Val'] = itemVal;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['cart_date'] = cartDate;
    return data;
  }
}
