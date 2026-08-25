import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'restaurant_delivery.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // USERS
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            image TEXT,
            role TEXT NOT NULL
          )
        ''');

        // PRODUCTS
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            image TEXT,
            category TEXT NOT NULL
          )
        ''');

        // CART
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');

        // ORDERS
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            total REAL NOT NULL,
            status TEXT NOT NULL
          )
        ''');

        // ORDER ITEMS
        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL
          )
        ''');

        // ADMIN
        await db.insert('users', {
          'username': 'admin',
          'password': '1234',
          'image': '',
          'role': 'admin',
        });

        // USER
        await db.insert('users', {
          'username': 'user',
          'password': '1234',
          'image': '',
          'role': 'user',
        });

        // منتجات تجريبية
        await db.insert('products', {
          'name': 'برجر دجاج',
          'description': 'برجر دجاج مشوي مع الجبن والخضار',
          'price': 250,
          'image': '',
          'category': 'food',
        });

        await db.insert('products', {
          'name': 'بيتزا',
          'description': 'بيتزا بالخضار والجبن',
          'price': 400,
          'image': '',
          'category': 'food',
        });

        await db.insert('products', {
          'name': 'عصير برتقال',
          'description': 'عصير برتقال طبيعي',
          'price': 100,
          'image': '',
          'category': 'drink',
        });

        await db.insert('products', {
          'name': 'موهيتو',
          'description': 'موهيتو بالليمون والنعناع',
          'price': 150,
          'image': '',
          'category': 'drink',
        });

        await db.insert('products', {
          'name': 'تشيز كيك',
          'description': 'تشيز كيك بالفراولة',
          'price': 200,
          'image': '',
          'category': 'dessert',
        });

        await db.insert('products', {
          'name': 'كيك شوكولاتة',
          'description': 'كيك شوكولاتة فاخر',
          'price': 250,
          'image': '',
          'category': 'dessert',
        });
      },
    );
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // تحديث صورة المستخدم
  static Future<void> updateUserImage(
    int userId,
    String image,
  ) async {
    final db = await database;

    await db.update(
      'users',
      {'image': image},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // جلب المنتجات حسب النوع
  static Future<List<Map<String, dynamic>>> getProducts(
    String category,
  ) async {
    final db = await database;

    return await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'id DESC',
    );
  }

  // جلب جميع المنتجات
  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;

    return await db.query(
      'products',
      orderBy: 'id DESC',
    );
  }

  // إضافة منتج
  static Future<int> insertProduct(
    Map<String, dynamic> product,
  ) async {
    final db = await database;

    return await db.insert(
      'products',
      product,
    );
  }

  // تعديل منتج
  static Future<int> updateProduct(
    int id,
    Map<String, dynamic> product,
  ) async {
    final db = await database;

    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // حذف منتج
  static Future<int> deleteProduct(int id) async {
    final db = await database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // إضافة للسلة
  static Future<void> addToCart(
    int userId,
    int productId,
  ) async {
    final db = await database;

    final existing = await db.query(
      'cart',
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );

    if (existing.isNotEmpty) {
      final oldQuantity = existing.first['quantity'] as int;

      await db.update(
        'cart',
        {'quantity': oldQuantity + 1},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('cart', {
        'userId': userId,
        'productId': productId,
        'quantity': 1,
      });
    }
  }

  // جلب السلة
  static Future<List<Map<String, dynamic>>> getCart(
    int userId,
  ) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT
        cart.id,
        cart.userId,
        cart.productId,
        cart.quantity,
        products.name,
        products.description,
        products.price,
        products.image,
        products.category
      FROM cart
      INNER JOIN products
      ON cart.productId = products.id
      WHERE cart.userId = ?
    ''', [userId]);
  }

  // حذف من السلة
  static Future<void> deleteCartItem(int id) async {
    final db = await database;

    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // تأكيد الطلب
  static Future<void> confirmOrder(int userId) async {
    final db = await database;

    await db.transaction((txn) async {
      final cart = await txn.rawQuery('''
        SELECT
          cart.productId,
          cart.quantity,
          products.price
        FROM cart
        INNER JOIN products
        ON cart.productId = products.id
        WHERE cart.userId = ?
      ''', [userId]);

      if (cart.isEmpty) {
        return;
      }

      double total = 0;

      for (final item in cart) {
        final price = (item['price'] as num).toDouble();
        final quantity = item['quantity'] as int;

        total += price * quantity;
      }

      final orderId = await txn.insert('orders', {
        'userId': userId,
        'total': total,
        'status': 'confirmed',
      });

      for (final item in cart) {
        await txn.insert('order_items', {
          'orderId': orderId,
          'productId': item['productId'],
          'quantity': item['quantity'],
          'price': item['price'],
        });
      }

      await txn.delete(
        'cart',
        where: 'userId = ?',
        whereArgs: [userId],
      );
    });
  }
}