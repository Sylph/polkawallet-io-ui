import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JumpToBrowserLink extends StatefulWidget {
  JumpToBrowserLink(this.url, {this.text, this.mainAxisAlignment});

  final String text;
  final String url;
  final MainAxisAlignment mainAxisAlignment;

  @override
  _JumpToBrowserLinkState createState() => _JumpToBrowserLinkState();
}

class _JumpToBrowserLinkState extends State<JumpToBrowserLink> {
  bool _loading = false;

  Future<void> _launchUrl() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    if (await canLaunch(widget.url)) {
      try {
        await launch(widget.url);
      } catch (err) {
        print(err);
      }
    } else {
      print('Could not launch ${widget.url}');
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              widget.text ?? widget.url,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          Icon(Icons.open_in_new,
              size: 16, color: Theme.of(context).primaryColor)
        ],
      ),
      onTap: _launchUrl,
    );
  }
}