import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String? initialImagePath;

  const EditProfilePage({
    super.key,
    required this.initialName,
    this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _avatarInitialsController;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isSaving = false;
  String _selectedLevel = 'Beginner';
  
  final List<String> _levelOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
    'Master',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _updateInitials();
    _loadCurrentLevel();
  }
  
  Future<void> _loadCurrentLevel() async {
    final level = await UserService.getUserLevel();
    if (mounted) {
      setState(() {
        _selectedLevel = level;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarInitialsController.dispose();
    super.dispose();
  }

  void _updateInitials() {
    final names = _nameController.text.trim().split(' ');
    String initials = '';
    
    if (names.isNotEmpty && names[0].isNotEmpty) {
      initials += names[0][0];
    }
    if (names.length > 1 && names[1].isNotEmpty) {
      initials += names[1][0];
    }
    
    _avatarInitialsController = TextEditingController(text: initials.toUpperCase());
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Save to SharedPreferences
      await UserService.saveUserData(
        name: _nameController.text,
        initials: _avatarInitialsController.text,
        imagePath: _selectedImage?.path,
      );
      
      // Save level separately
      await UserService.saveUserLevel(_selectedLevel);

      if (mounted) {
        Navigator.pop(context, {
          'name': _nameController.text,
          'initials': _avatarInitialsController.text,
          'imagePath': _selectedImage?.path,
          'level': _selectedLevel,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _getLevelEmoji(String level) {
    switch (level) {
      case 'Beginner':
        return '🌱';
      case 'Intermediate':
        return '🔥';
      case 'Advanced':
        return '⚡';
      case 'Expert':
        return '👑';
      case 'Master':
        return '💎';
      default:
        return '🌱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E27),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Photo Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6366F1).withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color(0xFF6366F1),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Text(
                              _avatarInitialsController.text,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  // Photo Action Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6366F1),
                      border: Border.all(
                        color: const Color(0xFF0F0F1E),
                        width: 2,
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'camera') {
                          _takePhoto();
                        } else if (value == 'gallery') {
                          _pickImage();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'camera',
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt, size: 18),
                              SizedBox(width: 8),
                              Text('Take Photo'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'gallery',
                          child: Row(
                            children: [
                              Icon(Icons.image, size: 18),
                              SizedBox(width: 8),
                              Text('Choose from Gallery'),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Name Input Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {
                        _updateInitials();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: const Color(0xFF6366F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.indigo.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.indigo.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.indigo.withOpacity(0.05),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Level Selection Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.indigo.withOpacity(0.3),
                      ),
                      color: Colors.indigo.withOpacity(0.05),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedLevel,
                      onChanged: (String? newLevel) {
                        if (newLevel != null) {
                          setState(() {
                            _selectedLevel = newLevel;
                          });
                        }
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF1A1E2E),
                      items: _levelOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Text(
                                  _getLevelEmoji(value),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF6366F1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Avatar Initials: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6366F1),
                      ),
                      child: Center(
                        child: Text(
                          _avatarInitialsController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
