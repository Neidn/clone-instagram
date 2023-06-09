import 'package:clone_instagram/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/utils/global_variables.dart';
import '/utils/colors.dart';

import '/models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for a user',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onFieldSubmitted: (value) {
            setState(() {
              _isShowUsers = true;
            });
          },
        ),
      ),
      body: _isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection(firebaseUsers)
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final User user = User.fromSnap(snapshot.data!.docs[index]);

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: user.uid),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profileUrl),
                        ),
                        title: Text(user.username),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection(firebasePosts).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // return StaggeredGrid.count(
                //   crossAxisCount: 4,
                //   children: List.generate(
                //     snapshot.data!.docs.length,
                //     (index) => StaggeredGridTile.count(
                //       crossAxisCellCount: index % 3 == 0 ? 2 : 1,
                //       mainAxisCellCount: index % 3 == 0 ? 2 : 1,
                //       child: Image.network(
                //         snapshot.data!.docs[index]['postUrl'],
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // );

                return GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: width > webScreenSize
                        ? [
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 1),
                          ]
                        : [
                            const QuiltedGridTile(2, 2),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 2),
                          ],
                  ),
                  shrinkWrap: true,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= snapshot.data!.docs.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Image.network(
                        snapshot.data!.docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
