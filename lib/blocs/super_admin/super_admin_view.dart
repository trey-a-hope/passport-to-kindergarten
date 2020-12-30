part of 'super_admin_bloc.dart';

class SuperAdminView extends StatefulWidget {
  @override
  State createState() => SuperAdminViewState();
}

class SuperAdminViewState extends State<SuperAdminView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
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
          color: COLOR_CREAM,
          child: SafeArea(
            child: BlocBuilder<SuperAdminBloc, SuperAdminState>(
              builder: (BuildContext context, SuperAdminState state) {
                if (state is LoadingState) {
                  return SpinnerWidget();
                }

                if (state is LoadedState) {
                  final List<BookModel> booksOfTheMonth = state.booksOfTheMonth;

                  return ListView(
                    children: [
                      AppBarWidget(title: 'Super Admin'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: booksOfTheMonth.length,
                        itemBuilder: (context, index) {
                          final BookModel bookOfTheMonth =
                              booksOfTheMonth[index];
                          return SwitchListTile(
                            secondary:
                                Image.network('${bookOfTheMonth.imgUrl}'),
                            title: Text('${bookOfTheMonth.title}'),
                            value: bookOfTheMonth.given,
                            onChanged: (bool newValue) {
                              context.read<SuperAdminBloc>().add(
                                    UpdateBookGivenEvent(
                                      bookID: bookOfTheMonth.id,
                                      given: newValue,
                                    ),
                                  );
                              setState(() {
                                bookOfTheMonth.given = newValue;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  );
                }

                if (state is ErrorState) {
                  return Center(
                    child: Text(
                      state.error.toString(),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
