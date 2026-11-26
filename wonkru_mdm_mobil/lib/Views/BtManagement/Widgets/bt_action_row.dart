import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class BtActionRow extends StatelessWidget {
  const BtActionRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: WonkruColors.accent.withValues(alpha: 0.12),
        highlightColor: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: WonkruText.body(
                        15,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ).copyWith(height: 1.25),
                    ),
                    if (subtitle != null) ...[
                      4.hh,
                      Text(
                        subtitle!,
                        style: WonkruText.body(
                          13,
                          color: Colors.white60,
                        ).copyWith(height: 1.35),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}