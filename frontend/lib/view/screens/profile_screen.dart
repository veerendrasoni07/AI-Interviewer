import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/auth_manager_provider.dart';
import 'package:frontend/provider/report_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/view/inner_nav_screen/inner_main_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final reports = ref.watch(reportProvider.notifier).totalReports;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF08160E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authManagerProvider.notifier).logout(context: context);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020A06),
                  Color(0xFF042112),
                  Color(0xFF0A3D24),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: user != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 3, 41, 22),
                          border: BoxBorder.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color.fromARGB(
                                255,
                                5,
                                58,
                                7,
                              ),
                              child: Icon(
                                CupertinoIcons.person_fill,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullname,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: 'Reports Generated',
                              value: '$reports',
                              icon: CupertinoIcons.doc_text_fill,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              title: 'Credits Left',
                              value: '${user.credits}',
                              icon: CupertinoIcons.creditcard_fill,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => InnerMainScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 33, 108, 71),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                          ),
                          icon: const Icon(
                            CupertinoIcons.cart_fill,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Buy Credits',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: Text("User is null")),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 3, 41, 22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.onPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
