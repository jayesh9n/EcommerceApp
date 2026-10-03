import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/models.dart';

class ExcelService {
  /// Generate and download demo Excel/CSV template with sample hardware products
  static void downloadDemoTemplate() {
    final headers = [
      'title',
      'categoryId',
      'mrp',
      'sellingPrice',
      'unitLabel',
      'imageUrl',
      'stock',
    ];

    final sampleRow1 = [
      'HI-TECH 6M OPEN SURFACE BOX',
      'cat_boxes',
      17792.0,
      8896.0,
      '1box',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      100,
    ];

    final sampleRow2 = [
      'PVC CONDUIT PIPE 25MM',
      'cat_pipes',
      450.0,
      280.0,
      '1pc',
      'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=300',
      50,
    ];

    final sampleRow3 = [
      'MODULAR SWITCH 6A 1-WAY',
      'cat_switches',
      120.0,
      75.0,
      '1pc',
      'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=300',
      200,
    ];

    final rows = [headers, sampleRow1, sampleRow2, sampleRow3];
    final csvData = csv.encode(rows);

    _triggerDownload(csvData, 'products_demo_template.csv');
  }

  /// Export current list of products to Excel/CSV
  static void exportProductsToCsv(List<Product> products, [List<Category>? categories]) {
    final headers = [
      'id',
      'title',
      'categoryId',
      'categoryName',
      'mrp',
      'sellingPrice',
      'unitLabel',
      'imageUrl',
      'stock',
    ];

    final categoryMap = {for (var c in (categories ?? [])) c.id: c.name};

    final rows = <List<dynamic>>[headers];

    for (final p in products) {
      rows.add([
        p.id,
        p.title,
        p.categoryId,
        categoryMap[p.categoryId] ?? p.categoryId,
        p.mrp,
        p.sellingPrice,
        p.unitLabel,
        p.imageUrl,
        p.stock,
      ]);
    }

    final csvData = csv.encode(rows);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _triggerDownload(csvData, 'products_export_$timestamp.csv');
  }

  /// Pick CSV/Excel file and parse into a list of Product models
  static Future<List<Product>> importProductsFromCsv({
    required List<Category> availableCategories,
  }) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
    );

    if (result == null || result.isEmpty) {
      return [];
    }

    final file = result.first;
    final bytes = await file.readAsBytes();
    String content = utf8.decode(bytes);

    if (content.trim().isEmpty) {
      throw Exception('Selected file is empty');
    }

    final rows = csv.decode(content);
    if (rows.length < 2) {
      throw Exception('File must contain a header row and at least one product row.');
    }

    final headerRow = rows.first.map((e) => e.toString().trim().toLowerCase()).toList();

    int titleIdx = headerRow.indexOf('title');
    int categoryIdx = headerRow.indexOf('categoryid');
    if (categoryIdx == -1) categoryIdx = headerRow.indexOf('category');
    int mrpIdx = headerRow.indexOf('mrp');
    int sellingPriceIdx = headerRow.indexOf('sellingprice');
    if (sellingPriceIdx == -1) sellingPriceIdx = headerRow.indexOf('price');
    int unitIdx = headerRow.indexOf('unitlabel');
    if (unitIdx == -1) unitIdx = headerRow.indexOf('unit');
    int imageIdx = headerRow.indexOf('imageurl');
    if (imageIdx == -1) imageIdx = headerRow.indexOf('image');
    int stockIdx = headerRow.indexOf('stock');

    if (titleIdx == -1) {
      throw Exception('CSV must contain a "title" column header.');
    }

    final defaultCatId = availableCategories.isNotEmpty ? availableCategories.first.id : 'cat_general';
    final importedProducts = <Product>[];
    final now = DateTime.now().millisecondsSinceEpoch;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || row.every((cell) => cell.toString().trim().isEmpty)) {
        continue; // skip empty rows
      }

      String title = titleIdx < row.length ? row[titleIdx].toString().trim() : '';
      if (title.isEmpty) continue;

      String catId = categoryIdx >= 0 && categoryIdx < row.length
          ? row[categoryIdx].toString().trim()
          : defaultCatId;

      if (catId.isEmpty) catId = defaultCatId;

      double mrp = mrpIdx >= 0 && mrpIdx < row.length
          ? (double.tryParse(row[mrpIdx].toString()) ?? 1000.0)
          : 1000.0;

      double sellingPrice = sellingPriceIdx >= 0 && sellingPriceIdx < row.length
          ? (double.tryParse(row[sellingPriceIdx].toString()) ?? 500.0)
          : mrp * 0.5;

      String unitLabel = unitIdx >= 0 && unitIdx < row.length
          ? row[unitIdx].toString().trim()
          : '1box';
      if (unitLabel.isEmpty) unitLabel = '1box';

      String imageUrl = imageIdx >= 0 && imageIdx < row.length
          ? row[imageIdx].toString().trim()
          : '';

      int stock = stockIdx >= 0 && stockIdx < row.length
          ? (int.tryParse(row[stockIdx].toString()) ?? 100)
          : 100;

      importedProducts.add(
        Product(
          id: 'prod_${now}_$i',
          title: title,
          categoryId: catId,
          mrp: mrp,
          sellingPrice: sellingPrice,
          unitLabel: unitLabel,
          imageUrl: imageUrl,
          stock: stock,
        ),
      );
    }

    return importedProducts;
  }

  static void _triggerDownload(String content, String fileName) {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
