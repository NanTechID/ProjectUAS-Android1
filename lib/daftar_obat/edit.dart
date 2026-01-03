import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';

class EditObatScreen extends StatefulWidget {
  final String kode_obat;
  final String nama_obat;
  final String stock;
  final String tgl_kadaluarsa;

  const EditObatScreen({
    super.key,
    required this.kode_obat,
    required this.nama_obat,
    required this.stock,
    required this.tgl_kadaluarsa,
  });

  @override
  _EditObatScreenState createState() => _EditObatScreenState();
}

class _EditObatScreenState extends State<EditObatScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaObatController;
  late TextEditingController _stockController;
  late TextEditingController _tglKadaluarsaController;

  @override
  void initState() {
    super.initState();
    _namaObatController = TextEditingController(text: widget.nama_obat);
    _stockController = TextEditingController(text: widget.stock);
    _tglKadaluarsaController =
        TextEditingController(text: widget.tgl_kadaluarsa);
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _stockController.dispose();
    _tglKadaluarsaController.dispose();
    super.dispose();
  }

  Future<void> _updateObat() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${apiBaseUrl()}/daftar_obat/edit_daftar_obat.php'),
        body: {
          'kode_obat': widget.kode_obat,
          'nama_obat': _namaObatController.text,
          'stock': _stockController.text,
          'tgl_kadaluarsa': _tglKadaluarsaController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          await showSuccessDialog(context, 'Obat berhasil diperbarui');
          if (mounted) Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui obat: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui obat')),
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
        title: const Text('Edit Obat'),
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
                controller: _namaObatController,
                decoration: _buildInputDecoration('Nama Obat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Obat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _stockController,
                decoration: _buildInputDecoration('Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tglKadaluarsaController,
                decoration: _buildInputDecoration('Tanggal Kadaluarsa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Kadaluarsa tidak boleh kosong';
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
                onPressed: _updateObat,
                child: const Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
