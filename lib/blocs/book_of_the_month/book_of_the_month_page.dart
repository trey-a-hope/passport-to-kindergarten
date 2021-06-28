part of 'book_of_the_month_bloc.dart';

class BookOfTheMonthPage extends StatefulWidget {
  @override
  State createState() => BookOfTheMonthPageState();
}

class BookOfTheMonthPageState extends State<BookOfTheMonthPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // BookOfTheMonthBloc _bookOfTheMonthBloc;

  @override
  void initState() {
    // _bookOfTheMonthBloc = BlocProvider.of<BookOfTheMonthBloc>(context)
    //   ..add(LoadPageEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: colorCream,
          child: SafeArea(
              child: BlocConsumer<BookOfTheMonthBloc, BookOfTheMonthState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingState) {
                return SpinnerWidget();
              }

              if (state is LoadedState) {
                final List<BookModel> booksOfTheMonth = state.booksOfTheMonth;

                return ListView(
                  shrinkWrap: true,
                  children: [
                    AppBarWidget(title: 'Book of The Month'),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Tap each icon for a video and reading tips!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: booksOfTheMonth.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        final BookModel bookOfTheMonth = booksOfTheMonth[index];

                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            child: Container(
                              foregroundDecoration: BoxDecoration(
                                color: bookOfTheMonth.given
                                    ? Colors.transparent
                                    : Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: Image.network(bookOfTheMonth.imgUrl)
                                      .image,
                                ),
                              ),
                            ),
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (BuildContext context) =>
                                      BOOK_OF_THE_MONTH_DETAILS_BP
                                          .BookOfTheMonthDetailsBloc(
                                    bookOfTheMonth: bookOfTheMonth,
                                  )..add(
                                          BOOK_OF_THE_MONTH_DETAILS_BP
                                              .LoadPageEvent(),
                                        ),
                                  child: BOOK_OF_THE_MONTH_DETAILS_BP
                                      .BookOfTheMonthDetailsPage(),
                                ),
                              );
                              Navigator.push(context, route);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              }

              if (state is ErrorState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('${state.error.toString()}'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: colorOrange,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      child: Text('Leave Page'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }

              return Container();
            },
          )),
        ),
      ),
    );
  }
}
