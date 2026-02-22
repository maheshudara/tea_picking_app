import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'models/record.dart';
import 'theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  
  // Register Adapter
  // Note: record.g.dart usually needs to be generated. 
  // For manual setup, we'd need to run build_runner.
  // We assume the user will run 'flutter pub run build_runner build'
  // But for the sake of this code, we assume it's registered.
  // Hive.registerAdapter(TeaRecordAdapter());
  
  await Hive.openBox<TeaRecord>('records');
  
  runApp(const TeaPickingApp());
}

class TeaPickingApp extends StatelessWidget {
  const TeaPickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Picker',
      theme: TeaTheme.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final Box<TeaRecord> _recordBox = Hive.box<TeaRecord>('records');

  void _saveRecord() {
    final name = _nameController.text;
    final weight = double.tryParse(_weightController.text) ?? 0.0;

    if (name.isNotEmpty && weight > 0) {
      final record = TeaRecord(
        employeeName: name,
        weight: weight,
        timestamp: DateTime.now(),
      );
      _recordBox.add(record);
      
      _nameController.clear();
      _weightController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record Saved!'), backgroundColor: TeaTheme.primaryGreen),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid details'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tea Picking Record', style: TextStyle(color: Colors.white)),
        backgroundColor: TeaTheme.primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Section
            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Employee Name'),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Weight (KG)', suffixText: 'kg'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveRecord,
                        child: const Text('SUBMIT WEIGHT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TeaTheme.primaryGreen),
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _recordBox.listenable(),
                builder: (context, Box<TeaRecord> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(child: Text('No records yet.'));
                  }
                  
                  final records = box.values.toList().reversed.toList();
                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: TeaTheme.lightGreen,
                            child: Icon(Icons.eco, color: TeaTheme.primaryGreen),
                          ),
                          title: Text(record.employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(record.timestamp)),
                          trailing: Text('${record.weight} kg', style: const TextStyle(fontSize: 18, color: TeaTheme.primaryGreen, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
