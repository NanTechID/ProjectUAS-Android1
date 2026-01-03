import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class AddStafScreen extends StatefulWidget {
  const AddStafScreen({super.key});

  @override
  _AddStafScreenState createState() => _AddStafScreenState();
}

class _AddStafScreenState extends State<AddStafScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _tmpLahirController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  Future<void> _addStaf() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${apiBaseUrl()}/staf_apotek/add_staf.php'),
        body: {
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'tmp_lahir': _tmpLahirController.text,
          'no_hp': _noHpController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          await showSuccessDialog(
              context, result['message'] ?? 'Staf berhasil ditambahkan');
          if (mounted) Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result['message'] ?? 'Gagal menambahkan staf')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan staf')),
        );
      }
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
        title: const Text('Tambah Staf Apotek'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: _buildInputDecoration('Nama', Icons.person),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _alamatController,
                decoration: _buildInputDecoration('Alamat', Icons.home),
                validator: (value) => value == null || value.isEmpty
                    ? 'Alamat tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tglLahirController,
                decoration: _buildInputDecoration(
                    'Tanggal Lahir (TAHUN-BULAN-TANGGAL)',
                    Icons.calendar_today),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal lahir tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tmpLahirController,
                decoration:
                    _buildInputDecoration('Tempat Lahir', Icons.location_on),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tempat lahir tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _noHpController,
                decoration: _buildInputDecoration('No HP', Icons.phone),
                validator: (value) => value == null || value.isEmpty
                    ? 'No HP tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  textStyle: textTheme.titleSmall,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _addStaf,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
