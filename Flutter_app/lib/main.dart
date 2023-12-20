import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Disconnected';
  double _speed = 1.0; // Initial speed

  TextEditingController ipController = TextEditingController();
  String _baseUrl = ''; // Initialize with an empty string

  Future<void> _sendCommand(String command) async {
    // Get the IP address from the controller
    final ipAddress = ipController.text;

    // Check if the IP address is empty or null
    if (ipAddress.isEmpty || ipAddress == null) {
      setState(() {
        _status = 'IP address is empty';
      });
      return;
    } else {
      setState(() {
        _status = 'IP address configed successfully';
      });
    }

    // Build the base URL using the entered IP address
    _baseUrl = 'http://$ipAddress';

    final baseUrl = Uri.parse(_baseUrl);
    print(baseUrl);
    print(baseUrl.replace(queryParameters: {'State': command}));
    final response = await http.post(baseUrl.replace(queryParameters: {'State': command}));
    print(response.statusCode);
    
    if (response.statusCode == 200) {
      setState(() {
        _status = 'Command sent: $command';
      });
    } else {
      setState(() {
        _status = 'Failed to send command';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Control App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: 'IP Address',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Status: $_status',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 200),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _sendCommand('F'),
                  child: Text('Forward'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _sendCommand('L'),
                  child: Text('Left'),
                ),
                ElevatedButton(
                  onPressed: () => _sendCommand('S'),
                  child: Text(' Stop'),
                ),
                ElevatedButton(
                  onPressed: () => _sendCommand('R'),
                  child: Text('Right'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _sendCommand('B'),
                  child: Text('Backward'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
