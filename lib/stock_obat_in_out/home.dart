import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/utils/dialogs.dart';
import 'dart:convert';
import 'add.dart';

class StockObatHome extends StatefulWidget {
  const StockObatHome({super.key});

  @override
  _StockObatHomeState createState() => _StockObatHomeState();
}

class _StockObatHomeState extends State<StockObatHome> {
  List stockObatList = [];
  bool isLoading = true;

  Future<void> fetchStockObat() async {
    try {
      final response = await http.get(Uri.parse(
          '${apiBaseUrl()}/stock_obat_in_out/get_stock_obat_in_out.php'));

      if (response.statusCode == 200) {
        setState(() {
          stockObatList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error fetching data. Retry in 3 seconds...')),
      );
      await Future.delayed(const Duration(seconds: 3));
      fetchStockObat(); // Retry mechanism
    }
  }

  Future<void> deleteStockObat(String id) async {
    final response = await http.post(
      Uri.parse(
          '${apiBaseUrl()}/stock_obat_in_out/delete_stock_obat_in_out.php'),
      body: {'id_stock': id},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        await showSuccessDialog(context, 'Data berhasil dihapus');
        fetchStockObat(); // Refresh data after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menghapus data: ${responseData['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  void confirmDeleteStockObat(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Data Stok Obat'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteStockObat(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStockObat();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Obat In/Out 📦'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : ListView.builder(
              itemCount: stockObatList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.18),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    title: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.12),
                        child: Icon(Icons.local_pharmacy,
                            color: colorScheme.primary),
                      ),
                      title: Text(
                        stockObatList[index]['kode_obat']?.toString() ?? 'N/A',
                        style: textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        'Jumlah: ${stockObatList[index]['jumlah_obat_masuk'] ?? 0}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        onPressed: () {
                          confirmDeleteStockObat(
                              stockObatList[index]['id_stock'].toString());
                        },
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Informasi:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tanggal Masuk: ${stockObatList[index]['tgl_obat_masuk'] ?? 'N/A'}',
                              style: textTheme.bodyMedium,
                            ),
                            Text(
                              'Kode Pemesan: ${stockObatList[index]['kode_pemesan'] ?? 'N/A'}',
                              style: textTheme.bodyMedium,
                            ),
                            Text(
                              'Nama Pemesan: ${stockObatList[index]['nama_pemesan'] ?? 'N/A'}',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStockObatScreen()),
          ).then((result) {
            if (result == true) fetchStockObat();
          }); // Refresh data after adding
        },
      ),
    );
  }
}
