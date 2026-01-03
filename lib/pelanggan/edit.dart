import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class EditPelangganScreen extends StatefulWidget {
  final String id;
  final String nama;
  final String alamat;
  final String noHp;

  const EditPelangganScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noHp,
  });

  @override
  _EditPelangganScreenState createState() => _EditPelangganScreenState();
}

class _EditPelangganScreenState extends State<EditPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _alamatController = TextEditingController(text: widget.alamat);
    _noHpController = TextEditingController(text: widget.noHp);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> _updatePelanggan() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${apiBaseUrl()}/pelanggan/edit_pelanggan.php'),
        body: {
          'id': widget.id,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'no_hp': _noHpController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          await showSuccessDialog(context, 'Data berhasil diperbarui');
          if (mounted) Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui data: ${responseData['message']}')),
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
        title: const Text('Edit Pelanggan'),
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
                onPressed: _updatePelanggan,
                child: const Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
