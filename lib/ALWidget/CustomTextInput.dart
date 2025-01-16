




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextInput extends StatefulWidget {
  dynamic onTap;
  TextEditingController controller;
   CustomTextInput({
     required this.onTap,
    required this.controller,
    super.key
  });

  @override
  State<CustomTextInput> createState() => _ssssState();
}

class _ssssState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return
      Container(alignment: Alignment.bottomCenter,
          height: Get.height*0.05,
          width: Get.width*0.3,
          child:

        TextFormField(
            textAlign: TextAlign.center,
            enabled: true,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (value){
              if(value[0]=='0')
              {
                setState(() {
                  widget.controller.text='1';
                });
              }
              widget.onTap();
            },
            inputFormatters:  [
              FilteringTextInputFormatter.deny(RegExp(r'[-,. ]')),
            ],
            textInputAction: null,
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF5F5F5),
              prefixIcon :  GestureDetector(
                onTap: (){
                  int crntQty = int.tryParse(widget.controller.text)!;
                  setState(() {
                    widget.controller.text = '${crntQty + 1}';
                  });
                  widget.onTap();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 18,
                ),
              ),
              suffixIcon:  GestureDetector(
                onTap: (){
                  int crntQty = int.tryParse(widget.controller.text)!;
                  if (crntQty-1 >= 1) {
                    setState(() {
                      widget.controller.text = '${crntQty - 1}';
                    });
                    widget.onTap();
                  }
                },
                child: const Icon(
                  Icons.remove,
                  color:Colors.black,
                  size: 18,
                ),
              ) ,
              contentPadding: EdgeInsets.only(top: 5),
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xffF5F5F5), width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xffF5F5F5), width: 0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xffF5F5F5), width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              hintStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            style: const TextStyle(color: Colors.black,fontSize: 18)),



    );

}
}
