import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uts_app_apotek/config.dart';
import 'package:uts_app_apotek/pemasok_obat/home.dart';
import 'stock_obat_in_out/home.dart';
import 'pelanggan/home.dart';
import 'staf_apotek/home.dart';
import 'daftar_obat/home.dart';
import 'stock_obat_view_search/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0FB47C),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Apotek NanTech.ID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.2,
            color: Color(0xFF0F172A),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
          ),
        ),
        textTheme: ThemeData.light()
            .textTheme
            .apply(
              bodyColor: const Color(0xFF0F172A),
              displayColor: const Color(0xFF0F172A),
            )
            .copyWith(
              titleLarge: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: -0.2,
              ),
              titleMedium: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              bodyLarge: const TextStyle(fontSize: 15, height: 1.6),
              bodyMedium: const TextStyle(fontSize: 14, height: 1.5),
            ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        dividerColor: colorScheme.outlineVariant,
        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          labelStyle: TextStyle(color: colorScheme.onSurface),
          selectedColor: colorScheme.primary.withValues(alpha: 0.25),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (kDebugMode)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: apiBaseUrl()));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('API base URL copied to clipboard')),
                        );
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black87.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.developer_mode,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'API: ${apiBaseUrl()}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.local_hospital_rounded,
                  color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apotek NanTech.ID', style: textTheme.titleMedium),
                Text(
                  'Dashboard utama',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.08),
                colorScheme.secondary.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.03),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelola operasional apotek dalam satu tempat.',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.verified_rounded,
                              color: colorScheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Akses cepat ke modul obat, pelanggan, pemasok, dan stok.',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildMenuCard(
                        context,
                        icon: Icons.medical_services,
                        title: 'Daftar Obat',
                        gradient: [
                          colorScheme.primary,
                          colorScheme.primaryContainer,
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DaftarObatHome()),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.people,
                        title: 'Pelanggan',
                        gradient: [
                          colorScheme.secondary,
                          colorScheme.secondaryContainer,
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PelangganHome()),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.person,
                        title: 'Staf Apotek',
                        gradient: [
                          colorScheme.tertiary,
                          colorScheme.tertiaryContainer,
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StafHome()),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.location_city_outlined,
                        title: 'Pemasok Obat',
                        gradient: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PemasokObatHome()),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.medical_information_sharp,
                        title: 'Stok Obat',
                        gradient: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.7),
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StockObatHome()),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.manage_search,
                        title: 'Search & View Stock Obat',
                        gradient: [
                          colorScheme.secondary,
                          colorScheme.secondary.withValues(alpha: 0.75),
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StockObatViewHome()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shadowColor: colorScheme.primary.withValues(alpha: 0.18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleMedium
                    ?.copyWith(color: Colors.white, height: 1.3),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_outward_rounded,
                      size: 18, color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 4),
                  Text(
                    'Buka',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
