import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Recommended Articles screen — matches app design. Uses royalty-free images (Picsum/Unsplash).
class RecommendedArticlesScreen extends StatelessWidget {
  const RecommendedArticlesScreen({super.key});

  /// Placeholder article data. Images from Picsum (Unsplash), free for personal/commercial use.
  static final List<({String title, String imageUrl})> _articles = [
    (title: '5 Breathing Techniques to Reduce Stress', imageUrl: 'https://picsum.photos/seed/stress1/400/260'),
    (title: 'Mindfulness for Athletes: A Practical Guide', imageUrl: 'https://picsum.photos/seed/mind2/400/260'),
    (title: 'Sleep Better Before Competition', imageUrl: 'https://picsum.photos/seed/sleep3/400/260'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Recommended Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: _articles.length,
          itemBuilder: (context, index) {
            final article = _articles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _ArticleCard(title: article.title, imageUrl: article.imageUrl),
            );
          },
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: textMuted.withValues(alpha: 0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: navSelected,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: textMuted.withValues(alpha: 0.12),
                    child: Icon(Icons.image_not_supported_rounded, size: 48, color: textMuted),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
