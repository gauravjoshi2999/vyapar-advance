import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const VyaparApp());
}

class VyaparApp extends StatelessWidget {
  const VyaparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vyapar Advance',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const BillingScreen(),
    );
  }
}

class InvoiceItem {
  String name;
  double price;
  int qty;
  InvoiceItem({required this.name, required this.price, required this.qty});
  double get total => price * qty;
}

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<InvoiceItem> items = [];
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: "1");

  double get grandTotal => items.fold(0, (sum, item) => sum + item.total);

  void addItem() {
    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
    setState(() {
      items.add(InvoiceItem(
        name: nameCtrl.text,
        price: double.parse(priceCtrl.text),
        qty: int.parse(qtyCtrl.text),
      ));
    });
    nameCtrl.clear();
    priceCtrl.clear();
    qtyCtrl.text = "1";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vyapar Advance Billing", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("Bill banane ke liye neeche '+' button dabayein"))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(items[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${items[i].qty} pcs x ₹${items[i].price}"),
                      trailing: Text("₹${items[i].total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Bill Amount", style: TextStyle(color: Colors.black54)),
                    Text("₹${grandTotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Save Bill", style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: items.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bill Successfully Save Ho Gaya!")));
                          setState(() => items.clear());
                        },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Naya Item Jodein"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Item Ka Naam")),
                TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price (₹)")),
                TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Quantity")),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              ElevatedButton(onPressed: addItem, child: const Text("Add")),
            ],
          ),
        ),
      ),
    );
  }
}
