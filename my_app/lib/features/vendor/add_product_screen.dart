import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/data_providers.dart';
import '../../core/supabase/supabase_config.dart';
import '../auth/auth_widgets.dart';

/// Vendor flow: create a product listing with an uploaded photo.
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController(text: '100');
  final _wholesale = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController(text: 'Asaba');
  Uint8List? _image;
  bool _saving = false;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _stock.dispose();
    _wholesale.dispose();
    _desc.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final x = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 75, maxWidth: 1400);
      if (x == null) return;
      final bytes = await x.readAsBytes();
      setState(() => _image = bytes);
    } catch (e) {
      _snack('Could not pick image: $e', isError: true);
    }
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final price = double.tryParse(_price.text.trim());
    if (title.isEmpty || price == null) {
      _snack('Title and a valid price are required', isError: true);
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) {
      _snack('You need to be signed in', isError: true);
      return;
    }

    setState(() => _saving = true);
    try {
      final client = SupabaseConfig.client;
      String? imageUrl;
      if (_image != null) {
        final path = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await client.storage.from('product-images').uploadBinary(
              path,
              _image!,
              fileOptions:
                  const FileOptions(contentType: 'image/jpeg', upsert: true),
            );
        imageUrl = client.storage.from('product-images').getPublicUrl(path);
      }

      await client.from('products').insert({
        'vendor_id': user.id,
        'title': title,
        'price': price,
        'stock': int.tryParse(_stock.text.trim()) ?? 0,
        'description': _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        'wholesale_price': double.tryParse(_wholesale.text.trim()),
        'location': _location.text.trim().isEmpty ? 'Asaba' : _location.text.trim(),
        if (imageUrl != null) 'image_url': imageUrl,
      });

      if (!mounted) return;
      // Refresh the feeds that show products.
      ref.invalidate(productsFeedProvider);
      ref.invalidate(vendorDashboardProvider);
      _snack('Product published!');
      context.go('/vendor/dashboard');
    } catch (e) {
      _snack('Could not publish: $e', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : AppColors.emerald600,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/vendor/dashboard'),
        ),
        title: Text('Add Product',
            style: GoogleFonts.manrope(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _image != null
                            ? AppColors.emerald600
                            : AppColors.slate700),
                    image: _image != null
                        ? DecorationImage(
                            image: MemoryImage(_image!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_rounded,
                                color: AppColors.emerald600, size: 32),
                            const SizedBox(height: 8),
                            Text('Add a product photo',
                                style: GoogleFonts.inter(
                                    fontSize: 13, color: AppColors.slate400)),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              const FieldLabel('Product title'),
              const SizedBox(height: 8),
              InputField(controller: _title, hint: 'e.g. Fresh Tomatoes (Basket)'),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('Price (₦)'),
                        const SizedBox(height: 8),
                        InputField(
                            controller: _price,
                            hint: '4500',
                            keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('Stock'),
                        const SizedBox(height: 8),
                        InputField(
                            controller: _stock,
                            hint: '100',
                            keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('Wholesale price (optional)'),
                        const SizedBox(height: 8),
                        InputField(
                            controller: _wholesale,
                            hint: '3800',
                            keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('Location'),
                        const SizedBox(height: 8),
                        InputField(controller: _location, hint: 'Asaba'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const FieldLabel('Description (optional)'),
              const SizedBox(height: 8),
              InputField(controller: _desc, hint: 'Tell shoppers about this item'),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white))
                      : Text('Publish product',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
