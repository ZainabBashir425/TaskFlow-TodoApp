import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedPriority;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isEditing = false;
  bool _isSaving = false;

  // Helper to get dark mode status
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    
    // Parse task data
    final task = widget.task;
    _titleController = TextEditingController(text: task['title'] ?? '');
    _descController = TextEditingController(text: task['description'] ?? '');
    _selectedPriority = task['priority'] ?? 'Low';
    _selectedCategory = task['category'] ?? 'Personal';
    
    // Parse date
    if (task['due_date'] != null) {
      _selectedDate = DateTime.parse(task['due_date']);
    } else {
      _selectedDate = DateTime.now();
    }
    
    // Parse time
    if (task['due_time'] != null) {
      final timeParts = task['due_time'].split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    } else {
      _selectedTime = const TimeOfDay(hour: 12, minute: 0);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF7B61FF),
                    surface: Color(0xFF1E1E1E),
                  )
                : const ColorScheme.light(primary: Color(0xFF7B61FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (!_isEditing) return;
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF7B61FF),
                    surface: Color(0xFF1E1E1E),
                  )
                : const ColorScheme.light(primary: Color(0xFF7B61FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task title cannot be empty")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dueTime =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';
      
      await SupabaseService.client.from('tasks').update({
        'title': _titleController.text,
        'description': _descController.text,
        'priority': _selectedPriority,
        'category': _selectedCategory,
        'due_date': _selectedDate.toIso8601String().split('T')[0],
        'due_time': dueTime,
        //'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', widget.task['id']);

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task updated successfully")),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating task: $e")),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: isDark ? Colors.white : const Color(0xFF7B61FF),
              ),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Task title'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _titleController,
              hintText: 'Enter task title',
              enabled: _isEditing,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Description'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _descController,
              hintText: 'Add details...',
              maxLines: 3,
              enabled: _isEditing,
            ),
            const SizedBox(height: 24),
            Divider(color: isDark ? Colors.white10 : Colors.grey[300]),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildLabelledDropdown(
                    'Priority',
                    _selectedPriority,
                    ['Low', 'Medium', 'High'],
                    _isEditing ? (v) => setState(() => _selectedPriority = v!) : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLabelledDropdown(
                    'Category',
                    _selectedCategory,
                    ['Personal', 'Work', 'Shopping', 'Health'],
                    _isEditing ? (v) => setState(() => _selectedCategory = v!) : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildLabelledDateTile(
                    'Due Date',
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    Icons.calendar_today_outlined,
                    () => _selectDate(context),
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLabelledDateTile(
                    'Time',
                    _selectedTime.format(context),
                    Icons.access_time,
                    () => _selectTime(context),
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Dynamic Button based on mode
            if (_isEditing)
              _buildSaveButton()
            else
              _buildEditButton(),
            
            const SizedBox(height: 12),
            
            // Cancel Button (only shows in edit mode)
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Reset to original values
                    setState(() {
                      _isEditing = false;
                      _titleController.text = widget.task['title'] ?? '';
                      _descController.text = widget.task['description'] ?? '';
                      _selectedPriority = widget.task['priority'] ?? 'Low';
                      _selectedCategory = widget.task['category'] ?? 'Personal';
                      
                      if (widget.task['due_date'] != null) {
                        _selectedDate = DateTime.parse(widget.task['due_date']);
                      }
                      
                      if (widget.task['due_time'] != null) {
                        final timeParts = widget.task['due_time'].split(':');
                        _selectedTime = TimeOfDay(
                          hour: int.parse(timeParts[0]),
                          minute: int.parse(timeParts[1]),
                        );
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- REFACTORED ADAPTIVE WIDGETS ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled 
          ? (isDark ? const Color(0xFF1E1E1E) : Colors.grey[50])
          : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled 
            ? (isDark ? Colors.white12 : Colors.grey[300]!)
            : Colors.transparent,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        style: TextStyle(
          color: enabled 
            ? (isDark ? Colors.white : Colors.black87)
            : (isDark ? Colors.white60 : Colors.grey[600]),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLabelledDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?>? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: onChanged != null
              ? (isDark ? const Color(0xFF1E1E1E) : Colors.grey[50])
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onChanged != null
                ? (isDark ? Colors.white12 : Colors.grey[300]!)
                : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              isExpanded: true,
              style: TextStyle(
                color: onChanged != null
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white60 : Colors.grey[600]),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelledDateTile(
    String label,
    String text,
    IconData icon,
    VoidCallback onTap,
    {bool enabled = true}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: enabled
                ? (isDark ? const Color(0xFF1E1E1E) : Colors.grey[50])
                : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: enabled
                  ? (isDark ? Colors.white12 : Colors.grey[300]!)
                  : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: enabled
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.white60 : Colors.grey[600]),
                  ),
                ),
                const Spacer(),
                Icon(
                  icon,
                  size: 18,
                  color: enabled
                    ? (isDark ? Colors.white54 : Colors.black54)
                    : (isDark ? Colors.white30 : Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFFA28BFF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _toggleEditMode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Edit Task',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFFA28BFF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}