import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_manager/theme_manager.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? theme = "system";
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              const SizedBox(width: 14),
              Text(
                "Farbthema",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          RadioListTile<String>.adaptive(
            value: "system",
            title: const Text("Systemeinstellung folgen"),
            groupValue: theme,
            onChanged: (value) {
              setState(() {
                theme = value ?? "system";
              });

              switch (value) {
                case "dark":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.dark);
                  return;
                case "light":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.light);
                  return;
                case "system":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.system);
                  return;
                default:
              }
            },
          ),
          RadioListTile<String>.adaptive(
            value: "dark",
            title: const Text("Dunkel"),
            groupValue: theme,
            onChanged: (value) {
              setState(() {
                theme = value ?? "system";
              });
              switch (value) {
                case "dark":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.dark);
                  return;
                case "light":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.light);
                  return;
                case "system":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.system);
                  return;
                default:
              }
            },
          ),
          RadioListTile<String>.adaptive(
            value: "light",
            title: const Text("Light"),
            groupValue: theme,
            onChanged: (value) {
              setState(() {
                theme = value ?? "system";
              });
              switch (value) {
                case "dark":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.dark);
                  return;
                case "light":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.light);
                  return;
                case "system":
                  ThemeManager.of(context)
                      .setBrightnessPreference(BrightnessPreference.system);
                  return;
                default:
              }
            },
          ),
          const Divider(),
          Row(
            children: [
              const SizedBox(width: 14),
              Text(
                "Dummys zum rumspielen",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          ListTile(
            leading: const Icon(MdiIcons.themeLightDark),
            title: const Text("Dropdown"),
            trailing: DropdownButton<String>(
              items: ["Item1", "Item2", "Item3"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
          ),
          CheckboxListTile.adaptive(
            value: isChecked,
            title: const Text("Checkbox"),
            onChanged: (value) => setState(() {
              isChecked = value;
            }),
          ),
          SwitchListTile.adaptive(
            value: isChecked!,
            title: const Text("Switch"),
            onChanged: (value) => setState(() {
              isChecked = value;
            }),
          ),
        ],
      ),
    );
  }
}
