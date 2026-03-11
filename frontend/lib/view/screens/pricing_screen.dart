import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF08160E),
        foregroundColor: Colors.white,
        title: Text(
          'Pricing',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white70,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: 'Alpine'),
                  Tab(text: 'Pinnacle'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF020A06), Color(0xFF042112), Color(0xFF0A3D24)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildPricingCard(
                  planName: 'Alpine',
                  credits: '10 credits',
                  price: 'Rs 99 / month',
                  subtitle: 'Great for consistent interview practice',
                  features: const [
                    'AI voice interviews',
                    'Basic analytics',
                    'Session history',
                    '10 minute sessions'
                  ],
                  accent: const Color(0xFF7EF5AA),
                ),
                SizedBox(
                  child: _buildPricingCard(
                    planName: 'Pinnacle',
                    credits: '60 credits',
                    price: 'Rs 249 / month',
                    subtitle: 'Built for heavy prep and deep insights',
                    features: const [
                      'Everything in Alpine',
                      'Advanced performance insights',
                      'Priority processing',
                      '20 minute sessions'
                    ],
                    accent: const Color(0xFF9AD7FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String planName,
    required String credits,
    required String price,
    required String subtitle,
    required List<String> features,
    required Color accent,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.18),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  planName,
                  style: GoogleFonts.orbitron(
                    color: accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                credits,
                style: GoogleFonts.orbitron(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: 18,
                        color: accent,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.92),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: const Color(0xFF05110A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Choose $planName',
                    style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
