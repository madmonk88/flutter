import 'package:flutter/material.dart';
import 'members.dart';

class MembersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Members"),
        ),
        body: MemberList(kMembers)
      );
  }

}

class MemberList extends StatelessWidget {

  final List<Member> _members;

  MemberList(this._members);

  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _buildMemberList()
        );
  }

  List<_MemberListItem> _buildMemberList() {
    return _members.map((member) => _MemberListItem(member))
                    .toList();
  }

}

class _MemberListItem extends ListTile {

  _MemberListItem(Member member) :
    super(
      title : Text(member.fullName),
      // subtitle: Text(member.email + "\n" + member.memberID )  ,       
      subtitle: Text(member.memberID )  ,       
      leading: CircleAvatar(
        child: Text(member.fullName[0]+member.fullName.split(" ")[1][0])
      )
    );

}