import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class PelangganHome extends StatefulWidget {
  const PelangganHome({super.key});

  @override
  _PelangganHomeState createState() => _PelangganHomeState();
}

class _PelangganHomeState extends State<PelangganHome> {
  List pelangganList = [];
  bool isLoading = true;

  Future<void> fetchPelanggan() async {
    try {
      final response = await http
          .get(Uri.parse('${apiBaseUrl()}/pelanggan/get_pelanggan.php'));

      if (response.statusCode == 200) {
        setState(() {
          pelangganList = json.decode(response.body);
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
    fetchPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pelanggan 👤'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            )
          : ListView.builder(
              itemCount: pelangganList.length,
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
                      child: Icon(Icons.person, color: colorScheme.primary),
                    ),
                    title: Text(
                      pelangganList[index]['nama'],
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      pelangganList[index]['no_hp'],
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPelangganScreen(
                            id: pelangganList[index]['id'].toString(),
                            nama: pelangganList[index]['nama'],
                            alamat: pelangganList[index]['alamat'],
                            noHp: pelangganList[index]['no_hp'],
                          ),
                        ),
                      ).then((result) {
                        if (result == true) fetchPelanggan();
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
            MaterialPageRoute(builder: (context) => const AddPelangganScreen()),
          ).then((result) {
            if (result == true) fetchPelanggan();
          });
        },
      ),
    );
  }
}
