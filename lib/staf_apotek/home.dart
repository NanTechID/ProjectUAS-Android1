import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_app_apotek/config.dart';
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class StafHome extends StatefulWidget {
  const StafHome({super.key});

  @override
  _StafHomeState createState() => _StafHomeState();
}

class _StafHomeState extends State<StafHome> {
  List stafList = [];
  bool isLoading = true;

  Future<void> fetchStaf() async {
    try {
      final response =
          await http.get(Uri.parse('${apiBaseUrl()}/staf_apotek/get_staf.php'));

      if (response.statusCode == 200) {
        setState(() {
          stafList = json.decode(response.body);
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
    fetchStaf();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Staf Apotek 👨‍⚕️'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : ListView.builder(
              itemCount: stafList.length,
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
                      stafList[index]['nama'],
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      stafList[index]['no_hp'],
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailStafScreen(
                            id: stafList[index]['id'].toString(),
                            nama: stafList[index]['nama'],
                            alamat: stafList[index]['alamat'],
                            tglLahir: stafList[index]['tgl_lahir'],
                            tmpLahir: stafList[index]['tmp_lahir'],
                            noHp: stafList[index]['no_hp'],
                          ),
                        ),
                      ).then((result) {
                        if (result == true) fetchStaf();
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
            MaterialPageRoute(builder: (context) => const AddStafScreen()),
          ).then((result) {
            if (result == true) fetchStaf();
          });
        },
      ),
    );
  }
}
