import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebrandsapp/dashboard_components/my_store.dart';
import 'package:thebrandsapp/main_screens/upload_product.dart';

import '../dashboard_components/supplier_orders.dart';
import '../providers/id_provider.dart';
import '../services/notifications_services.dart';
import 'dashboard.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> tabs = const [
    DashboardScreen(),
    UploadProductScreen(),
  ];

  String docId = '';

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'orders') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SupplierOrders()));
    }
  }

  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    super.initState();
    notificationsServices.getToken();
    notificationsServices.isTokenRefreshed();
    notificationsServices.requestPermission;
    setupInteractedMessage();
    docId = context.read<IdProvider>().getData;
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationsServices.displayNotification(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: docId)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            body: tabs[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              selectedItemColor: Colors.black,
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: context.read<IdProvider>().getData != ''
                      ? badges.Badge(
                          showBadge: snapshot.data!.docs.isEmpty ? false : true,
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.red,
                            padding: EdgeInsets.all(3),
                          ),
                          badgeAnimation:
                              const badges.BadgeAnimation.rotation(),
                          badgeContent: Text(
                            snapshot.data!.docs.length.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          child: const Icon(Icons.dashboard))
                      : const Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.upload),
                  label: 'Upload',
                ),
              ],
              onTap: (index) async {
                await FirebaseFirestore.instance
                    .collection('suppliers')
                    .doc(docId)
                    .get()
                    .then((value) {
                  debugPrint(value['status']);
                  setState(() {
                    if (index == 0) {
                      _selectedIndex = index;
                    } else {
                      if (value['status'] == 'active') {
                        _selectedIndex = index;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Your account is not approved yet',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  });
                });
              },
            ),
          );
        });
  }
}
