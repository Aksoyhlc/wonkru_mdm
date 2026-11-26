import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class BtSectionCard extends StatelessWidget {
  const BtSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final pad = compact ? 12.0 : 20.0;
    final iconBox = compact ? 7.0 : 10.0;
    final iconSize = compact ? 20.0 : 24.0;
    final titleSize = compact ? 15.0 : 18.0;
    final afterTitle = compact ? 12.0 : 20.0;
    final gap = compact ? 10.0 : 14.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: WonkruColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(compact ? 14 : 18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(iconBox),
                decoration: BoxDecoration(color: WonkruColors.accentDim, borderRadius: BorderRadius.circular(compact ? 8 : 10)),
                child: Icon(icon, size: iconSize, color: WonkruColors.accent),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Text(
                  title,
                  style: WonkruText.body(titleSize, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.2),
                ),
              ),
            ],
          ),
          SizedBox(height: afterTitle),
          child,
        ],
      ),
    );
  }
}

class BtInfoRow extends StatelessWidget {
  const BtInfoRow({super.key, required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: WonkruColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(label, style: const TextStyle(fontSize: 12, color: Colors.white60)),
                const SizedBox(height: 2),
                SelectableText(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}