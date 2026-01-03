import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';
import 'dart:convert';

class AddStockObatScreen extends StatefulWidget {
  const AddStockObatScreen({super.key});

  @override
  _AddStockObatScreenState createState() => _AddStockObatScreenState();
}

class _AddStockObatScreenState extends State<AddStockObatScreen> {
  late TextEditingController _jumlahObatMasukController;
  late TextEditingController _noRakObatController;
  late TextEditingController _kodePemesanController;
  late TextEditingController _namaPemesanController;
  late TextEditingController _jumlahPesananObatController;

  String? _selectedKodeObat;
  String? _selectedKodePerusahaan;
  String? _selectedJenisObat;
  List<dynamic> _listObat = [];
  List<dynamic> _listPemasok = [];

  DateTime? _tglObatMasuk;
  DateTime? _tglObatKeluar;

  @override
  void initState() {
    super.initState();
    _jumlahObatMasukController = TextEditingController();
    _noRakObatController = TextEditingController();
    _kodePemesanController = TextEditingController();
    _namaPemesanController = TextEditingController();
    _jumlahPesananObatController = TextEditingController();
    _fetchObat();
    _fetchPemasok();
  }

  Future<void> _fetchObat() async {
    final response = await http
        .get(Uri.parse('${apiBaseUrl()}/daftar_obat/get_all_obat.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listObat = json.decode(response.body);
      });
    }
  }

  Future<void> _fetchPemasok() async {
    final response = await http
        .get(Uri.parse('${apiBaseUrl()}/pemasok_obat/get_all_pemasok.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listPemasok = json.decode(response.body);
      });
    }
  }

  Future<void> _addStockObat() async {
    final response = await http.post(
      Uri.parse('${apiBaseUrl()}/stock_obat_in_out/add_stock_obat_in_out.php'),
      body: {
        'kode_obat': _selectedKodeObat,
        'jenis_obat': _selectedJenisObat,
        'kode_perusahaan': _selectedKodePerusahaan,
        'jumlah_obat_masuk': _jumlahObatMasukController.text,
        'no_rak_obat': _noRakObatController.text,
        'tgl_obat_masuk': _tglObatMasuk?.toIso8601String() ?? '',
        'kode_pemesan': _kodePemesanController.text,
        'nama_pemesan': _namaPemesanController.text,
        'jumlah_pesanan_obat': _jumlahPesananObatController.text,
        'tgl_obat_keluar': _tglObatKeluar?.toIso8601String() ?? '',
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
      contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: 12.0), // Menambahkan padding di sini
    );
  }

  Future<void> _selectDate(BuildContext context, bool isMasuk) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isMasuk
          ? (_tglObatMasuk ?? DateTime.now())
          : (_tglObatKeluar ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != (isMasuk ? _tglObatMasuk : _tglObatKeluar)) {
      setState(() {
        if (isMasuk) {
          _tglObatMasuk = picked;
        } else {
          _tglObatKeluar = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Stok Obat'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration:
                  _buildInputDecoration('Pilih Kode Obat', Icons.medication),
              initialValue: _selectedKodeObat,
              items: _listObat.map((obat) {
                return DropdownMenuItem<String>(
                  value: obat['kode_obat'].toString(),
                  child: Text(obat['nama_obat']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKodeObat = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: _buildInputDecoration(
                  'Pilih Kode Perusahaan', Icons.business),
              initialValue: _selectedKodePerusahaan,
              items: _listPemasok.map((pemasok) {
                return DropdownMenuItem<String>(
                  value: pemasok['kode_perusahaan'].toString(),
                  child: Text(pemasok['nama_perusahaan']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKodePerusahaan = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration:
                  _buildInputDecoration('Pilih Jenis Obat', Icons.category),
              initialValue: _selectedJenisObat,
              items: const [
                DropdownMenuItem(value: 'padat', child: Text('Padat')),
                DropdownMenuItem(value: 'cair', child: Text('Cair')),
                DropdownMenuItem(value: 'serbuk', child: Text('Serbuk')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedJenisObat = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahObatMasukController,
              decoration: _buildInputDecoration('Jumlah Obat Masuk', Icons.add),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noRakObatController,
              decoration: _buildInputDecoration('No RAK Obat', Icons.storage),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: AbsorbPointer(
                child: TextField(
                  decoration: _buildInputDecoration(
                      'Tgl Obat Masuk', Icons.calendar_today),
                  controller: TextEditingController(
                    text: _tglObatMasuk == null
                        ? ''
                        : "${_tglObatMasuk!.toLocal()}".split(' ')[0],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _kodePemesanController,
              decoration: _buildInputDecoration(
                  'Kode Pemesan', Icons.person_search_rounded),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _namaPemesanController,
              decoration:
                  _buildInputDecoration('Nama Pemesan', Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahPesananObatController,
              decoration: _buildInputDecoration(
                  'Jumlah Pesanan Obat', Icons.shopping_cart),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: AbsorbPointer(
                child: TextField(
                  decoration: _buildInputDecoration(
                      'Tgl Obat Keluar', Icons.calendar_today_outlined),
                  controller: TextEditingController(
                    text: _tglObatKeluar == null
                        ? ''
                        : "${_tglObatKeluar!.toLocal()}".split(' ')[0],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addStockObat,
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
