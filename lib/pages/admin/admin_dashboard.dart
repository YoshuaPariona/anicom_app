//lib/pages/admin/admin_dashboard.dart
import 'package:anicom_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:provider/provider.dart';

import 'admin_sidebar.dart';
import 'admin_form.dart';
import 'admin_table.dart';
import 'admin_controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final controller = AdminController();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: const Text("Panel de control"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),

      sideBar: adminSidebar(
        selected: controller.selectedCollection,
        onSelect: (collection) {
          setState(() {
            controller.setCollection(collection);
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AdminForm(controller: controller, refresh: () => setState(() {})),
            const SizedBox(height: 24),
            Expanded(child: AdminTable(controller: controller)),
          ],
        ),
      ),
    );
  }
}
