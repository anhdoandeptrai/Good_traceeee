import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goods_trace/app/services/image_service.dart';

class ProductImagePicker extends StatefulWidget {
  final File? selectedImage;
  final String? existingImageUrl;
  final bool isUploading;
  final Function(File) onImageSelected;

  const ProductImagePicker({
    Key? key,
    this.selectedImage,
    this.existingImageUrl,
    required this.isUploading,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  Future<void> _pickImage() async {
    final imageFile = await ImageService.showImageSourceSheet();
    if (imageFile != null) {
      widget.onImageSelected(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.selectedImage != null
                    ? Image.file(
                        widget.selectedImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : widget.existingImageUrl != null
                        ? Image.network(
                            widget.existingImageUrl!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image_outlined,
                                size: 60,
                                color:
                                    isDarkMode ? Colors.grey[400] : Colors.grey,
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 60,
                                color:
                                    isDarkMode ? Colors.grey[400] : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Image',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
              ),
              if (widget.isUploading)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
