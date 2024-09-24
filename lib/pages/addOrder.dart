import 'package:flutter/material.dart';


class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  
//--------------------------------------
    final Map<String, String> phoneBook = {
    '0812345678': 'John Doe',
    '0912345678': 'Jane Smith',
    '0612345678': 'Alice Johnson',
    '0811111111': 'Bob Brown',
    '0922222222': 'Charlie Davis'
  };

  String? selectedUserName;
//--------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return phoneBook.keys.where((String number) {
                  return number.contains(textEditingValue.text);
                });
              },
              onSelected: (String selectedNumber) {
                setState(() {
                  selectedUserName = phoneBook[selectedNumber];
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter phone number',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (selectedUserName != null)
              Text(
                'User: $selectedUserName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}