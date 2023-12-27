import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/data/models/detailmodel.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:collection/collection.dart';

class ReviewScreen extends StatefulWidget {
  final double rating;
  final String place_id;
  final Function onReviewPosted;

  ReviewScreen(
      {required this.place_id,
      required this.rating,
      required this.onReviewPosted});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController _reviewController = TextEditingController();
  String? userEmail;
  final _reviewService = ApiService();

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    _loadExistingReview();
  }

  Future<void> _loadExistingReview() async {
    final reviewDoc =
        await _reviewService.fetchReviewsByplace_id(widget.place_id);
    final userReview =
        reviewDoc.firstWhereOrNull((review) => review.authorName == userEmail);

    if (userReview != null) {
      _reviewController.text = userReview.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: Text("Write a Review"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "User: ${userEmail}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Rating: ${widget.rating}/5",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your review',
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(black),
              ),
              onPressed: () async {
                await _reviewService.postReviewByuserEmail(
                    place_id: widget.place_id,
                    userEmail: userEmail!,
                    rating: widget.rating,
                    review: _reviewController.text);
                widget.onReviewPosted();
                Navigator.of(context)
                    .pop(); // This will return to the DetailScreen.
              },
              child: Text('Post Review'),
            ),
          ],
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gfood_app/components/data/provider/review_provider.dart';
import 'package:gfood_app/screens/Restaurant/widgets/animation_placeholder.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  static const routeName = '/review';

  final String id;
  const ReviewScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController reviewController = TextEditingController();

    Widget _buildForm() {
      return Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  textAlignVertical: TextAlignVertical.center,
                  showCursor: true,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                    hintText: 'Nama saya',
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(16.0),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: customBlue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: reviewController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                  showCursor: true,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                    hintText: 'Pendapat saya tentang restoran ini ...',
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(16.0),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: customBlue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Review tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          )
        ]),
      );
    }

    Widget _buildContent(BuildContext context) {
      return Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          switch (provider.postState) {
            case PostResultState.idle:
              return _buildForm();
            case PostResultState.loading:
              return const Center(
                child: SpinKitFadingCircle(
                  color: customBlue,
                ),
              );
            case PostResultState.success:
              return const Center(
                child: AnimationPlaceholder(
                  animation: 'assets/done.json',
                  text:
                      'Terimakasih sudah memberikan review! Semoga harimu menyenangkan',
                ),
              );
            case PostResultState.failure:
              return Center(
                child: AnimationPlaceholder(
                  animation: 'assets/no-internet.json',
                  text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
                  hasButton: true,
                  buttonText: 'Refresh',
                  onButtonTap: () {
                    provider.setPostState(PostResultState.idle);
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: AppBar(
          elevation: 0.0,
          titleSpacing: 24.0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 96.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.6),
                child: IconButton(
                  splashRadius: 4.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryIconTheme.color,
                  onPressed: () {
                    Provider.of<ReviewProvider>(
                      context,
                      listen: false,
                    ).setPostState(PostResultState.idle);
                    Navigator.pop(context);
                  },
                ),
              ),
              Text(
                'Review',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
              IconButton(
                splashRadius: 24.0,
                splashColor: Colors.grey[200],
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.send),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<ReviewProvider>(
                      context,
                      listen: false,
                    ).postReview(
                      restaurantId: id,
                      name: nameController.text,
                      review: reviewController.text,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }
}*/
