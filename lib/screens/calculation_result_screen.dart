import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculationResultScreen extends StatelessWidget {
  final DateTime lastWorkingDay;
  final DateTime resignationDate;
  final DateTime actualLastWorkingDay;
  final DateTime idealResignationDate;
  final int noticePeriod;
  final int plannedLeaves;
  final bool includeBuyout;
  final double? buyoutAmount;
  final int? buyoutDays;

  const CalculationResultScreen({
    super.key,
    required this.lastWorkingDay,
    required this.resignationDate,
    required this.actualLastWorkingDay,
    required this.idealResignationDate,
    required this.noticePeriod,
    required this.plannedLeaves,
    required this.includeBuyout,
    this.buyoutAmount,
    this.buyoutDays,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##,###.00", "en_IN");
    final bool showBuyout =
        includeBuyout && buyoutAmount != null && buyoutDays != null;
    final bool datesAreDifferent =
        lastWorkingDay.difference(actualLastWorkingDay).inDays != 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Result'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Important Dates',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateCard(
                    context,
                    title: 'You Need to Resign On',
                    subtitle: datesAreDifferent
                        ? 'To achieve your desired last working day'
                        : 'To complete your notice period',
                    date: resignationDate,
                    icon: Icons.notification_important,
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 16),
                  _buildDateCard(
                    context,
                    title: datesAreDifferent
                        ? 'Your Desired Last Working Day'
                        : 'Your Last Working Day',
                    subtitle: datesAreDifferent
                        ? 'Requires buy-out'
                        : 'After completing notice period',
                    date: lastWorkingDay,
                    icon: Icons.work_off,
                    isHighlighted: datesAreDifferent,
                  ),
                  if (datesAreDifferent && showBuyout) ...[
                    const SizedBox(height: 16),
                    _buildDateCard(
                      context,
                      title: 'Regular Last Working Day',
                      subtitle: 'Without buy-out option',
                      date: actualLastWorkingDay,
                      icon: Icons.event_available,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Notice Period Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(
                            context,
                            'Standard Notice Period',
                            '$noticePeriod days',
                          ),
                          if (plannedLeaves > 0) ...[
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              context,
                              'Planned Leaves',
                              '$plannedLeaves days',
                              subtitle: 'Extends your notice period',
                            ),
                          ],
                          if (datesAreDifferent && showBuyout) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.monetization_on_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Buy-out Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow(
                              context,
                              'Days to Buy-out',
                              '$buyoutDays days',
                              subtitle: 'Number of days you need to buy out',
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              context,
                              'Buy-out Amount',
                              '₹ ${currencyFormat.format(buyoutAmount)}',
                              isHighlighted: true,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Buy-out Calculation:',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'If you resign on ${DateFormat('dd MMMM, yyyy').format(resignationDate)}:',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Regular last working day would be ${DateFormat('dd MMMM, yyyy').format(actualLastWorkingDay)}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• To leave on ${DateFormat('dd MMMM, yyyy').format(lastWorkingDay)}, you need to buy out $buyoutDays days',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Please confirm the exact buy-out amount and policy with your HR department',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.calculate),
                label: const Text('New Calculation'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon: Save/Share functionality'),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Results'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required DateTime date,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    final dateFormat = DateFormat('dd MMMM, yyyy');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color:
          isHighlighted ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isHighlighted
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormat.format(date),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isHighlighted
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    String? subtitle,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isHighlighted ? FontWeight.bold : null,
                      color: isHighlighted
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
