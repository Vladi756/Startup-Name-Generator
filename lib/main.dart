// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());  // Where every dart program starts - with 'MyApp' widget.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {  // method which returns a widget.
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.yellow,
        ),
      ),
      home: RandomWords(),
    );
  }
}
/// StatefulWidget has the method createState which must be overriden in all concrete implementation of it.


class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
/// Underscore at the start of the name means 'you can access this field from anywhere else.'
class _RandomWordsState extends State<RandomWords> {
  final _nameIdeas = <WordPair>[];  // list of word pairs, field in a class innit.
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
              (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
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
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

/// Great Encapsulation! Uses the _buildSuggestions() method of the RandomWords class
  /// to encapsulate the logic beautifully... the generated suggestions go in the body
  /// very readable, intuitive code.
  @override
    Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon : const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.builder(                  // builder - a list where objects are created dynamically.
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(); // Places a divider between every other item on the list (no functionality)

          final index = i ~/ 2;
          if (index >= _nameIdeas.length) { // if not enough generated name ideas
            _nameIdeas.addAll(generateWordPairs().take(10)); // create new name ideas - from englishWords package
          }
          return _buildRow(_nameIdeas[index]);
        });
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color : alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Removal from saved' : 'Save',
      ),
      onTap: () {
        setState((){
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}