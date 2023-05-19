import 'dart:convert';
import 'package:charity_app/stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  @override
  void initState() {
    super.initState();
    print("initiated");
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    // Load products from JSON file
    final response = await http
        .get(Uri.parse('https://mydonations.org/wp-json/mydonation/v1/posts'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _posts = data.map((json) => Post.fromJson(json)).toList();
        _filteredPosts = _posts;
      });
    }
  }

  void _filterPosts(String query) {
    final filteredPosts = _posts.where((post) {
      final titleLower = post.title.toLowerCase();

      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower);
    }).toList();
    setState(() {
      _filteredPosts = filteredPosts
          .where((post) =>
              post.category == _selectedCategory || _selectedCategory.isEmpty)
          .toList();
    });
  }

  void _filterPostsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterPosts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = _posts.map((post) => post.category).toSet().toList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: <Widget>[
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Text('Goede doelen die jouw hulp kunnen gebruiken',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _filterPosts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Zoek...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.grey,
                      onPressed: () {
                        _searchController.clear();
                        _filterPosts('');
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  onChanged: (value) {
                    _filterPostsByCategory(value!);
                  },
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('All categories'),
                    ),
                    ...categories.map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        )),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filteredPosts.length,
                  itemBuilder: (ctx, index) {
                    final post = _filteredPosts[index];
                    return Card(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Image.network(post.image_url),
                          ListTile(
                            title: Text(post.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: new Text(
                              'DONEER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size(1, 45),
                              backgroundColor: Color(0xFF0099FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  wordSpacing: 2,
                                  letterSpacing: 2),
                            ),
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StripeWidget()))
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              )
            ])));
  }
}

class Post {
  final int id;
  final String title;
  final String image_url;
  final String category;

  Post({
    required this.id,
    required this.title,
    required this.image_url,
    required this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      image_url: json['image_url'],
      category: json['category'],
    );
  }
}
