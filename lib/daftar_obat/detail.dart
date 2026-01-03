import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';
import 'edit.dart';

class DetailObatScreen extends StatefulWidget {
  final String kodeObat;
  final String namaObat;
  final String stock;
  final String tglKadaluarsa;

  const DetailObatScreen({
    super.key,
    required this.kodeObat,
    required this.namaObat,
    required this.stock,
    required this.tglKadaluarsa,
  });

  @override
  _DetailObatScreenState createState() => _DetailObatScreenState();
}

class _DetailObatScreenState extends State<DetailObatScreen> {
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
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
                _deleteObat();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteObat() async {
    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/daftar_obat/delete_daftar_obat.php'),
      body: {'kode_obat': widget.kodeObat},
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      await showSuccessDialog(context, 'Data berhasil dihapus');
      if (mounted) Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Obat'),
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
                Text('Detail Obat', style: textTheme.titleLarge),
                const SizedBox(height: 20),
                Text('Nama Obat: ${widget.namaObat}',
                    style: textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('Stock: ${widget.stock}', style: textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('Tanggal Kadaluarsa: ${widget.tglKadaluarsa}',
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
                            builder: (context) => EditObatScreen(
                              kode_obat: widget.kodeObat,
                              nama_obat: widget.namaObat,
                              stock: widget.stock,
                              tgl_kadaluarsa: widget.tglKadaluarsa,
                            ),
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
                        _showDeleteConfirmationDialog();
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
