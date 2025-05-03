import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _posts = apiService.getPosts();
    });
  }

  void _showNewPostForm() {
    final userIdController = TextEditingController();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'ID de usuario'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Mensaje (body)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await apiService.createPost(
                      int.parse(userIdController.text),
                      titleController.text,
                      bodyController.text,
                    );

                    Navigator.pop(context);
                    _loadPosts();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post creado exitosamente')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: Text('Crear Post'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: FutureBuilder<List<dynamic>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay posts'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['body']),
                    trailing: Text('User ID: ${post['userId']}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewPostForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
