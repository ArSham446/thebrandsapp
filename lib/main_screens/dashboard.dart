import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebrandsapp/dashboard_components/warning.dart';
import '../dashboard_components/manage_products.dart';
import '../dashboard_components/supplier_balance.dart';
import '../dashboard_components/supplier_orders.dart';
import '../dashboard_components/supplier_statics.dart';
import '../minor_screens/visit_store.dart';
import '../providers/auht_repo.dart';
import '../providers/id_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';

List<String> label = [
  'my store',
  'Orders',
  'Manage products',
  'balance',
  'Statics',
  'Warning'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.attach_money,
  Icons.show_chart,
  Icons.warning_rounded
];

List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  ManageProducts(),
  const Balance(),
  const Statics(),
  const Warning(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  clearUserId(BuildContext context) {
    context.read<IdProvider>().clearSupplierId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
              tooltip: 'Logout',
              onPressed: () {
                MyAlertDilaog.showMyDialog(
                    context: context,
                    title: 'Log Out',
                    content: 'Are you sure to log out ?',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      await AuthRepo.logOut()
                          .whenComplete(() => clearUserId(context))
                          .whenComplete(() => Navigator.pop(context));
                      Navigator.pushReplacementNamed(
                          context, '/supplier_login');
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.orange,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
                elevation: 5,
                color: Colors.orange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 45,
                      color: Colors.white,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          fontFamily: 'Acme'),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
