import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/core/node_address_validator.dart';
import 'package:cake_wallet/core/node_port_validator.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/widgets/base_text_form_field.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:cake_wallet/view_model/node_list/node_create_or_edit_view_model.dart';

class NodeCreateOrEditPage extends BasePage {
  NodeCreateOrEditPage(this.nodeCreateOrEditViewModel)
      : _formKey = GlobalKey<FormState>(),
        _addressController = TextEditingController(),
        _portController = TextEditingController(),
        _loginController = TextEditingController(),
        _passwordController = TextEditingController() {
    reaction((_) => nodeCreateOrEditViewModel.address, (String address) {
      if (address != _addressController.text) {
        _addressController.text = address;
      }
    });

    reaction((_) => nodeCreateOrEditViewModel.port, (String port) {
      if (port != _portController.text) {
        _portController.text = port;
      }
    });

    if (nodeCreateOrEditViewModel.hasAuthCredentials) {
      reaction((_) => nodeCreateOrEditViewModel.login, (String login) {
        if (login != _loginController.text) {
          _loginController.text = login;
        }
      });

      reaction((_) => nodeCreateOrEditViewModel.password, (String password) {
        if (password != _passwordController.text) {
          _passwordController.text = password;
        }
      });
    }

    _addressController.addListener(
        () => nodeCreateOrEditViewModel.address = _addressController.text);
    _portController.addListener(
        () => nodeCreateOrEditViewModel.port = _portController.text);
    _loginController.addListener(
        () => nodeCreateOrEditViewModel.login = _loginController.text);
    _passwordController.addListener(
        () => nodeCreateOrEditViewModel.password = _passwordController.text);
  }

  final GlobalKey<FormState> _formKey;
  final TextEditingController _addressController;
  final TextEditingController _portController;
  final TextEditingController _loginController;
  final TextEditingController _passwordController;

  @override
  String get title => S.current.node_new;

  final NodeCreateOrEditViewModel nodeCreateOrEditViewModel;

  @override
  Widget body(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: ScrollableWithBottomSection(
          contentPadding: EdgeInsets.only(bottom: 24.0),
          content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: BaseTextFormField(
                          controller: _addressController,
                          hintText: S.of(context).node_address,
                          validator: NodeAddressValidator(),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: BaseTextFormField(
                          controller: _portController,
                          hintText: S.of(context).node_port,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: NodePortValidator(),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  if (nodeCreateOrEditViewModel.hasAuthCredentials) ...[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: BaseTextFormField(
                            controller: _loginController,
                            hintText: S.of(context).login,
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: BaseTextFormField(
                            controller: _passwordController,
                            hintText: S.of(context).password,
                          )
                        )
                      ],
                    )
                  ]
                ],
              )),
          bottomSectionPadding: EdgeInsets.only(bottom: 24),
          bottomSection: Observer(
              builder: (_) => Row(
                    children: <Widget>[
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.only(right: 8.0),
                        child: PrimaryButton(
                            onPressed: () => nodeCreateOrEditViewModel.reset(),
                            text: S.of(context).reset,
                            color: Colors.orange,
                            textColor: Colors.white),
                      )),
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: PrimaryButton(
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            await nodeCreateOrEditViewModel.save();
                            Navigator.of(context).pop();
                          },
                          text: S.of(context).save,
                          color: Theme.of(context).accentTextTheme.body2.color,
                          textColor: Colors.white,
                          isDisabled: !nodeCreateOrEditViewModel.isReady,
                        ),
                      )),
                    ],
                  )),
        ));
  }
}