import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GaleryPage extends StatefulWidget {
  const GaleryPage({Key? key}) : super(key: key);

  @override
  State<GaleryPage> createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage> {
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController =
      TextEditingController(text: '600');
  final TextEditingController maxHeightController =
      TextEditingController(text: '1000');
  final TextEditingController qualityController =
      TextEditingController(text: '100');

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: double.parse(maxWidthController.text),
      maxHeight: double.parse(maxHeightController.text),
      imageQuality: int.parse(qualityController.text),
    );
    setState(() {
      _setImageFileListFromFile(pickedFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _imageFileList != null
          ? 
          Semantics(
              label: 'image_picker_example_picked_images',
              child: ListView.builder(
                key: UniqueKey(),
                itemBuilder: (BuildContext context, int index) {
                  return Semantics(
                    label: 'image_picker_example_picked_image',
                    child: kIsWeb
                        ? Image.network(_imageFileList![index].path)
                        : Image.file(File(_imageFileList![index].path)),
                  );
                },
                itemCount: _imageFileList!.length,
              ),
            )
          : const SizedBox(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
        foregroundColor: Colors.blue,
        onPressed: () {
          _onImageButtonPressed(ImageSource.camera, context: context);
        },
      ),
    );
  }
}
