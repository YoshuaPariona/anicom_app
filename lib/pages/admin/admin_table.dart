//lib/pages/admin/admin_table.dart
import 'package:anicom_app/pages/admin/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

void _launchURL(String url) async {
  if (!url.startsWith('http')) {
    url = 'https://$url';
  }
  try {
    final success = await launchUrlString(
      url,
      webOnlyWindowName: '_blank',
    );
    if (!success) {
      debugPrint('Could not launch $url');
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}

class AdminTable extends StatelessWidget {
  final AdminController controller;

  const AdminTable({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(controller.selectedCollection)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1000),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Imagen (link)')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final imagenLink = data['imagen'] ?? '';
                return DataRow(cells: [
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        data['nombre'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    imagenLink.isNotEmpty
                        ? InkWell(
                            onTap: () => _launchURL(imagenLink),
                            child: Text(
                              imagenLink,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const Text('Sin link'),
                  ),
                  DataCell(
                    SizedBox(
                      width: 250,
                      child: Text(
                        data['descripcion'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text('S/ ${data['precio'] ?? 0}')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            controller.editarDocumento(data, doc.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.eliminarDocumento(doc.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
