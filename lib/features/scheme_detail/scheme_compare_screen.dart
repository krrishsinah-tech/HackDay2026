import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/scheme.dart';
import '../../providers/app_providers.dart';

class SchemeCompareScreen extends ConsumerStatefulWidget {
  final String? initialSchemeId;

  const SchemeCompareScreen({super.key, this.initialSchemeId});

  @override
  ConsumerState<SchemeCompareScreen> createState() => _SchemeCompareScreenState();
}

class _SchemeCompareScreenState extends ConsumerState<SchemeCompareScreen> {
  Scheme? _schemeA;
  Scheme? _schemeB;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  void _loadSchemes() async {
    final repo = ref.read(schemeRepositoryProvider);
    final allSchemes = await repo.getSchemes();

    if (allSchemes.isNotEmpty) {
      if (widget.initialSchemeId != null) {
        _schemeA = allSchemes.firstWhere(
          (s) => s.id == widget.initialSchemeId,
          orElse: () => allSchemes.first,
        );
        _schemeB = allSchemes.firstWhere(
          (s) => s.id != widget.initialSchemeId,
          orElse: () => allSchemes.last,
        );
      } else {
        _schemeA = allSchemes[0];
        _schemeB = allSchemes.length > 1 ? allSchemes[1] : allSchemes[0];
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.saffronOrange)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text("Compare Schemes Side-by-Side"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scheme A Column
                  Expanded(
                    child: _buildSchemeColumn(_schemeA, isLeft: true),
                  ),
                  const SizedBox(width: 12),
                  // Scheme B Column
                  Expanded(
                    child: _buildSchemeColumn(_schemeB, isLeft: false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildComparisonRow("Benefit Amount", "₹${_schemeA?.benefitAmount ?? 0}", "₹${_schemeB?.benefitAmount ?? 0}"),
                      const Divider(),
                      _buildComparisonRow("Level", _schemeA?.stateOrCentral ?? '', _schemeB?.stateOrCentral ?? ''),
                      const Divider(),
                      _buildComparisonRow("Required Docs", "${_schemeA?.documentsRequired.length ?? 0} documents", "${_schemeB?.documentsRequired.length ?? 0} documents"),
                      const Divider(),
                      _buildComparisonRow("Ease Score", "${((_schemeA?.easeScore ?? 0.8) * 100).toInt()}%", "${((_schemeB?.easeScore ?? 0.8) * 100).toInt()}%"),
                      const Divider(),
                      _buildComparisonRow("Deadline", _schemeA?.deadline ?? '', _schemeB?.deadline ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeColumn(Scheme? scheme, {required bool isLeft}) {
    if (scheme == null) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isLeft ? AppTheme.saffronOrange : AppTheme.indiaGreen, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isLeft ? AppTheme.saffronOrange : AppTheme.indiaGreen).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isLeft ? "Scheme A" : "Scheme B",
                style: TextStyle(
                  color: isLeft ? AppTheme.saffronOrange : AppTheme.indiaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              scheme.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              scheme.ministry,
              style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String metric, String valA, String valB) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(metric, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.midNavy, fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(valA, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
              const Text("vs", style: TextStyle(color: AppTheme.mutedText, fontSize: 12)),
              Expanded(child: Text(valB, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
            ],
          ),
        ],
      ),
    );
  }
}
