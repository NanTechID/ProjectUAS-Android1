import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';
import 'edit.dart';

class DetailStafScreen extends StatelessWidget {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String tmpLahir;
  final String noHp;

  const DetailStafScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.alamat,
    required this.tglLahir,
    required this.tmpLahir,
    required this.noHp,
  });

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus staf ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStaf(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStaf(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/staf_apotek/delete_staf.php'),
      body: {'id': id},
    );

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        await showSuccessDialog(context, 'Data berhasil dihapus');
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: ${result['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Staf'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(context, 'Nama', nama),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Alamat', alamat),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Tanggal Lahir', tglLahir),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Tempat Lahir', tmpLahir),
                const SizedBox(height: 12),
                _buildDetailRow(context, 'No HP', noHp),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditStafScreen(
                              id: id,
                              nama: nama,
                              alamat: alamat,
                              tglLahir: tglLahir,
                              tmpLahir: tmpLahir,
                              noHp: noHp,
                            ),
                          ),
                        ).then((result) {
                          if (result == true) Navigator.pop(context, true);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showDeleteConfirmationDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: textTheme.titleMedium,
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyLarge
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
