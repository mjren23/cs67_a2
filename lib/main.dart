
import 'package:flutter/material.dart';

void main() {
  runApp(
    ToDoApp(),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskability',
      home: HomeScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class ToDoItem extends StatelessWidget {
  const ToDoItem({
    required this.text,
    Key? key,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            const Divider(height: 1.0, thickness: 2, color: Colors.black,),
            Text(text),
            const Divider(height: 1.0,),
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ToDoItem> _itemlist = [];
  final List<ToDoItem> _done = [];
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taskability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushDone,
            tooltip: 'Done Items',
          ),
        ],
      ),
      body: Column(
              children: [
                Expanded(
                  child: Container(
                    child: _itemlist.length != 0 ? ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: /*1*/ (context, i) {
                        final item = _itemlist[i];
                        return _buildRow(item);
                      },
                      itemCount: _itemlist.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 4,);
                      },
                    ) :
                    Text("Congrats! All done with tasks."),
                    padding: _itemlist.length != 0 ? EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 0,
                    ) : EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 0
                    ),
                  ),
                ),
                Container(
                  child: _buildButton(),
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildRow(ToDoItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(
          item.text,
          style: _biggerFont,
        ),
        trailing: Icon(
          Icons.check_box_outlined,
        ),
        onTap: () {
          setState(() {
            _itemlist.remove(item);
            _done.add(item);
          });
        },
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      child: const Text("+"),
      onPressed: () => _handlePress(),
    );
  }


  void _handlePress() {
    showDialog(
        context: context,
        builder: _buildEnterItem,
    );
    _focusNode.requestFocus();
  }

  Widget _buildEnterItem(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Text("Add a to-do item:"),
          TextFormField(
            focusNode: _focusNode,
            controller: _textController,
          ),
          TextButton(
              onPressed: () => _addItem(_textController.text),
              child: Text("OK"))
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  void _addItem(String text) {
    setState(() {
      _itemlist.add(ToDoItem(text: text));
    });
    _textController.clear();
    Navigator.pop(context);
  }

  void _pushDone() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _done.map(
                (item) {
              return ListTile(
                title: Text(
                  item.text,
                  style: _biggerFont,
                ),
                trailing: Icon(
                  Icons.check_box_rounded,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Done Items'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}