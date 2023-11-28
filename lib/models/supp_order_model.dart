import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thebrandsapp/widgets/snackbar.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  final String status;
  const SupplierOrderModel(
      {Key? key, required this.order, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldKey =
        GlobalKey<ScaffoldMessengerState>();
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(15)),
          child: ExpansionTile(
            title: Container(
              constraints: const BoxConstraints(maxHeight: 80),
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 80, maxWidth: 80),
                      child: Image.network(order['orderimage']),
                    ),
                  ),
                  Flexible(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(('\$ ') +
                                (order['orderprice'].toStringAsFixed(2))),
                            Text(('x ') + (order['orderqty'].toString()))
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('See More ..'),
                  Text(order['deliverystatus'])
                ]),
            children: [
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ('Name: ') + (order['custname']),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          ('Phone No.: ') + (order['phone']),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          ('Email Address: ') + (order['email']),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          ('Address: ') + (order['address']),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [
                            const Text(
                              ('Payment Status: '),
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              (order['paymentstatus']),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.purple),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              ('Delivery status: '),
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              (order['deliverystatus']),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.green),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              ('Order Date: '),
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              (DateFormat('yyyy-MM-dd')
                                  .format(order['orderdate'].toDate())
                                  .toString()),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.green),
                            ),
                          ],
                        ),
                        order['deliverystatus'] == 'delivered'
                            ? const Text('This order has been alreay delivered')
                            : Row(
                                children: [
                                  const Text(
                                    ('Change Delivery Status To: '),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  order['deliverystatus'] == 'preparing'
                                      ? TextButton(
                                          onPressed: () async {
                                            final DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 365)),
                                            );
                                            if (pickedDate != null) {
                                              await FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .doc(order['orderid'])
                                                  .update({
                                                'deliverystatus': 'shipping',
                                                'deliverydate': pickedDate,
                                              }).then((value) {
                                                Get.snackbar('Success',
                                                    'Order Shipped Successfully');
                                              });
                                            }
                                          },
                                          child: const Text('shipping ?'),
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order['orderid'])
                                                .update({
                                              'deliverystatus': 'delivered',
                                            }).then((value) {
                                              Get.snackbar('Success',
                                                  'Order Delivered Successfully');
                                            });
                                          },
                                          child: const Text('delivered ?'))
                                ],
                              ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
