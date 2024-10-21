import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  TextEditingController docCtl = TextEditingController();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController messageCtl = TextEditingController();
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('Document'),
          TextField(
            controller: docCtl,
          ),
          const Text('Name'),
          TextField(
            controller: nameCtl,
          ),
          const Text('Message'),
          TextField(
            controller: messageCtl,
          ),
          FilledButton(
              onPressed: () {
                // var db = FirebaseFirestore.instance;

                var data = {
                  'name': nameCtl.text,
                  'message': messageCtl.text,
                  'createAt': DateTime.timestamp()
                };

                db
                    .collection('inbox')
                    .doc(docCtl.text)
                    .set(data); //ชื่อใน firestore database -- ชื่อของ inbox
                //docCtl.text สามารถกำหนด ชื่อของ doc ได้
              },
              child: const Text('Add Data')),
          FilledButton(onPressed: readData, child: Text('read data')),
          FilledButton(onPressed: queryData, child: Text('query data')),
          FilledButton(
              onPressed: startRealtimeGet,
              child: const Text('Start Real-time Get')),
          // FilledButton(
          //     onPressed: stopRealTime, child: const Text('Stop Real-time Get'))
        ],
      ),
    );
  }

  void readData() async {
    // var db = FirebaseFirestore.instance;

    var result = await db.collection('inbox').doc(docCtl.text).get();
    var data = result.data();
    log(data!['message']);
    log((data['createAt'] as Timestamp).millisecondsSinceEpoch.toString());
  }

//การค้นหา
  void queryData() async {
    var inboxRef = db.collection("inbox");
    var query = inboxRef.where("name", isEqualTo: nameCtl.text);
    var result = await query.get();
    if (result.docs.isNotEmpty) {
      log(result.docs.first.data()['message']);
    }
  }

  void startRealtimeGet() {
    final docRef = db.collection("inbox").doc(docCtl.text);
    docRef.snapshots().listen(
      (event) {
        var data = event.data();
        Get.snackbar(data!['name'].toString(), data['message'].toString());
        log("current data: ${event.data()}");
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  // void stopRealTime() {
  //   try {
  //     listener.cancel().then(
  //       (value) {
  //         log('Listener is stopped');
  //       },
  //     );
  //   } catch (e) {
  //     log('Listener is not running...');
  //   }
  // }
}
