import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/porter_state_service.dart';
import '../../widgets/driver_sos_modal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final profile = state.profile;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Driver Profile & Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 44,
              backgroundColor: primary,
              child: Text(
                profile.name.substring(0, 1),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              'Partner ID: ${profile.id} • ${profile.phone}',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 16),
                  SizedBox(width: 6),
                  Text('KYC & Vehicle Verified Partner', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Information Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _DriverProfileDetailRow(icon: Icons.electric_scooter_rounded, label: 'Vehicle Type', value: profile.vehicleType),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _DriverProfileDetailRow(icon: Icons.badge_rounded, label: 'Reg. Number', value: profile.vehicleNumber),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  const _DriverProfileDetailRow(icon: Icons.hub_rounded, label: 'Base Hub', value: 'Indiranagar Main Hub'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Performance & Ratings Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Partner Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _DriverProfileDetailRow(icon: Icons.star_rounded, label: 'Driver Rating', value: '${profile.rating} / 5.0 ★'),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _DriverProfileDetailRow(icon: Icons.check_circle_outline_rounded, label: 'Completed Deliveries', value: '${profile.completedTrips} Trips'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Audio Settings Card (Moved from Dashboard)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Audio Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.voiceGuidanceEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                            color: state.voiceGuidanceEnabled ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text('Voice Read-Aloud Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                        ],
                      ),
                      Switch(
                        value: state.voiceGuidanceEnabled,
                        activeTrackColor: const Color(0xFF10B981),
                        onChanged: (_) {
                          state.toggleVoiceGuidance();
                        },
                      ),
                    ],
                  ),
                  if (state.voiceGuidanceEnabled) ...[
                    const Divider(height: 16, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.translate_rounded, color: Color(0xFF94A3B8), size: 18),
                            const SizedBox(width: 12),
                            Text('Voice Language', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                          ],
                        ),
                        DropdownButton<String>(
                          value: state.selectedLanguage,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF059669), size: 18),
                          style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                          items: <String>['English', 'Hindi', 'Kannada'].map((String val) {
                            return DropdownMenuItem<String>(value: val, child: Text(val));
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              state.updateSelectedLanguage(newVal);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Emergency SOS Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  DriverSosModal.show(context);
                },
                icon: const Icon(Icons.sos_rounded, size: 24),
                label: const Text('EMERGENCY SOS & ROADSIDE HELP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out of Driver Partner Portal')),
                  );
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFF94A3B8)),
                label: const Text('Log Out', style: TextStyle(color: Color(0xFF64748B))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DriverProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
      ],
    );
  }
}
