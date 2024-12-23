class ImageData {

  final String src;

  final String srcSmall;

  final String srcMedium;

  final String srcLarge;

  final String? youtubeVideoUrl;

  ImageData({
    required this.src,
    required this.srcSmall,
    required this.srcMedium,
    required this.srcLarge,
    this.youtubeVideoUrl,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      src: json['src'],
      srcSmall: json['src_small'],
      srcMedium: json['src_medium'],
      srcLarge: json['src_large'],
      youtubeVideoUrl: json['youtube_video_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'src_small': srcSmall,
      'src_medium': srcMedium,
      'src_large': srcLarge,
      'youtube_video_url': youtubeVideoUrl,
    };
  }

  @override
  String toString(){
    return '''
      Image Data:
        Source: $src
        Source Small: $srcSmall
        Source Medium: $srcMedium
        Source Large: $srcLarge
        YouTube URL: $youtubeVideoUrl
    ''';
  }
}
