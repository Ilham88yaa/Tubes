import 'package:flutter/material.dart';
import '../models/booking.dart';

class RiwayatBookingScreen extends StatefulWidget {
  final List<Booking> bookingList;

  const RiwayatBookingScreen({super.key, required this.bookingList});

  @override
  State<RiwayatBookingScreen> createState() => _RiwayatBookingScreenState();
}

class _RiwayatBookingScreenState extends State<RiwayatBookingScreen> {
  late List<Booking> _bookingList;

  @override
  void initState() {
    super.initState();
    _bookingList = List<Booking>.from(widget.bookingList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Booking',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _bookingList.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Booking pertama Anda akan muncul di sini',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: Column(
                  children: [
                    // Header Info Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple[400]!,
                            Colors.deepPurple[300]!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Booking',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${_bookingList.length} Appointment',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Booking List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _bookingList.length,
                        itemBuilder: (context, index) {
                          final booking = _bookingList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple[100],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.deepPurple[600],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking.nama,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.medical_services,
                                                  size: 14,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Dr. ${booking.dokter}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: Colors.deepPurple[600],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                booking.tanggal,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 16,
                                                color: Colors.deepPurple[600],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                booking.jam,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
