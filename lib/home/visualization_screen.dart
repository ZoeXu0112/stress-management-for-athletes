import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Reading list for outcome, motivational, process, and situational visualization.
class VisualizationScreen extends StatelessWidget {
  const VisualizationScreen({super.key});

  static final List<({String title, String imageAsset, List<({String title, String source, Uri url})> articles})> _sections = [
    (
      title: 'Outcome visualization',
      imageAsset: 'assets/outcome_visualization.png',
      articles: [
        (
          title: 'The effects of visualization on judgment and decision-making: a systematic literature review',
          source: 'Springer',
          url: Uri.parse('https://link.springer.com/article/10.1007/s11301-021-00235-8'),
        ),
        (
          title: 'Translating visualization techniques from performance psychology to clinical psychology: efficacy, adaptation, and applications',
          source: 'UniScience Pub',
          url: Uri.parse(
            'https://unisciencepub.com/articles/translating-visualization-techniques-from-performance-psychology-to-clinical-psychology-efficacy-adaptation-and-applications/',
          ),
        ),
      ],
    ),
    (
      title: 'Motivational visualization',
      imageAsset: 'assets/motivational_visualization.png',
      articles: [
        (
          title: 'Mental imagery as a "motivational amplifier" to promote activities',
          source: 'PubMed',
          url: Uri.parse('https://pubmed.ncbi.nlm.nih.gov/30797989/'),
        ),
        (
          title: 'The motivating power of visionary images: effects on motivation, affect, and behavior',
          source: 'PubMed',
          url: Uri.parse('https://pubmed.ncbi.nlm.nih.gov/27716917/'),
        ),
      ],
    ),
    (
      title: 'Process visualization',
      imageAsset: 'assets/process_visualization.png',
      articles: [
        (
          title: 'The effectiveness of business process visualisations: a systematic literature review',
          source: 'arXiv',
          url: Uri.parse('https://arxiv.org/pdf/2504.10971'),
        ),
        (
          title: 'Process visualization techniques for multi-perspective process comparisons',
          source: 'Springer',
          url: Uri.parse('https://link.springer.com/chapter/10.1007/978-3-319-19509-4_14'),
        ),
      ],
    ),
    (
      title: 'Situational visualization',
      imageAsset: 'assets/situational_visualization.png',
      articles: [
        (
          title: 'Situation awareness-oriented patient monitoring with visual patient technology',
          source: 'PMC',
          url: Uri.parse('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7180744/'),
        ),
        (
          title: 'Riverside: a design study on visualization for situation awareness in cybersecurity',
          source: 'SAGE',
          url: Uri.parse('https://journals.sagepub.com/doi/full/10.1177/14738716231189220'),
        ),
      ],
    ),
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
          'Visualization',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Text(
              'Ways to picture change',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'These strands—how you imagine results, what keeps you moving, how steps are represented, and how situations are read at a glance—draw on different research traditions. Tap a title to open the paper in your browser.',
              style: TextStyle(
                fontSize: 15,
                color: textMuted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            for (var i = 0; i < _sections.length; i++) ...[
              if (i > 0) const SizedBox(height: 24),
              _SectionBlock(
                categoryTitle: _sections[i].title,
                imageAsset: _sections[i].imageAsset,
                articles: _sections[i].articles,
                onOpenUrl: (url) => _openUrl(context, url),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, Uri url) async {
    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: $url')),
      );
    }
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.categoryTitle,
    required this.imageAsset,
    required this.articles,
    required this.onOpenUrl,
  });

  final String categoryTitle;
  final String imageAsset;
  final List<({String title, String source, Uri url})> articles;
  final void Function(Uri url) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: quickVisualization.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.visibility_rounded, color: quickVisualization, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                categoryTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imageAsset,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        for (var j = 0; j < articles.length; j++) ...[
          if (j > 0) const SizedBox(height: 10),
          _ArticleTile(
            title: articles[j].title,
            source: articles[j].source,
            onTap: () => onOpenUrl(articles[j].url),
          ),
        ],
      ],
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.title,
    required this.source,
    required this.onTap,
  });

  final String title;
  final String source;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.open_in_new_rounded, size: 20, color: quickVisualization),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      source,
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
