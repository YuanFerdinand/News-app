import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/article_bloc.dart';
import 'package:news_app/config/global_function.dart';
import 'package:news_app/model/response_articles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArticleBloc _articleBloc = ArticleBloc();
  List<Articles> listArticles = [];
  List<Articles> listArticlesDataSave = [];
  int page = 1;
  String query = "";
  String filterDate = "Filter Tanggal";
  DateTime selectedDate = DateTime.now();

  List<String> listCategories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];
  String category = "";
  var scrollController = ScrollController();
  @override
  void initState() {
    _articleBloc = BlocProvider.of<ArticleBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) async {
        if (state is GetArticleSuccess) {
          // listArticles.clear();
          Navigator.pop(context);
          listArticles = (state.responseArticles.articles ?? listArticles);
          listArticlesDataSave = listArticles;
          setState(() {});
        }
        if (state is GetArticleError) {
          Navigator.pop(context);
          print(state.errorMessage);
        }
        if (state is GetArticleWaiting) {
          GlobalFunction().setLoading(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Articles Apps")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton(
                    hint: Text(category == ""
                        ? "Pilih Category"
                        : StringUtils.capitalize(category)),
                    items: listCategories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(StringUtils.capitalize(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      category = value ?? "";
                      setState(() {});
                      _articleBloc.add(LoadArticle(category: value ?? ""));
                    },
                  ),
                ],
              ),
              Text(
                "*Pilih Kategori terlebih dahulu untuk dapat menampilkan artikel dan menggunakan filter",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search title, name, or author',
                  // labelText: 'Name *',
                ),
                onFieldSubmitted: (value) {
                  query = value.toString();
                  print(query);
                  print(category);
                  setState(() {});
                  _articleBloc
                      .add(LoadArticle(category: category, query: query));
                },
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            category == "" ? Colors.grey : Colors.blue),
                    onPressed: category == ""
                        ? () {}
                        : () {
                            _selectDate(context);
                          },
                    child: Text(filterDate),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      listArticles = listArticlesDataSave;
                      setState(() {});
                    },
                    child: Text("Reset Filter"),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listArticles.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listArticles[index].title ?? "Loading",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Posted on: " +
                                    (listArticles[index].publishedAt == null
                                        ? "Unknown"
                                        : (listArticles[index].publishedAt)
                                            .toString()
                                            .substring(0, 10)),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Authored by: " +
                                    (listArticles[index].author ?? "Unknown"),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(listArticles[index].content ??
                          "Content Not Available"),
                      leading: listArticles[index].urlToImage != null
                          ? Container(
                              color: Colors.black,
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Image.network(
                                  listArticles[index].urlToImage!,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : Image.asset("assets/no_image_available.png"),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: listArticles.length,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Column(
              //           children: [
              //             Text(
              //                 listArticles[index].author ?? "Error".toString()),
              //             Text(DateTime.tryParse(
              //                     listArticles[index].publishedAt ?? "")
              //                 .toString()
              //                 .substring(0, 10)
              //                 .toString()),
              //           ],
              //         ),
              //         leading: Text((index + 1).toString()),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    List<Articles> listArticlesTemp = [];
    listArticles = listArticlesDataSave;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      filterDate = picked.toString().substring(0, 10);
      for (Articles article in listArticles) {
        if (article.publishedAt.toString().substring(0, 10) ==
            selectedDate.toString().substring(0, 10)) {
          listArticlesTemp.add(article);
        }
      }
      listArticles = listArticlesTemp;
      setState(() {});
    }
  }
}
