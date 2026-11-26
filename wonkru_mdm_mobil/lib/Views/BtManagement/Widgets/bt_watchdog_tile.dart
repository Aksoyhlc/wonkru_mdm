import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class BtWatchdogTile extends StatelessWidget {
  const BtWatchdogTile({
    super.key,
    required this.label,
    required this.running,
    required this.onStart,
    required this.onStop,
  });

  final String label;
  final bool running;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            running ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 20,
            color: running ? WonkruColors.green : Colors.white60,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            running ? L.bt_watchdog_running : L.bt_watchdog_stopped,
            style: TextStyle(fontSize: 12, color: Colors.white60),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: running ? onStop : onStart,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              running ? L.bt_watchdog_stop_btn : L.bt_watchdog_start_btn,
              style: TextStyle(
                fontSize: 12,
                color: running ? WonkruColors.red : WonkruColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}