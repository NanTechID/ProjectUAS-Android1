import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class AddPemasokScreen extends StatefulWidget {
  const AddPemasokScreen({super.key});

  @override
  State<AddPemasokScreen> createState() => _AddPemasokScreenState();
}

class _AddPemasokScreenState extends State<AddPemasokScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noKontakController = TextEditingController();

  Future<void> addPemasok() async {
    if (namaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        emailController.text.isEmpty ||
        noKontakController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/pemasok_obat/add_pemasok_obat.php'),
      body: {
        'nama_perusahaan': namaController.text,
        'alamat_perusahaan': alamatController.text,
        'email': emailController.text,
        'no_kontak': noKontakController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        await showSuccessDialog(context, 'Data pemasok berhasil ditambahkan');
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menambahkan pemasok: ${responseData['message'] ?? ''}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan pemasok')),
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
        title: const Text('Tambah Pemasok Obat'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration:
                  _buildInputDecoration('Nama Perusahaan', Icons.business),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alamatController,
              decoration:
                  _buildInputDecoration('Alamat Perusahaan', Icons.location_on),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: _buildInputDecoration('Email', Icons.email),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noKontakController,
              decoration: _buildInputDecoration('No Kontak', Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: addPemasok,
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
