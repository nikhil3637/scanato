import 'package:flutter/material.dart';
import '../models/admin_model.dart';
import '../server/apis.dart';

class AdminList extends StatefulWidget {
  const AdminList({Key? key}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}
late List<Welcome>? _filteredAdminModel = [];
class _AdminListState extends State<AdminList> {
  late List<Welcome>? _adminModel = [];
  final ApiServices apiServices = ApiServices();


  Future<void> getAdminListData() async {
    List<Welcome>? adminData = await apiServices.fetchAdminListData(1);
    setState(() {
      _adminModel = adminData;
      _filteredAdminModel = adminData; // Initialize the filtered list
      print('_adminModel====================%$_adminModel');
    });
  }

  @override
  void initState() {
    super.initState();
    getAdminListData();
  }

  // Function to handle search
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAdminModel = _adminModel; // Show all admins when query is empty
      } else {
        _filteredAdminModel = _adminModel
            ?.where((admin) =>
            admin.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AdminSearchDelegate(_handleSearch),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: const Text(
                'Admin List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child:ListView.builder(
                itemCount: (_filteredAdminModel?.length ?? 0),
                itemBuilder: (BuildContext context, int index) {
                  final admin = _filteredAdminModel?[index];

                  // Check if name, email, and mobile are not empty
                  if (admin?.name?.isNotEmpty == true &&
                      admin?.email?.isNotEmpty == true &&
                      admin?.mobile?.isNotEmpty == true) {
                    return Card(
                      elevation: 9,
                      child: ListTile(
                        title: Text('Name: ${admin?.name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${admin?.email}'),
                            Text('Mobile: ${admin?.mobile}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Handle edit here
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Handle delete here
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Return an empty container if any of the required fields is empty
                    return Container();
                  }
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}

class AdminSearchDelegate extends SearchDelegate<String> {
  final Function(String) searchCallback;

  AdminSearchDelegate(this.searchCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for search bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchCallback('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final List<Welcome>? searchResults = _filteredAdminModel
        ?.where((admin) =>
        admin.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (searchResults!.isEmpty) {
      return Center(
        child: Text('No results found for "$query"'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final admin = searchResults[index];
        return ListTile(
          title: Text('Name: ${admin.name}'),
          subtitle: Text('Email: ${admin.email} | Mobile: ${admin.mobile}'),
        );
      },
    );
  }
}

