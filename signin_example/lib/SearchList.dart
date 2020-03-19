import 'dart:async';

import 'package:flutter/material.dart';

import 'members.dart';


class _MemberListItem extends ListTile {

  _MemberListItem(Member member) :
    super(
      title : Text(member.fullName),
      subtitle: Text(member.email),
      leading: CircleAvatar(
        child: Text(member.fullName[0]+member.fullName.split(" ")[1][0])
      )
    );

}

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchList> {
  final FocusNode myFocusNode = new FocusNode();

  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  List<Member> _results = List();

  Timer debounceTimer;

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        _results = List();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
    });

    final repos = _results.where((element) => 
            element.fullName.toLowerCase().contains(query.toLowerCase()) 
            || element.phoneNumber.toLowerCase().contains(query.toLowerCase()) 
            || element.email.toLowerCase().contains(query.toLowerCase()) 
            || element.memberID.toLowerCase().contains(query.toLowerCase()) 
            || element.memberType.toLowerCase().contains(query.toLowerCase())             
    );
    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          _results = repos;
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            autofocus: true,
            controller: _searchQuery,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitle('Searching...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQuery.text.isEmpty) {
      return CenterTitle('Begin Search by typing on search bar');
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return _MemberListItem(_results[index]);
          });
    }
  }
}

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ));
  }
}