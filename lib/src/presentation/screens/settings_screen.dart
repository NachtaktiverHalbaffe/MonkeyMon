import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_manager/theme_manager.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Text(
          "Einstellungen",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ListTile(
          leading: const Icon(MdiIcons.themeLightDark),
          title: const Text("Farbthema"),
          trailing: DropdownButton<String>(
            items: ["Dunkel", "Hell", "System"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              switch (value) {
                case "Dunkel":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.dark);
                  return;
                case "Hell":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.light);
                  return;
                case "System":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.system);
                  return;
                default:
              }

              ThemeManager.of(context)
                  .setBrightnessPreference(BrightnessPreference.dark);
            },
          ),
        )
      ],
    ));
  }
}
