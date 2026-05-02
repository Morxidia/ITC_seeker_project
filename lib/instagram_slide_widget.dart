import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class InstagramSlideWidget extends StatelessWidget {
  final String instagramWebUrl;

  const InstagramSlideWidget({
    super.key,
    required this.instagramWebUrl,
  });

  // This helper converts the link. 
  // It takes "https://www.instagram.com/p/DVGd-5VCbdv/"
  // and returns "https://www.instagram.com/p/DVGd-5VCbdv/media/?size=l"
  String get _directImageUrl {
    // Basic cleaning to ensure the URL ends correctly
    String cleanUrl = instagramWebUrl.replaceAll(RegExp(r'/$'), ''); 
    return '$cleanUrl/media/?size=l';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Material Design AppBar (optional)
      appBar: AppBar(title: const Text('Insta-Slide View')),
      
      // The main body where the image lives
      body: Center(
        child: Container(
          color: Colors.black12, // Slight background for contrast
          height: 400, // Fixed height similar to a phone feed post
          width: MediaQuery.of(context).size.width,
          
          // PhotoView handles the slide, pinch, and zoom gestures
          child: PhotoView(
            // Use the direct image URL we constructed
            imageProvider: NetworkImage(_directImageUrl),
            
            // Setting the scale so it feels like a standard post
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            
            // Optional: Background of the view area
            backgroundDecoration: const BoxDecoration(color: Colors.white),
            
            // Displayed while loading
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            
            // Displayed if Instagram blocks the request
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Error loading image.\nInstagram may be blocking this manual request method.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}