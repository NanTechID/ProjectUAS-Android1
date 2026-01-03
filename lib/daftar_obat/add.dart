import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class AddObatScreen extends StatefulWidget {
  const AddObatScreen({super.key});

  @override
  AddObatScreenState createState() => AddObatScreenState();
}

class AddObatScreenState extends State<AddObatScreen> {
  final TextEditingController _namaObatController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _tglKadaluarsaController =
      TextEditingController();

  Future<void> _addObat() async {
    if (_namaObatController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _tglKadaluarsaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/daftar_obat/add_daftar_obat.php'),
      body: {
        'nama_obat': _namaObatController.text,
        'stock': _stockController.text,
        'tgl_kadaluarsa': _tglKadaluarsaController.text,
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        await showSuccessDialog(context, 'Data obat berhasil ditambahkan');
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menambahkan obat: ${responseData['message'] ?? ''}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan obat')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InputDecoration(
      labelText: labelText,
      labelStyle:
          textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      prefixIcon: Icon(icon, color: colorScheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Obat'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaObatController,
              decoration:
                  _buildInputDecoration('Nama Obat', Icons.medical_services),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stockController,
              decoration: _buildInputDecoration('Stock', Icons.storage),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tglKadaluarsaController,
              decoration: _buildInputDecoration(
                  'Tanggal Kadaluarsa (TAHUN-BULAN-TANGGAL)',
                  Icons.calendar_today),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addObat,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  textStyle: textTheme.titleSmall,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
