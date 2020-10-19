import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class PasswordInputDialog extends StatefulWidget {
  PasswordInputDialog(this.api,
      {this.account, this.title, this.content, this.onOk});

  final PolkawalletApi api;
  final KeyPairData account;
  final Widget title;
  final Widget content;
  final Function onOk;

  @override
  _PasswordInputDialog createState() => _PasswordInputDialog();
}

class _PasswordInputDialog extends State<PasswordInputDialog> {
  final TextEditingController _passCtrl = new TextEditingController();

  bool _submitting = false;

  Future<void> _onOk(String password) async {
    setState(() {
      _submitting = true;
    });
    var res = await widget.api.keyring.checkPassword(widget.account, password);
    if (mounted) {
      setState(() {
        _submitting = false;
      });
    }
    if (res == null) {
      final dic = I18n.of(context).getDic(i18n_full_dic_ui, 'common');
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(dic['pass.error']),
            content: Text(dic['pass.error.txt']),
            actions: <Widget>[
              CupertinoButton(
                child: Text(dic['ok']),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      widget.onOk(password);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_ui, 'common');

    return CupertinoAlertDialog(
      title: widget.title ?? Container(),
      content: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: widget.content ?? Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: CupertinoTextField(
              placeholder: dic['pass.old'],
              controller: _passCtrl,
              obscureText: true,
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text(dic['cancel']),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _submitting ? CupertinoActivityIndicator() : Container(),
              Text(dic['ok'])
            ],
          ),
          onPressed: _submitting ? null : () => _onOk(_passCtrl.text.trim()),
        ),
      ],
    );
  }
}