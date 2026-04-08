import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) => AlertDialog(
        title: const Text('Ayarlar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Otomatik Yenileme'),
              value: settings.isAutoRefresh,
              onChanged: (value) {
                settings.setAutoRefresh(value);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Yenileme Aralığı'),
              subtitle: Text('${settings.refreshInterval} saniye'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (settings.refreshInterval > 1) {
                        settings.setRefreshInterval(settings.refreshInterval - 1);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      settings.setRefreshInterval(settings.refreshInterval + 1);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
