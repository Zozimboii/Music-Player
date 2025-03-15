import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final ImageProvider image;
  final String label;
  const AlbumCard({
    super.key, // ใช้ super.key แทน Key key
    required this.image, // กำหนดให้ต้องใส่ค่าเสมอ
    required this.label, // กำหนดให้ต้องใส่ค่าเสมอ
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(12), // กำหนดมุมโค้งให้รูปภาพ
            child: Image(image: image ,width: 120, height: 120,fit: BoxFit.cover,),
          ),
        
        SizedBox(height: 10,),
        Text(label,style: TextStyle(
              fontSize: 14,
              
              color: Colors.grey,
              
            ),)
      ],
    );
  }
}