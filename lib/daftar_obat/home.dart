import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class DaftarObatHome extends StatefulWidget {
  const DaftarObatHome({super.key});

  @override
  _DaftarObatHomeState createState() => _DaftarObatHomeState();
}

class _DaftarObatHomeState extends State<DaftarObatHome> {
  List daftarObatList = [];
  bool isLoading = true;

  Future<void> fetchDaftarObat() async {
    try {
      final response = await http
          .get(Uri.parse('${apiBaseUrl()}/daftar_obat/get_daftar_obat.php'));

      if (response.statusCode == 200) {
        setState(() {
          daftarObatList = json.decode(response.body);
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
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDaftarObat();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Obat 💊'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            )
          : ListView.builder(
              itemCount: daftarObatList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.18),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.medical_services,
                          color: colorScheme.primary),
                    ),
                    title: Text(
                      daftarObatList[index]['nama_obat'],
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Stock: ${daftarObatList[index]['stock']}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Text(
                      'Exp: ${daftarObatList[index]['tgl_kadaluarsa']}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.error),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailObatScreen(
                            kodeObat:
                                daftarObatList[index]['kode_obat'].toString(),
                            namaObat: daftarObatList[index]['nama_obat'],
                            stock: daftarObatList[index]['stock'].toString(),
                            tglKadaluarsa: daftarObatList[index]
                                ['tgl_kadaluarsa'],
                          ),
                        ),
                      ).then((result) {
                        if (result == true) fetchDaftarObat();
                      });
                    },
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
            MaterialPageRoute(builder: (context) => const AddObatScreen()),
          ).then((result) {
            if (result == true) fetchDaftarObat();
          });
        },
      ),
    );
  }
}
