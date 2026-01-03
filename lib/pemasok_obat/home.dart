import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'dart:convert';
import 'add.dart';
import 'detail.dart';

class PemasokObatHome extends StatefulWidget {
  const PemasokObatHome({super.key});

  @override
  State<PemasokObatHome> createState() => _PemasokObatHomeState();
}

class _PemasokObatHomeState extends State<PemasokObatHome> {
  List pemasokList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPemasok();
  }

  Future<void> fetchPemasok() async {
    try {
      final response = await http
          .get(Uri.parse('${apiBaseUrl()}/pemasok_obat/get_pemasok_obat.php'));

      if (response.statusCode == 200) {
        setState(() {
          pemasokList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load pemasok');
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pemasok Obat 🏭'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : ListView.builder(
              itemCount: pemasokList.length,
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
                      child:
                          Icon(Icons.location_city, color: colorScheme.primary),
                    ),
                    title: Text(
                      pemasokList[index]['nama_perusahaan'],
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      pemasokList[index]['no_kontak'],
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: colorScheme.primary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPemasokScreen(pemasok: pemasokList[index]),
                        ),
                      ).then((result) {
                        if (result == true) fetchPemasok();
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
            MaterialPageRoute(builder: (context) => const AddPemasokScreen()),
          ).then((_) => fetchPemasok());
        },
      ),
    );
  }
}
