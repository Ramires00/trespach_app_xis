import 'address.dart';
import 'enum/order_takeout_type.dart';
import 'enum/payment_method.dart';
import 'product.dart';

class Order {
  Order({
    required this.customerName,
    required this.phoneNumber,
    this.address,
    required this.orderTotal,
    required this.orderTakeoutType,
    required this.products,
    required this.paymentMethod,
  });

  final String customerName;
  final String phoneNumber;
  final Address? address;
  final num orderTotal;
  final OrderTakeoutType orderTakeoutType;
  final List<Product> products;
  final PaymentMethod paymentMethod;
}
