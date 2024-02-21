import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';
import 'package:permission_handler/permission_handler.dart';

Future<(MonkeyDto?, File?)> editMonkeyModalBottomSheet(
    {required BuildContext context, MonkeyDto? initialData}) async {
  TextEditingController nameTextController =
      TextEditingController(text: initialData?.name);
  TextEditingController descriptionTextController =
      TextEditingController(text: initialData?.description);
  TextEditingController speciesTextController =
      TextEditingController(text: initialData?.species?.name);
  TextEditingController knownFromTextController =
      TextEditingController(text: initialData?.knownFrom);
  TextEditingController strengthController =
      TextEditingController(text: initialData?.strength);
  TextEditingController weaknessesController =
      TextEditingController(text: initialData?.weaknesses);
  TextEditingController hpController =
      TextEditingController(text: initialData?.hp.toString());
  TextEditingController attackController =
      TextEditingController(text: initialData?.attack.toString());
  TextEditingController defenseController =
      TextEditingController(text: initialData?.defense.toString());
  TextEditingController specialAttackController =
      TextEditingController(text: initialData?.specialAttack.toString());
  TextEditingController specialDefenseController =
      TextEditingController(text: initialData?.specialDefense.toString());
  TextEditingController speedController =
      TextEditingController(text: initialData?.speed.toString());
  ImagePicker imagePicker = ImagePicker();

  const double height = 20;
  const String placeholderImage =
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/0.png";
  final double imageHeight = MediaQuery.of(context).size.width * 0.2;

  MonkeyDto? updatedData = initialData;
  File? pickedImage;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                var status = await Permission.mediaLibrary.status;
                if (status.isDenied) {
                  await Permission.mediaLibrary.request();
                }
                if (await Permission.location.isRestricted) {
                  return;
                }
                final image =
                    await imagePicker.pickImage(source: ImageSource.gallery);

                if (image == null) return;
                pickedImage = File(image.path);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: imageHeight,
                child: pickedImage == null
                    ? CachedNetworkImage(
                        height: imageHeight,
                        imageUrl: initialData?.image ?? placeholderImage,
                        fit: BoxFit.cover,
                      )
                    : ClipOval(
                        child: Image.file(
                        pickedImage!,
                      )),
              ),
            ),
            const SizedBox(height: height),
            _textField(
                context: context,
                controller: nameTextController,
                onChanged: (value) {
                  nameTextController.text = value;
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData = updatedData!.copyWith(name: value);
                },
                labelText: "Name",
                helperText: "Name des Affen eingeben"),
            const SizedBox(height: height),
            _textField(
                context: context,
                controller: descriptionTextController,
                onChanged: (value) {
                  descriptionTextController.text = value;
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData = updatedData!.copyWith(description: value);
                },
                labelText: "Beschreibungstext",
                helperText: "Beschreibenden Text zum Affen eingeben"),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: speciesTextController,
              onChanged: (value) {
                speciesTextController.text = value;
                updatedData ??= const MonkeyDto(
                    id: 23444, name: "", species: SpeciesDto(name: ""));
                updatedData = updatedData!.copyWith(
                    species: updatedData!.species?.copyWith(name: value));
              },
              labelText: "Name der Affenspezies",
              helperText: "Namen der Affenspezies eingeben",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: knownFromTextController,
              onChanged: (value) {
                knownFromTextController.text = value;
                updatedData ??= const MonkeyDto(
                    id: 23444, name: "", species: SpeciesDto(name: ""));
                updatedData = updatedData!.copyWith(knownFrom: value);
              },
              labelText: "Bekannt aus",
              helperText: "Eingeben, woher (z.B. Film) der Affe bekannt ist",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: strengthController,
              onChanged: (value) {
                strengthController.text = value;
                updatedData ??= const MonkeyDto(
                    id: 23444, name: "", species: SpeciesDto(name: ""));
                updatedData = updatedData!.copyWith(strength: value);
              },
              labelText: "Stärken",
              helperText: "Eingeben, welche Stärken der Affe hat",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: weaknessesController,
              onChanged: (value) {
                weaknessesController.text = value;
                updatedData ??= const MonkeyDto(
                    id: 23444, name: "", species: SpeciesDto(name: ""));
                updatedData = updatedData!.copyWith(weaknesses: value);
              },
              labelText: "Schwächen",
              helperText: "Eingeben, welche Schwächen der Affe hat",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: hpController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                hpController.text = value;
                if (value.isNotEmpty) {
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData =
                      updatedData!.copyWith(hp: int.tryParse(value) ?? 0);
                }
              },
              labelText: "KP",
              helperText:
                  "KP-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: attackController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                attackController.text = value;
                if (value.isNotEmpty) {
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData =
                      updatedData!.copyWith(attack: int.tryParse(value) ?? 0);
                }
              },
              labelText: "Angriff",
              helperText:
                  "Angriffs-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: defenseController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                defenseController.text = value;
                if (value.isNotEmpty) {
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData =
                      updatedData!.copyWith(defense: int.tryParse(value) ?? 0);
                }
              },
              labelText: "Verteidigung",
              helperText:
                  "Verteidungungs-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: specialAttackController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                specialAttackController.text = value;
                if (value.isNotEmpty) {
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData = updatedData!
                      .copyWith(specialAttack: int.tryParse(value) ?? 0);
                }
              },
              labelText: "Spezial Angriff",
              helperText:
                  "Spezial-Angriffs-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: specialDefenseController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                specialDefenseController.text = value;
                if (value.isNotEmpty) {
                  updatedData ??= const MonkeyDto(
                      id: 23444, name: "", species: SpeciesDto(name: ""));
                  updatedData = updatedData!
                      .copyWith(specialDefense: int.tryParse(value) ?? 0);
                }
              },
              labelText: "Spezial Verteidigung",
              helperText:
                  "Spezial-Verteidungs-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            _textField(
              context: context,
              controller: speedController,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: false),
              onChanged: (value) {
                speedController.text = value;
                updatedData ??= const MonkeyDto(
                    id: 23444, name: "", species: SpeciesDto(name: ""));
                if (value.isNotEmpty) {
                  updatedData =
                      updatedData!.copyWith(speed: int.tryParse(value) ?? 0);
                }
              },
              labelText: "Initiative",
              helperText:
                  "Initiative-Wert des Affen eingeben. Wichtig für den Arenakampf",
            ),
            const SizedBox(height: height),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Bestätigen"),
            ),
          ],
        ),
      );
    },
  );

  return (updatedData, pickedImage);
}

TextField _textField(
    {required BuildContext context,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType = TextInputType.text,
    String? labelText,
    String? helperText,
    Icon? icon}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      icon: icon,
      floatingLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.secondary),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2.0,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      helperText: helperText,
    ),
  );
}
