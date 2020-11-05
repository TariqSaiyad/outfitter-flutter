import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:flutter/material.dart';

class AddItemFormWidget extends StatefulWidget {
  final Function onFormComplete;
  final String image;

  const AddItemFormWidget(
      {Key key, @required this.image, @required this.onFormComplete})
      : super(key: key);

  @override
  _AddItemFormWidgetState createState() => _AddItemFormWidgetState();
}

class _AddItemFormWidgetState extends State<AddItemFormWidget> {
  EdgeInsetsGeometry _fieldPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8);

  final _formKey = new GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _dropdownCategoryItems;
  List<DropdownMenuItem<String>> _dropdownColorItems;
  List<DropdownMenuItem<String>> _dropdownCodeItems;
  List<DropdownMenuItem<String>> _dropdownTypeItems;
  String name = "";
  String category = "";
  String color = "";
  String code = "";
  String type = "";

  void initState() {
    super.initState();
    _dropdownCategoryItems = _buildCategoryList();
    _dropdownColorItems = _buildColorList();
    _dropdownCodeItems = _buildCodeList();
    _dropdownTypeItems = _buildTypeList();
    category = _dropdownCategoryItems[0].value;
    color = _dropdownColorItems[0].value;
    code = _dropdownCodeItems[0].value;
    type = _dropdownTypeItems[0].value;
  }

  // Save the form inputs
  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /// Validate the form and create the Item.
  void validateAndSubmit(BuildContext context) async {
    print("here");
    if (validateAndSave()) {
      FocusScope.of(context).unfocus();
      //Create item and add it using callback. Reset form afterwards.
      Item i = new Item(widget.image, name, type, code, color, category);
      widget.onFormComplete(i);
      _formKey.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
//            Text(name),
//            Text(category),
//            Text(color),
//            Text(code),
//            Text(type),
            _itemNameField(),
            _itemCategoryField(),
            _itemColorField(),
            _itemCodeField(),
            _itemTypeField(),
            Padding(
              padding: _fieldPadding,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).accentColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Item", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 10,
                      height: 40,
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: (_formKey != null &&
                        _formKey.currentState != null &&
                        _formKey.currentState.validate())
                    ? () => validateAndSubmit(context)
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemNameField() {
    return Padding(
      padding: _fieldPadding,
      child: TextFormField(
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            isDense: false,
            errorStyle: TextStyle(
              color: Colors.red[100],
            ),
            labelText: "Item Name",
            hintText: "My denim jacket"),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => name = value.trim(),
      ),
    );
  }

  Widget _itemCategoryField() {
    return DropDownWidget(
        child: DropdownButtonFormField(
            dropdownColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none, labelText: 'Category'),
            items: _dropdownCategoryItems,
            value: category,
            onSaved: (value) => category = value,
            onChanged: (val) {
              setState(() {
                category = val;
              });
            }));
  }

  Widget _itemColorField() {
    return DropDownWidget(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
                enabledBorder: InputBorder.none, labelText: 'Color'),
            items: _dropdownColorItems,
            value: color,
            onSaved: (value) => color = value,
            onChanged: (val) {
              setState(() {
                color = val;
              });
            }));
  }

  Widget _itemCodeField() {
    return DropDownWidget(
        child: DropdownButtonFormField(
            dropdownColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none, labelText: 'Dress Code'),
            items: _dropdownCodeItems,
            value: code,
            onSaved: (value) => code = value,
            onChanged: (val) {
              setState(() {
                code = val;
              });
            }));
  }

  Widget _itemTypeField() {
    return DropDownWidget(
        child: DropdownButtonFormField(
            dropdownColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none, labelText: 'Clothing Type'),
            items: _dropdownTypeItems,
            value: type,
            onSaved: (value) => type = value,
            onChanged: (val) => setState(() {
                  type = val;
                })));
  }

  List<DropdownMenuItem<String>> _buildCategoryList() {
    List<DropdownMenuItem<String>> items = List();
    for (String i in CATEGORY_LIST) {
      items.add(
        DropdownMenuItem(
          child: Text(i),
          value: i,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildCodeList() {
    List<DropdownMenuItem<String>> items = List();
    for (String i in DRESS_CODES) {
      items.add(
        DropdownMenuItem(
          child: Text(i),
          value: i,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildTypeList() {
    List<DropdownMenuItem<String>> items = List();
    for (String i in CLOTHING_TYPES) {
      items.add(
        DropdownMenuItem(
          child: Text(i),
          value: i,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildColorList() {
    List<DropdownMenuItem<String>> items = List();
    for (String i in COLORS_LIST.keys) {
      items.add(
        DropdownMenuItem(
          child: Row(
            children: [
              CircleAvatar(maxRadius: 15, backgroundColor: COLORS_LIST[i]),
              const SizedBox(width: 10),
              Text(Helper.capitalise(i))
            ],
          ),
          value: i,
        ),
      );
    }
    return items;
  }
}

class DropDownWidget extends StatelessWidget {
  final EdgeInsetsGeometry _fieldPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8);
  final Widget child;

  DropDownWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: _fieldPadding,
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {},
          child: child,
        ));
  }
}
