import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculation_result_screen.dart';
import 'package:intl/intl.dart';

class CustomCalculateScreen extends StatefulWidget {
  const CustomCalculateScreen({super.key});

  @override
  State<CustomCalculateScreen> createState() => _CustomCalculateScreenState();
}

class _CustomCalculateScreenState extends State<CustomCalculateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastWorkingDay;
  int _plannedLeaves = 0;
  bool _includeBuyout = false;
  int _noticePeriod = 60;
  final _salaryController = TextEditingController();
  final _buyoutPercentController = TextEditingController(text: '100');
  final _currencyFormat = NumberFormat("#,##,###", "en_IN");

  bool _isCustomNoticePeriod = false;
  bool _isCustomLeaves = false;

  @override
  void dispose() {
    _salaryController.dispose();
    _buyoutPercentController.dispose();
    super.dispose();
  }

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

  String? _formatNumber(String value) {
    if (value.isEmpty) return null;
    final number = int.tryParse(value.replaceAll(',', ''));
    if (number == null) return null;
    return _currencyFormat.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Calculate'),
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
                _buildSectionTitle(context, 'Last Working Day'),
                Card(
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _selectLastWorkingDay,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
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
                              Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lastWorkingDay == null
                                      ? 'Select Your Last Working Day'
                                      : 'Selected: ${_formatDate(_lastWorkingDay!)}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                if (_lastWorkingDay == null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to choose a date',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Notice Period'),
                Card(
                  elevation: 2,
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
                _buildSectionTitle(context, 'Planned Leaves'),
                Card(
                  elevation: 2,
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
                _buildSectionTitle(context, 'Buy-out Option'),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Include buy-out calculation'),
                        subtitle: const Text(
                          'Calculate the cost of buying out your notice period',
                        ),
                        value: _includeBuyout,
                        onChanged: (bool value) {
                          setState(() {
                            _includeBuyout = value;
                          });
                        },
                      ),
                      if (_includeBuyout) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _salaryController,
                                decoration: InputDecoration(
                                  labelText: 'Monthly In-hand Salary',
                                  helperText:
                                      'Enter your current monthly salary',
                                  prefixText: '₹ ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  final formatted = _formatNumber(value);
                                  if (formatted != null) {
                                    _salaryController.value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                        offset: formatted.length,
                                      ),
                                    );
                                  }
                                },
                                validator: _includeBuyout
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your salary';
                                        }
                                        if (int.tryParse(
                                                  value.replaceAll(',', ''),
                                                ) ==
                                                null ||
                                            int.parse(
                                                  value.replaceAll(',', ''),
                                                ) <
                                                1) {
                                          return 'Please enter a valid salary';
                                        }
                                        return null;
                                      }
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _buyoutPercentController,
                                decoration: InputDecoration(
                                  labelText: 'Buy-out Percentage',
                                  helperText:
                                      'Percentage of salary to be paid for buy-out',
                                  suffixText: '%',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _includeBuyout
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter buy-out percentage';
                                        }
                                        final percent = int.tryParse(value);
                                        if (percent == null ||
                                            percent < 1 ||
                                            percent > 100) {
                                          return 'Please enter a valid percentage (1-100)';
                                        }
                                        return null;
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _calculateResignationDate,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Calculate Resignation Date'),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _selectLastWorkingDay() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _lastWorkingDay ?? DateTime.now().add(const Duration(days: 60)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _lastWorkingDay = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }

  void _calculateResignationDate() {
    if (!_formKey.currentState!.validate() || _lastWorkingDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final today = DateTime.now();

    // If selected last working day is in the past, show error
    if (_lastWorkingDay!.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Last working day cannot be in the past'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get notice period
    final noticePeriod = _noticePeriod;

    // Calculate total required days (notice period + planned leaves)
    final totalRequiredDays = noticePeriod + _plannedLeaves;

    // Calculate when you should resign to accommodate both notice period and leaves
    DateTime requiredResignationDate = _lastWorkingDay!.subtract(
      Duration(days: totalRequiredDays),
    );

    // Calculate buy-out days if needed
    double? buyoutAmount;
    int? buyoutDays;

    // If required resignation date is before today, we need buy-out
    if (requiredResignationDate.isBefore(today)) {
      // Calculate actual last working day if resigning today
      DateTime actualLastWorkingDay = today.add(
        Duration(days: totalRequiredDays),
      );

      // Calculate days that need to be bought out
      buyoutDays = actualLastWorkingDay.difference(_lastWorkingDay!).inDays;

      if (_includeBuyout && buyoutDays > 0) {
        final monthlySalary = double.parse(
          _salaryController.text.replaceAll(',', ''),
        );
        final buyoutPercent = double.parse(_buyoutPercentController.text) / 100;
        final dailySalary = monthlySalary / 30;
        buyoutAmount = dailySalary * buyoutDays * buyoutPercent;
      }

      // Update resignation date to today since we need buy-out
      requiredResignationDate = today;
    }

    // Navigate to results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculationResultScreen(
          lastWorkingDay: _lastWorkingDay!,
          resignationDate: requiredResignationDate,
          noticePeriod: noticePeriod,
          plannedLeaves: _plannedLeaves,
          includeBuyout:
              _includeBuyout && buyoutAmount != null && buyoutDays != null,
          buyoutAmount: buyoutAmount,
          buyoutDays: buyoutDays,
          actualLastWorkingDay: requiredResignationDate.add(
            Duration(days: totalRequiredDays),
          ),
          idealResignationDate: _lastWorkingDay!.subtract(
            Duration(days: noticePeriod),
          ),
        ),
      ),
    );
  }
}
