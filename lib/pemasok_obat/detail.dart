import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';
import 'edit.dart';

class DetailPemasokScreen extends StatelessWidget {
  final Map<String, dynamic> pemasok;

  const DetailPemasokScreen({super.key, required this.pemasok});

  Future<void> deletePemasok(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/pemasok_obat/delete_pemasok_obat.php'),
      body: {
        'kode_perusahaan': pemasok['kode_perusahaan'].toString(),
      },
    );

    if (response.statusCode == 200) {
      await showSuccessDialog(context, 'Pemasok berhasil dihapus');
      if (Navigator.canPop(context)) Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus pemasok')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus pemasok ini?'),
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
                deletePemasok(context); // Hapus pemasok
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemasok'),
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
                Text('Detail Pemasok', style: textTheme.titleLarge),
                const SizedBox(height: 20),
                Text('Nama Perusahaan: ${pemasok['nama_perusahaan']}',
                    style: textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('Alamat Perusahaan: ${pemasok['alamat_perusahaan']}',
                    style: textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('Email: ${pemasok['email']}', style: textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('No Kontak: ${pemasok['no_kontak']}',
                    style: textTheme.bodyLarge),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPemasokScreen(pemasok: pemasok),
                          ),
                        ).then((result) {
                          if (result == true) Navigator.pop(context, true);
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Hapus'),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
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
}
