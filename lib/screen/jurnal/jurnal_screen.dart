import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:parking_spot_log/core/database/database.dart';

@RoutePage()
class JurnalScreen extends StatefulWidget {
  const JurnalScreen({super.key});

  @override
  State<JurnalScreen> createState() => _JurnalScreenState();
}

class _JurnalScreenState extends State<JurnalScreen> {
  final db = AppDatabase();

_formatDate(DateTime date) => DateFormat('dd.MM.yyyy').format(date);

  // ---------------- FULLSCREEN ADD RENTAL ----------------
  void _openFullScreenAddRental(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddRentalScreen(db: db),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "🚗 Parking Journal",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: () => _openFullScreenAddRental(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemYellow,
                  CupertinoColors.systemOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemYellow.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.add,
              color: CupertinoColors.white,
              size: 20,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          child: StreamBuilder<List<TableJournalData>>(
            stream: db.watchJournal(),
            builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final journal = snapshot.data!;
            if (journal.isEmpty) {
              // ---------------- EMPTY STATE ----------------
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.systemYellow.withOpacity(0.1),
                              CupertinoColors.systemOrange.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: CupertinoColors.systemYellow.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.car_fill,
                          size: 60,
                          color: CupertinoColors.systemYellow,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Parking Journal is Empty',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Add your first parking spot record',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: CupertinoColors.secondaryLabel,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.systemYellow,
                              CupertinoColors.systemOrange,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemYellow.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text(
                            'Add Parking Record',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => _openFullScreenAddRental(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ---------------- LIST OF JOURNALS ----------------
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: journal.length,
              itemBuilder: (context, index) {
                final journals = journal[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CupertinoColors.systemYellow.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemYellow.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        ),
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.systemYellow,
                                        CupertinoColors.systemOrange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.systemYellow.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.car_fill,
                                    color: CupertinoColors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Parking Period",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: CupertinoColors.secondaryLabel,
                                          letterSpacing: -0.08,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${_formatDate(journals.startDate)} - ${_formatDate(journals.endDate)}",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.label,
                                          letterSpacing: -0.41,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.systemYellow,
                                        CupertinoColors.systemOrange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.systemYellow.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${journals.price.toStringAsFixed(0)} \$",
                                    style: const TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: -0.08,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (journals.conditions != null && journals.conditions!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.info,
                                        size: 12,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        journals.conditions!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.label,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.08,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed: () => db.deleteJournal(journals.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.delete,
                                      color: CupertinoColors.systemRed,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    
                  ),
                );
              },
            );
          },
        ),
      ),
    ));
  }
}

// ---------------- FULLSCREEN ADD RENTAL SCREEN ----------------
class AddRentalScreen extends StatefulWidget {
  final AppDatabase db;
  const AddRentalScreen({super.key, required this.db});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  final priceController = TextEditingController();
  final conditionsController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));
  
  // Переменные для валидации
  String? priceError;
  String? conditionsError;

  String _formatDate(DateTime date) => DateFormat('dd.MM.yyyy').format(date);

  // Функция валидации
  bool _validateFields() {
    bool isValid = true;
    
    // Price validation
    if (priceController.text.trim().isEmpty) {
      setState(() {
        priceError = 'Enter parking cost';
      });
      isValid = false;
    } else {
      // Check if it's a number
      try {
        double.parse(priceController.text.trim());
        setState(() {
          priceError = null;
        });
      } catch (e) {
        setState(() {
          priceError = 'Enter valid amount';
        });
        isValid = false;
      }
    }
    
    // Conditions validation
    if (conditionsController.text.trim().isEmpty) {
      setState(() {
        conditionsError = 'Enter parking conditions';
      });
      isValid = false;
    } else {
      setState(() {
        conditionsError = null;
      });
    }
    
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Add Parking Record",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            "Done",
            style: TextStyle(
              color: CupertinoColors.systemYellow,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          onPressed: () async {
            if (_validateFields()) {
              await widget.db.addJournal(
                TableJournalCompanion.insert(
                  startDate: startDate,
                  endDate: endDate,
                  price: double.parse(priceController.text.trim()),
                  conditions: drift.Value(conditionsController.text.trim()),
                ),
              );
              Navigator.pop(context);
            } else {
              // Показываем диалог с ошибками
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('⚠️ Validation Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (priceError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '• $priceError',
                          style: const TextStyle(
                            color: CupertinoColors.systemRed,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      if (conditionsError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '• $conditionsError',
                          style: const TextStyle(
                            color: CupertinoColors.systemRed,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              
              // Start date
              _buildIOSTextField(
                label: "Parking Start Date",
                controller: startController..text = _formatDate(startDate),
                readOnly: true,
                onTap: () async {
                  await showCupertinoModalPopup(
                    context: context,
                    builder: (_) => SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: startDate,
                        onDateTimeChanged: (val) {
                          setState(() => startDate = val);
                          startController.text = _formatDate(val);
                        },
                      ),
                    ),
                  );
                },
                icon: CupertinoIcons.car_fill,
              ),
              
              const SizedBox(height: 20),
              
              // End date
              _buildIOSTextField(
                label: "Parking End Date",
                controller: endController..text = _formatDate(endDate),
                readOnly: true,
                onTap: () async {
                  await showCupertinoModalPopup(
                    context: context,
                    builder: (_) => SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: endDate,
                        onDateTimeChanged: (val) {
                          setState(() => endDate = val);
                          endController.text = _formatDate(val);
                        },
                      ),
                    ),
                  );
                },
                icon: CupertinoIcons.location_fill,
              ),
              
              const SizedBox(height: 20),
              
              // Price
              _buildIOSTextField(
                label: "Parking Cost",
                controller: priceController,
                keyboardType: TextInputType.number,
                icon: CupertinoIcons.money_dollar,
                errorText: priceError,
              ),
              
              const SizedBox(height: 20),
              
              // Conditions
              _buildIOSTextField(
                label: "Parking Conditions",
                controller: conditionsController,
                icon: CupertinoIcons.doc_text,
                errorText: conditionsError,
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
              letterSpacing: -0.08,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null 
                    ? CupertinoColors.systemRed.withOpacity(0.5)
                    : CupertinoColors.systemYellow.withOpacity(0.2),
                width: errorText != null ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: errorText != null 
                      ? CupertinoColors.systemRed.withOpacity(0.1)
                      : CupertinoColors.systemYellow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: errorText != null 
                          ? LinearGradient(
                              colors: [
                                CupertinoColors.systemRed,
                                CupertinoColors.systemRed.withOpacity(0.7),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                CupertinoColors.systemYellow,
                                CupertinoColors.systemOrange,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: (errorText != null ? CupertinoColors.systemRed : CupertinoColors.systemYellow).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoTextField(
                      controller: controller,
                      readOnly: readOnly,
                      keyboardType: keyboardType,
                      placeholder: readOnly ? null : "Enter ${label.toLowerCase()}",
                      decoration: const BoxDecoration(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.label,
                        letterSpacing: -0.32,
                      ),
                      placeholderStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.placeholderText,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    const Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                ],
              ),
            ),
          ),
        ),
        // Отображение ошибки
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: CupertinoColors.systemRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CupertinoColors.systemRed.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  size: 16,
                  color: CupertinoColors.systemRed,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
