import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/booking.dart';
import 'riwayat_booking_screen.dart';

class BookingScreen extends StatefulWidget {
  final void Function(Booking) onBookingAdded;

  const BookingScreen({super.key, required this.onBookingAdded});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _namaPasienController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedDokter;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  final List<Map<String, dynamic>> _dokterList = [
    {
      'name': 'Dokter Umum - dr. Indah',
      'specialty': 'Dokter Umum',
      'experience': '8 tahun',
      'rating': 4.8,
      'icon': Icons.medical_services,
      'color': const Color(0xFF4FC3F7),
    },
    {
      'name': 'Spesialis Kulit - dr. Rina',
      'specialty': 'Spesialis Kulit',
      'experience': '12 tahun',
      'rating': 4.9,
      'icon': Icons.face_retouching_natural,
      'color': const Color(0xFF66BB6A),
    },
    {
      'name': 'Spesialis Gigi - drg. Budi',
      'specialty': 'Spesialis Gigi',
      'experience': '10 tahun',
      'rating': 4.7,
      'icon': Icons.medical_information,
      'color': const Color(0xFFFF7043),
    },
  ];

  final List<Booking> _bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667eea),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667eea),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _konfirmasiBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDokter == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      _showErrorSnackBar('Mohon lengkapi semua data.');
      return;
    }

    setState(() => _isLoading = true);
    _buttonAnimationController.forward();

    final String formattedDate =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final String formattedTime = _selectedTime!.format(context);

    final Map<String, dynamic> dataBooking = {
      'nama': _namaPasienController.text,
      'dokter': _selectedDokter,
      'tanggal': formattedDate,
      'jam': formattedTime,
    };

    try {
      final response = await http.post(
        Uri.parse('http://172.16.0.2:5001/booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataBooking),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newBooking = Booking(
          nama: _namaPasienController.text,
          dokter: _selectedDokter!,
          tanggal: formattedDate,
          jam: formattedTime,
        );

        setState(() {
          _bookingHistory.add(newBooking);
        });
        widget.onBookingAdded(newBooking);

        _showSuccessSnackBar(
          'Booking berhasil! ${newBooking.nama} - ${newBooking.dokter}',
        );

        // Clear form
        _namaPasienController.clear();
        setState(() {
          _selectedDokter = null;
          _selectedDate = null;
          _selectedTime = null;
        });

        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      RiwayatBookingScreen(bookingList: _bookingHistory),
            ),
          );
        });
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ??
            'Gagal mengirim booking ke server.';
        _showErrorSnackBar(errorMsg);
      }
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan saat mengirim booking.');
    } finally {
      setState(() => _isLoading = false);
      _buttonAnimationController.reverse();
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Konsultasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          RiwayatBookingScreen(bookingList: _bookingHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF667eea,
                                  ).withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Buat Janji',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Konsultasi dengan Dokter',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Form Container
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama Pasien Field
                                _buildSectionTitle('Nama Pasien', Icons.person),
                                _buildTextFormField(
                                  controller: _namaPasienController,
                                  hintText: 'Masukkan nama lengkap',
                                  prefixIcon: Icons.person_outline,
                                ),

                                const SizedBox(height: 24),

                                // Pilih Dokter Section
                                _buildSectionTitle(
                                  'Pilih Dokter',
                                  Icons.medical_services,
                                ),
                                const SizedBox(height: 12),
                                ..._dokterList.map(
                                  (dokter) => _buildDokterCard(dokter),
                                ),

                                const SizedBox(height: 24),

                                // Date & Time Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle(
                                            'Tanggal',
                                            Icons.calendar_today,
                                          ),
                                          _buildDateTimeCard(
                                            icon: Icons.calendar_today,
                                            title: 'Pilih Tanggal',
                                            value:
                                                _selectedDate == null
                                                    ? null
                                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                            onTap: _selectDate,
                                            color: const Color(0xFF4FC3F7),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle(
                                            'Waktu',
                                            Icons.access_time,
                                          ),
                                          _buildDateTimeCard(
                                            icon: Icons.access_time,
                                            title: 'Pilih Waktu',
                                            value: _selectedTime?.format(
                                              context,
                                            ),
                                            onTap: _selectTime,
                                            color: const Color(0xFF66BB6A),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Konfirmasi Button
                          AnimatedBuilder(
                            animation: _buttonAnimationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonScaleAnimation.value,
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4FC3F7),
                                        Color(0xFF29B6F6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4FC3F7,
                                        ).withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _konfirmasiBooking,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child:
                                        _isLoading
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Konfirmasi Booking',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF667eea)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF667eea)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
    );
  }

  Widget _buildDokterCard(Map<String, dynamic> dokter) {
    final isSelected = _selectedDokter == dokter['name'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedDokter = dokter['name'];
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? dokter['color'].withOpacity(0.1)
                      : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? dokter['color'] : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dokter['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(dokter['icon'], color: dokter['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dokter['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? dokter['color'] : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dokter['experience']} • ⭐ ${dokter['rating']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: dokter['color'], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeCard({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value != null ? color : Colors.grey.withOpacity(0.3),
              width: value != null ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: value != null ? color : Colors.grey[400],
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                value ?? title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      value != null ? FontWeight.bold : FontWeight.normal,
                  color: value != null ? color : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
