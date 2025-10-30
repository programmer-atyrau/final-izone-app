import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;

class LocalFaqQAService {
  static const String _faqAssetPath = 'assets/faq.md';
  String? _cachedMarkdown;
  List<_Section>? _indexedSections;

  Future<void> ensureLoaded() async {
    if (_cachedMarkdown != null && _indexedSections != null) return;
    final md = await rootBundle.loadString(_faqAssetPath);
    _cachedMarkdown = md;
    _indexedSections = _indexMarkdown(md);
  }

  Future<String> answer(String question) async {
    await ensureLoaded();
    final sections = _indexedSections ?? const <_Section>[];
    if (question.trim().isEmpty) {
      return 'Задайте вопрос, например: "Как открыть 3D модель?"';
    }

    final queryTokens = _tokenize(question);
    if (queryTokens.isEmpty) {
      return 'Не удалось распознать вопрос. Попробуйте переформулировать.';
    }

    _scoreSections(sections, queryTokens);
    sections.sort((a, b) => b.score.compareTo(a.score));

    final top = sections.take(2).toList();
    if (top.isEmpty || top.first.score < 0.05) {
      return 'Я не нашёл точный ответ в FAQ. Попробуйте спросить иначе или откройте раздел «FAQ».\n\nДоступные темы: Главная, Маршруты, Сканирование, Карта, Профиль, 3D/AR, Разрешения.';
    }

    final buffer = StringBuffer();
    for (final s in top) {
      buffer.writeln('• ${s.title.isNotEmpty ? s.title : 'Справка'}');
      buffer.writeln(_trimAnswer(s.body));
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  // --- internals ---
  List<_Section> _indexMarkdown(String md) {
    final lines = LineSplitter.split(md).toList();
    final sections = <_Section>[];
    String currentTitle = '';
    final currentBody = StringBuffer();

    void push() {
      if (currentTitle.isNotEmpty || currentBody.isNotEmpty) {
        final bodyStr = currentBody.toString().trim();
        if (bodyStr.isNotEmpty) {
          sections.add(_Section(
            title: currentTitle,
            body: bodyStr,
            tokens: _tokenize('$currentTitle\n$bodyStr'),
          ));
        }
      }
      currentBody.clear();
    }

    for (final line in lines) {
      if (line.startsWith('#')) {
        push();
        currentTitle = line.replaceFirst(RegExp(r'^#+\s*'), '').trim();
      } else {
        currentBody.writeln(line);
      }
    }
    push();
    return sections;
  }

  List<String> _tokenize(String text) {
    final lower = text.toLowerCase();
    final cleaned = lower
        .replaceAll(RegExp(r'[^a-zA-Zа-яА-Я0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return const [];
    final raw = cleaned.split(' ');
    final stop = _russianStopwords;
    return raw.where((t) => t.isNotEmpty && !stop.contains(t)).toList();
  }

  void _scoreSections(List<_Section> sections, List<String> queryTokens) {
    if (sections.isEmpty) return;
    // Build query term frequency
    final qtf = <String, int>{};
    for (final t in queryTokens) {
      qtf[t] = (qtf[t] ?? 0) + 1;
    }
    // Compute document frequencies
    final df = <String, int>{};
    for (final s in sections) {
      final seen = <String>{};
      for (final t in s.tokens) {
        if (seen.add(t)) {
          df[t] = (df[t] ?? 0) + 1;
        }
      }
    }

    final docCount = sections.length.toDouble();
    // Precompute norms and term weights per section
    for (final s in sections) {
      final tf = <String, int>{};
      for (final t in s.tokens) {
        tf[t] = (tf[t] ?? 0) + 1;
      }
      double norm = 0.0;
      final weights = <String, double>{};
      tf.forEach((t, f) {
        final idf = (df[t] != null)
            ? (1.0 + (docCount / (df[t]!.toDouble())).logSafe())
            : 1.0;
        final w = (1.0 + (f.toDouble()).logSafe()) * idf;
        weights[t] = w;
        norm += w * w;
      });
      s._weights = weights;
      s._norm = norm > 0 ? norm.sqrtSafe() : 1.0;
    }

    // Query weights
    double qnorm = 0.0;
    final qweights = <String, double>{};
    qtf.forEach((t, f) {
      final idf = (df[t] != null)
          ? (1.0 + (docCount / (df[t]!.toDouble())).logSafe())
          : 1.0;
      final w = (1.0 + (f.toDouble()).logSafe()) * idf;
      qweights[t] = w;
      qnorm += w * w;
    });
    qnorm = qnorm > 0 ? qnorm.sqrtSafe() : 1.0;

    for (final s in sections) {
      double dot = 0.0;
      qweights.forEach((t, qw) {
        final dw = s._weights[t];
        if (dw != null) dot += (qw * dw);
      });
      s.score = dot / (qnorm * s._norm);
    }
  }

  String _trimAnswer(String text) {
    final trimmed = text.trim();
    if (trimmed.length <= 600) return trimmed;
    return '${trimmed.substring(0, 600)}…';
  }
}

class _Section {
  _Section({required this.title, required this.body, required this.tokens});
  final String title;
  final String body;
  final List<String> tokens;
  double score = 0.0;
  late Map<String, double> _weights;
  late double _norm;
}

extension on double {
  double logSafe() => (this <= 0) ? 0.0 : math.log(this);
  double sqrtSafe() => this <= 0 ? 0.0 : math.sqrt(this);
}

const Set<String> _russianStopwords = {
  'и','в','во','не','что','он','на','я','с','со','как','а','то','все','она','так','его','но','да','ты','к','у','же','вы','за','бы','по','ее','мне','если','или','ни','быть','был','него','до','вас','нибудь','опять','уж','вам','ведь','там','потом','себя','ничего','ей','может','они','тут','где','надо','ней','для','мы','тебя','их','чем','была','сам','чтоб','без','будто','чего','раз','тоже','себе','под','будет','ж','тогда','кто','этот','того','потому','этого','какой','совсем','ним','здесь','этом','один','почти','мой','тем','чтобы','нее','сейчас','были','куда','зачем','всех','никогда','можно','при','наконец','два','об','другой','хоть','после','над','больше','тот','через','эти','нас','про','всего','них','какая','много','разве','три','эту','моя','впрочем','хорошо','свою','этой','перед','иногда','лучше','чуть','том','нельзя','такой','им','более','всегда','конечно'
};


