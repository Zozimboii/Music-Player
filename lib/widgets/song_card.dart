import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({super.key , required this.image , required this.label});
  final AssetImage image;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: 140,
      child: Column(
        children: [
         ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: image),
          ),
          SizedBox(height: 5,),
           Text(
            label,
            style: TextStyle(
              fontSize: 14,
              
              color: Colors.grey,
              
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          
        ),
        ],
      ),
    );
  }
}