import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';

class StockObatViewHome extends StatefulWidget {
  const StockObatViewHome({super.key});

  @override
  _StockObatViewHomeState createState() => _StockObatViewHomeState();
}

class _StockObatViewHomeState extends State<StockObatViewHome> {
  List<dynamic> _listObat = [];
  List<dynamic> _listStock = [];
  String? selectedKodeObat;
  int jumlahStokMasuk = 0;
  int diRak = 0;
  int jumlahStokDipesan = 0;
  int sisaStok = 0;
  bool isButtonPressed = false; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    _fetchObat();
    _fetchStockObat();
  }

  Future<void> _fetchObat() async {
    final response = await http
        .get(Uri.parse('${apiBaseUrl()}/daftar_obat/get_all_obat.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listObat = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchStockObat() async {
    final response = await http.get(Uri.parse(
        '${apiBaseUrl()}/stock_obat_in_out/get_stock_obat_in_out.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listStock = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  void _calculateSisaStok() {
    if (selectedKodeObat == null || selectedKodeObat!.isEmpty) {
      setState(() {
        jumlahStokMasuk = 0;
        diRak = 0;
        jumlahStokDipesan = 0;
        sisaStok = 0;
        isButtonPressed = true;
      });
      return;
    }

    final matches = _listStock
        .where((item) => item['kode_obat']?.toString() == selectedKodeObat)
        .toList();

    setState(() {
      if (matches.isNotEmpty) {
        jumlahStokMasuk = matches.fold<int>(
            0,
            (sum, it) =>
                sum +
                (int.tryParse(it['jumlah_obat_masuk']?.toString() ?? '0') ??
                    0));
        diRak = matches.fold<int>(
            0,
            (sum, it) =>
                sum +
                (int.tryParse(it['no_rak_obat']?.toString() ?? '0') ?? 0));
        jumlahStokDipesan = matches.fold<int>(
            0,
            (sum, it) =>
                sum +
                (int.tryParse(it['jumlah_pesanan_obat']?.toString() ?? '0') ??
                    0));
      } else {
        jumlahStokMasuk = 0;
        diRak = 0;
        jumlahStokDipesan = 0;
      }

      sisaStok = jumlahStokMasuk - jumlahStokDipesan;
      isButtonPressed = true; // Setel ke true saat tombol "Cek" ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Stok Obat 🔎'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: const Text("Pilih Kode Obat"),
                  value: selectedKodeObat,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKodeObat = newValue;
                      isButtonPressed = false; // Reset saat pilihan berubah
                    });
                  },
                  items: _listObat.map<DropdownMenuItem<String>>((item) {
                    final kode = item['kode_obat']?.toString() ?? '';
                    return DropdownMenuItem<String>(
                      value: kode,
                      child: Text('$kode - ${item['nama_obat']}'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jumlah Stok Obat Masuk: $jumlahStokMasuk",
                            style: textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        Text("Di Rak: $diRak", style: textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        Text("Jumlah Stok Obat Dipesan: $jumlahStokDipesan",
                            style: textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        // Tampilkan "Sisa Stok Obat" hanya jika tombol "Cek" sudah ditekan
                        Visibility(
                          visible: isButtonPressed,
                          child: Text("Sisa Obat: $sisaStok",
                              style: textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateSisaStok,
                  child: const Text("Cek"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
