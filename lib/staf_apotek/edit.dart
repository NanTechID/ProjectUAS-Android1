import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class EditStafScreen extends StatefulWidget {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String tmpLahir;
  final String noHp;

  const EditStafScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.alamat,
    required this.tglLahir,
    required this.tmpLahir,
    required this.noHp,
  });

  @override
  _EditStafScreenState createState() => _EditStafScreenState();
}

class _EditStafScreenState extends State<EditStafScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _tglLahirController;
  late TextEditingController _tmpLahirController;
  late TextEditingController _noHpController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _alamatController = TextEditingController(text: widget.alamat);
    _tglLahirController = TextEditingController(text: widget.tglLahir);
    _tmpLahirController = TextEditingController(text: widget.tmpLahir);
    _noHpController = TextEditingController(text: widget.noHp);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _tglLahirController.dispose();
    _tmpLahirController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> _updateStaf() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${apiBaseUrl()}/staf_apotek/edit_staf.php'),
        body: {
          'id': widget.id,
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
          await showSuccessDialog(context, 'Data berhasil diperbarui');
          if (mounted) Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Gagal memperbarui data: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InputDecoration(
      labelText: labelText,
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
      labelStyle:
          textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Staf Apotek'),
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
                decoration: _buildInputDecoration('Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _alamatController,
                decoration: _buildInputDecoration('Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tglLahirController,
                decoration: _buildInputDecoration(
                    'Tanggal Lahir (TAHUN-BULAN-TANGGAL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tmpLahirController,
                decoration: _buildInputDecoration('Tempat Lahir'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tempat lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _noHpController,
                decoration: _buildInputDecoration('No HP'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  textStyle: textTheme.titleSmall,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _updateStaf,
                child: const Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
