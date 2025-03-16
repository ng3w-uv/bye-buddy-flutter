import 'package:flutter/material.dart';

class QuickCalculateScreen extends StatefulWidget {
  const QuickCalculateScreen({super.key});

  @override
  State<QuickCalculateScreen> createState() => _QuickCalculateScreenState();
}

class _QuickCalculateScreenState extends State<QuickCalculateScreen> {
  final _formKey = GlobalKey<FormState>();
  int _noticePeriod = 60;
  int _plannedLeaves = 0;
  bool _isCustomNoticePeriod = false;
  bool _isCustomLeaves = false;

  void _handleNoticePeriodSelection(int days) {
    setState(() {
      _isCustomNoticePeriod = false;
      _noticePeriod = days;
    });
  }

  void _handleLeavesSelection(int days) {
    setState(() {
      _isCustomLeaves = false;
      _plannedLeaves = days;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final totalDays = _noticePeriod + _plannedLeaves;
    final lastWorkingDay = today.add(Duration(days: totalDays));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Calculate'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'If you resign today',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(today),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.timer_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Notice Period',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPresetChip(30, _noticePeriod == 30,
                                () => _handleNoticePeriodSelection(30)),
                            _buildPresetChip(60, _noticePeriod == 60,
                                () => _handleNoticePeriodSelection(60)),
                            _buildPresetChip(90, _noticePeriod == 90,
                                () => _handleNoticePeriodSelection(90)),
                            FilterChip(
                              label: const Text('Custom'),
                              selected: _isCustomNoticePeriod,
                              onSelected: (selected) {
                                setState(() {
                                  _isCustomNoticePeriod = selected;
                                });
                              },
                            ),
                          ],
                        ),
                        if (_isCustomNoticePeriod) ...[
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notice Period: $_noticePeriod days',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Slider(
                                value: _noticePeriod.toDouble(),
                                min: 0,
                                max: 180,
                                divisions: 180,
                                label: '${_noticePeriod.round()} days',
                                onChanged: (value) {
                                  setState(() {
                                    _noticePeriod = value.round();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.beach_access,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Planned Leaves',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPresetChip(5, _plannedLeaves == 5,
                                () => _handleLeavesSelection(5)),
                            _buildPresetChip(10, _plannedLeaves == 10,
                                () => _handleLeavesSelection(10)),
                            _buildPresetChip(15, _plannedLeaves == 15,
                                () => _handleLeavesSelection(15)),
                            FilterChip(
                              label: const Text('Custom'),
                              selected: _isCustomLeaves,
                              onSelected: (selected) {
                                setState(() {
                                  _isCustomLeaves = selected;
                                });
                              },
                            ),
                          ],
                        ),
                        if (_isCustomLeaves) ...[
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Planned Leaves: $_plannedLeaves days',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Slider(
                                value: _plannedLeaves.toDouble(),
                                min: 0,
                                max: 30,
                                divisions: 30,
                                label: '${_plannedLeaves.round()} days',
                                onChanged: (value) {
                                  setState(() {
                                    _plannedLeaves = value.round();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Your last working day will be',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(lastWorkingDay),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Based on $_noticePeriod days notice period${_plannedLeaves > 0 ? ' + $_plannedLeaves days of planned leaves' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need more options?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Use Custom Calculate to include buy-out options in your calculation',
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/custom-calculate',
                            );
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Go to Custom Calculate'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(int days, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text('$days days'),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
