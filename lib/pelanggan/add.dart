import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class AddPelangganScreen extends StatefulWidget {
  const AddPelangganScreen({super.key});

  @override
  _AddPelangganScreenState createState() => _AddPelangganScreenState();
}

class _AddPelangganScreenState extends State<AddPelangganScreen> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _alamatController = TextEditingController();
    _noHpController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> _addPelanggan() async {
    if (_namaController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _noHpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/pelanggan/add_pelanggan.php'),
      body: {
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'no_hp': _noHpController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        await showSuccessDialog(context, 'Data berhasil ditambahkan');
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menambahkan data: ${responseData['message'] ?? ''}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan data')),
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
        title: const Text('Tambah Pelanggan'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: _buildInputDecoration('Nama', Icons.person),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _alamatController,
              decoration: _buildInputDecoration('Alamat', Icons.home),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noHpController,
              decoration: _buildInputDecoration('No HP', Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addPelanggan,
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
