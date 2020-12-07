import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//Stateless widgets are immutable, meaning that their properties can’t change—all values are final.
//
//Statefull widgets maintain state that might change during the lifetime of the widget.
//  Stateful widget requires at least two classes.
//    1. a StatefulWidget
//    2. a State class

// 1. Create the boilerplate

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();

    return MaterialApp(
      title: 'Welcome to Gouvis',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      //home: Scaffold(
      //  appBar: AppBar(
      //    title: Text('Welcome 2')
      //    ),
      //    body: Center(
      //      child:
      //        //Text('Hello World'),
      //        //Text(wordPair.asPascalCase),
      //        RandomWords(),
      //    ),
      //),
    );
  }
}

class RandomWords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RandomWordsState(); // Can't write it as normal function form ????
}

//By default, the name of the State class in prefixed with an underbar.
class _RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder( // This list View is Crazy... The index help you made the infinate scrolling
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if(i.isOdd) return Divider(); // Divider is 1 px line, vcl.
        final index = i ~/ 2;
        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10)); // If you've reached the end of the available word pairings, then generate 10 more and add them to suggestions.
        }
        return _buildRow(_suggestions[index]);
      },
    );
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
        color: alreadySaved ? Colors.pink : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      }
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final tites = _saved.map(
            (WordPair pair){
              return ListTile(
                title: Text(pair.asPascalCase,style: _biggerFont)
              );
            }
          );
          final divided = ListTile.divideTiles(context: context,tiles: tites).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided)
          );
        }
      )
    );
  }
}