import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final ProductController controller = Get.find<ProductController>();

  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  final priceController = TextEditingController();

  String category = 'food';

  String? imagePath;

  int? editingId;

  @override
  void initState() {
    super.initState();

    controller.loadAllProducts();
  }

  // اختيار الصورة وحفظ نسخة دائمة منها
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    // الحصول على مجلد دائم خاص بالتطبيق
    final directory = await getApplicationDocumentsDirectory();

    // اسم الصورة
    final fileName = path.basename(image.path);

    // المسار الجديد والدائم للصورة
    final savedImagePath = path.join(directory.path, fileName);

    // نسخ الصورة إلى التخزين الدائم
    await File(image.path).copy(savedImagePath);

    setState(() {
      imagePath = savedImagePath;
    });
  }

  // إضافة أو تعديل المنتج
  Future<void> saveProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'أدخل اسم المنتج والسعر');

      return;
    }

    final product = ProductModel(
      id: editingId,

      name: nameController.text.trim(),

      description: descriptionController.text.trim(),

      price: double.tryParse(priceController.text.trim()) ?? 0,

      image: imagePath ?? '',

      category: category,
    );

    // إضافة منتج جديد
    if (editingId == null) {
      await controller.addProduct(product);

      Get.snackbar('تم', 'تمت إضافة المنتج بنجاح');
    }
    // تعديل منتج موجود
    else {
      await controller.updateProduct(product);

      Get.snackbar('تم', 'تم تعديل المنتج بنجاح');
    }

    clearForm();
  }

  // اختيار منتج للتعديل
  void editProduct(ProductModel product) {
    setState(() {
      editingId = product.id;

      nameController.text = product.name;

      descriptionController.text = product.description;

      priceController.text = product.price.toString();

      category = product.category;

      imagePath = product.image;
    });
  }

  // تفريغ النموذج
  void clearForm() {
    setState(() {
      editingId = null;

      nameController.clear();

      descriptionController.clear();

      priceController.clear();

      category = 'food';

      imagePath = null;
    });
  }

  // تأكيد حذف المنتج
  Future<void> deleteProduct(ProductModel product) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('حذف المنتج'),

        content: Text('هل تريد حذف ${product.name}؟'),

        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('إلغاء'),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),

            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteProduct(product.id!);

      // إذا كان المنتج المحذوف هو المنتج
      // الموجود في نموذج التعديل
      if (editingId == product.id) {
        clearForm();
      }

      Get.snackbar('تم', 'تم حذف المنتج بنجاح');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xFFF2E7D3),

        appBar: AppBar(
          title: const Text('إدارة الوجبات'),

          centerTitle: true,

          backgroundColor: const Color(0xFF68743B),

          foregroundColor: Colors.white,
        ),

        body: Column(
          children: [
            // =========================
            // نموذج إضافة / تعديل
            // =========================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    Text(
                      editingId == null ? 'إضافة منتج جديد' : 'تعديل المنتج',

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF68743B),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // صورة المنتج
                    // =========================
                    GestureDetector(
                      onTap: pickImage,

                      child: Container(
                        width: 120,
                        height: 120,

                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DDC7),

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: const Color(0xFF68743B)),
                        ),

                        child:
                            imagePath != null &&
                                imagePath!.isNotEmpty &&
                                File(imagePath!).existsSync()
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),

                                child: Image.file(
                                  File(imagePath!),

                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_a_photo,

                                size: 45,

                                color: Color(0xFF68743B),
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: pickImage,

                      icon: const Icon(Icons.image),

                      label: const Text('اختيار صورة المنتج'),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // اسم المنتج
                    // =========================
                    TextField(
                      controller: nameController,

                      textAlign: TextAlign.right,

                      decoration: InputDecoration(
                        labelText: 'اسم المنتج',

                        prefixIcon: const Icon(Icons.fastfood),

                        filled: true,

                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // وصف المنتج
                    // =========================
                    TextField(
                      controller: descriptionController,

                      textAlign: TextAlign.right,

                      maxLines: 2,

                      decoration: InputDecoration(
                        labelText: 'وصف المنتج',

                        prefixIcon: const Icon(Icons.description),

                        filled: true,

                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // السعر
                    // =========================
                    TextField(
                      controller: priceController,

                      textAlign: TextAlign.right,

                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      decoration: InputDecoration(
                        labelText: 'السعر',

                        prefixIcon: const Icon(Icons.payments),

                        suffixText: 'ريال',

                        filled: true,

                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // نوع المنتج
                    // =========================
                    DropdownButtonFormField<String>(
                      value: category,

                      decoration: InputDecoration(
                        labelText: 'نوع المنتج',

                        prefixIcon: const Icon(Icons.category),

                        filled: true,

                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(value: 'food', child: Text('طعام')),

                        DropdownMenuItem(value: 'drink', child: Text('مشروب')),

                        DropdownMenuItem(value: 'dessert', child: Text('حلوى')),
                      ],

                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          category = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // أزرار الإضافة والتعديل
                    // =========================
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: saveProduct,

                            icon: Icon(
                              editingId == null ? Icons.add : Icons.edit,
                            ),

                            label: Text(
                              editingId == null
                                  ? 'إضافة المنتج'
                                  : 'حفظ التعديل',
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF68743B),

                              foregroundColor: Colors.white,

                              minimumSize: const Size(0, 50),
                            ),
                          ),
                        ),

                        if (editingId != null) const SizedBox(width: 10),

                        if (editingId != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: clearForm,

                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                              ),

                              child: const Text('إلغاء'),
                            ),
                          ),
                      ],
                    ),

                    const Divider(height: 35),

                    // =========================
                    // قائمة المنتجات
                    // =========================
                    const Align(
                      alignment: Alignment.centerRight,

                      child: Text(
                        'المنتجات المضافة',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                          color: Color(0xFF68743B),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Obx(() {
                      if (controller.products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(30),

                          child: Text('لا توجد منتجات مضافة'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: controller.products.length,

                        itemBuilder: (context, index) {
                          final product = controller.products[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),

                            color: Colors.white,

                            child: Padding(
                              padding: const EdgeInsets.all(8),

                              child: Row(
                                children: [
                                  // صورة المنتج
                                  Container(
                                    width: 70,

                                    height: 70,

                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8DDC7),

                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child:
                                        product.image != null &&
                                            product.image!.isNotEmpty &&
                                            File(product.image!).existsSync()
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),

                                            child: Image.file(
                                              File(product.image!),

                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.fastfood,

                                            color: Color(0xFF68743B),
                                          ),
                                  ),

                                  const SizedBox(width: 10),

                                  // معلومات المنتج
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          product.name,

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 17,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          '${product.price} ريال',
                                          style: const TextStyle(
                                            color: Color(0xFF68743B),

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          _categoryName(product.category),

                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // تعديل وحذف
                                  IconButton(
                                    onPressed: () {
                                      editProduct(product);
                                    },

                                    icon: const Icon(
                                      Icons.edit,

                                      color: Color(0xFF68743B),
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      deleteProduct(product);
                                    },

                                    icon: const Icon(
                                      Icons.delete,

                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تحويل اسم التصنيف للعربي
  String _categoryName(String category) {
    switch (category) {
      case 'food':
        return 'طعام';

      case 'drink':
        return 'مشروبات';

      case 'dessert':
        return 'حلويات';

      default:
        return category;
    }
  }
}
