
import 'package:flutter/material.dart';

class UpdateBottomSheet extends StatefulWidget {
  bool loading;
  void Function(BuildContext, String) onPressed;
  String title;
  String initialValue;

  UpdateBottomSheet({
    Key? key,
    required this.loading,
    required this.onPressed,
    required this.title,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<UpdateBottomSheet> createState() => _UpdateBottomSheetState();
}

class _UpdateBottomSheetState extends State<UpdateBottomSheet> {
  final valueController = TextEditingController();

  @override
  initState() {
    super.initState();
    valueController.text = widget.initialValue;
  }

  @override
  dispose() {
    super.dispose();
    valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ubahButton = widget.loading
        ? SizedBox(
      key: ValueKey(1),
      height: 52.0,
      width: 52.0,
      child: CircularProgressIndicator(
        strokeWidth: 6,
      ),
    )
        : SizedBox(
      key: ValueKey(2),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Text(
          'Ubah',
        ),
        onPressed: () {
          widget.onPressed(context, valueController.text);
        },
      ),
    );
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(contentPadding: EdgeInsets.all(8)),
            minLines: 1,
            maxLines: 6,
            controller: valueController,
            autofocus: true,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: ubahButton),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: Text("Batalkan"),
          ),
        ],
      ),
    );
  }
}