import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:parking_spot_log/core/database/database.dart';

@RoutePage()
class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

final db = AppDatabase();

void _openFullScreenAddRental(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddNoteScreen(db: db),
      ),
    );
  }
  String _formatDate(DateTime date) => DateFormat('dd.MM.yyyy').format(date);

 

  // Подтверждение удаления
  void _showDeleteConfirmation(TableNoteData note) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗑️ Delete Note'),
        content: Text('Are you sure you want to delete note "${note.name}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () async {
              try {
                await db.deleteNote(note.id);
                Navigator.of(context).pop();
              } catch (e) {
                print('Error deleting note: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  // Edit note
  void _editNote(TableNoteData note) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => EditNoteScreen(db: db, note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('📝 Parking Notes',
         style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
         backgroundColor: CupertinoColors.white,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child:  Container(
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
           onPressed: () => _openFullScreenAddRental(context)) ,

      ),
      child: SafeArea(
        child:StreamBuilder<List<TableNoteData>>(
          stream: db.watchNote(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center();
            }

            final note = snapshot.data!;
            if(note.isEmpty){
                return Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Красивая иконка с градиентом парковки
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  CupertinoColors.systemYellow.withOpacity(0.1),
                                  CupertinoColors.systemOrange.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                color: CupertinoColors.systemYellow.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemYellow.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    CupertinoColors.systemYellow,
                                    CupertinoColors.systemOrange,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(68),
                              ),
                              child: const Icon(
                                CupertinoIcons.car_fill,
                                size: 70,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Title
                          const Text(
                            'No Notes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: CupertinoColors.label,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Description
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              'Create your first note\nfor important records and reminders',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: CupertinoColors.secondaryLabel,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 50),
                          
                          // Красивая кнопка парковки
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  CupertinoColors.systemYellow,
                                  CupertinoColors.systemOrange,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
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
                              onPressed: () => _openFullScreenAddRental(context),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.car_fill,
                                    color: CupertinoColors.white,
                                    size: 22,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Create Parking Note',
                                    style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Дополнительная информация
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: CupertinoColors.systemYellow.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.car_fill,
                                  color: CupertinoColors.systemYellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Parking notes are saved locally on your device',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.systemYellow,
                                    ),
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
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: note.length,
              itemBuilder: (context, index) {
                final not = note[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child:  Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок с иконкой
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
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
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  CupertinoIcons.car_fill,
                                  color: CupertinoColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      not.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.label,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(not.createdAt),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                CupertinoButton(
                                 padding: EdgeInsets.zero,
                                 minSize: 0,
                                 onPressed: () {
                                   _editNote(not);
                              },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemYellow.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.pencil,
                                    color: CupertinoColors.systemYellow,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              // Кнопка удаления
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => _showDeleteConfirmation(not),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    color: CupertinoColors.systemRed,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Описание
                          if (not.description.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                not.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: CupertinoColors.label,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );

              });
          }
          
        )
      )
    );
  }
}


class AddNoteScreen extends StatefulWidget {
  final AppDatabase db;
  const AddNoteScreen({super.key, required this.db});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Validation variables
  String? nameError;
  String? descriptionError;

  // Validation function
  bool _validateFields() {
    bool isValid = true;
    
    // Name validation
    if (nameController.text.trim().isEmpty) {
      setState(() {
        nameError = 'Enter parking spot name';
      });
      isValid = false;
    } else {
      setState(() {
        nameError = null;
      });
    }
    
    // Description validation
    if (descriptionController.text.trim().isEmpty) {
      setState(() {
        descriptionError = 'Enter parking description';
      });
      isValid = false;
    } else {
      setState(() {
        descriptionError = null;
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
          "Create Note",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.white,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: CupertinoColors.systemYellow,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Красивый заголовок парковки
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CupertinoColors.systemYellow.withOpacity(0.1),
                        CupertinoColors.systemOrange.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: CupertinoColors.systemYellow.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.systemYellow,
                              CupertinoColors.systemOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
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
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Create new parking note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Name
                _buildBeautifulTextField(
                  label: "Parking Spot Name",
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  icon: CupertinoIcons.car_fill,
                  errorText: nameError,
                ),
                
                const SizedBox(height: 24),
                
                // Description
                _buildBeautifulTextField(
                  label: "Parking Description",
                  controller: descriptionController,
                  maxLines: 5,
                  icon: CupertinoIcons.location_fill,
                  errorText: descriptionError,
                ),
                
                const SizedBox(height: 40),
                
                // Красивая кнопка сохранения парковки
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CupertinoColors.systemYellow,
                        CupertinoColors.systemOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                    onPressed: () async {
                      if (_validateFields()) {
                        await widget.db.addNote(
                          TableNoteCompanion(
                            name: drift.Value(nameController.text.trim()),
                            description: drift.Value(descriptionController.text.trim()),
                            createdAt: drift.Value(DateTime.now())
                          )
                        );
                        Navigator.pop(context);
                      } else {
                        // Show error dialog
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('⚠️ Validation Error'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (nameError != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '• $nameError',
                                    style: const TextStyle(
                                      color: CupertinoColors.systemRed,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                if (descriptionError != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '• $descriptionError',
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.car_fill,
                          color: CupertinoColors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save Parking Note',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeautifulTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    int? maxLines,
    IconData? icon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: errorText != null 
                      ? CupertinoColors.systemRed 
                      : CupertinoColors.systemYellow,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label,
                  letterSpacing: -0.08,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              minHeight: maxLines != null ? 120 : 56,
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null 
                    ? CupertinoColors.systemRed.withOpacity(0.5)
                    : CupertinoColors.systemYellow.withOpacity(0.2),
                width: errorText != null ? 2 : 2,
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
              padding: const EdgeInsets.all(16),
              child: CupertinoTextField(
                controller: controller,
                readOnly: readOnly,
                keyboardType: keyboardType,
                maxLines: maxLines,
                placeholder: readOnly ? null : "Enter ${label.toLowerCase()}",
                decoration: const BoxDecoration(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.label,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
                placeholderStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.placeholderText,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
        // Error display
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

class EditNoteScreen extends StatefulWidget {
  final AppDatabase db;
  final TableNoteData note;
  
  const EditNoteScreen({super.key, required this.db, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.note.name);
    descriptionController = TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Edit Parking Note",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.white,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            "Save",
            style: TextStyle(
              color: CupertinoColors.systemYellow,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          onPressed: () async {
            if (nameController.text.isNotEmpty || descriptionController.text.isNotEmpty) {
              try {
                await widget.db.update(widget.db.tableNote)
                  ..where((tbl) => tbl.id.equals(widget.note.id))
                  ..write(TableNoteCompanion(
                    name: drift.Value(nameController.text),
                    description: drift.Value(descriptionController.text),
                  ));
                Navigator.pop(context);
              } catch (e) {
                print('Error updating note: $e');
              }
            }
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Name
              _buildBeautifulTextField(
                label: "Parking Spot Name",
                controller: nameController,
                keyboardType: TextInputType.name,
                icon: CupertinoIcons.car_fill,
              ),
              
              const SizedBox(height: 24),
              
              // Description
              _buildBeautifulTextField(
                label: "Parking Description (optional)",
                controller: descriptionController,
                maxLines: 5,
                icon: CupertinoIcons.location_fill,
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeautifulTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    int? maxLines,
    IconData? icon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: errorText != null 
                      ? CupertinoColors.systemRed 
                      : CupertinoColors.systemYellow,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label,
                  letterSpacing: -0.08,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              minHeight: maxLines != null ? 120 : 56,
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null 
                    ? CupertinoColors.systemRed.withOpacity(0.5)
                    : CupertinoColors.systemYellow.withOpacity(0.2),
                width: errorText != null ? 2 : 2,
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
              padding: const EdgeInsets.all(16),
              child: CupertinoTextField(
                controller: controller,
                readOnly: readOnly,
                keyboardType: keyboardType,
                maxLines: maxLines,
                placeholder: readOnly ? null : "Enter ${label.toLowerCase()}",
                decoration: const BoxDecoration(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.label,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
                placeholderStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.placeholderText,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
        // Error display
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