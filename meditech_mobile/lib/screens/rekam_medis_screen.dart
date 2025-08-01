import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan Anda sudah menginstal package intl: flutter pub add intl
import '../models/pasien.dart'; // Model Pasien, digunakan untuk mendapatkan ID pasien
import '../models/medical_record.dart'; // Model MedicalRecord Anda
import '../services/rekam_medis_service.dart'; // Service untuk komunikasi dengan API

class RekamMedisScreen extends StatefulWidget {
  final Pasien currentPasien; // Menerima objek Pasien yang sedang login

  const RekamMedisScreen({super.key, required this.currentPasien});

  @override
  State<RekamMedisScreen> createState() => _RekamMedisScreenState();
}

class _RekamMedisScreenState extends State<RekamMedisScreen> {
  // Controllers untuk TextField input data rekam medis baru
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _diagnosaController = TextEditingController();
  final TextEditingController _tindakanController = TextEditingController();
  final TextEditingController _dokterController = TextEditingController();
  DateTime? _selectedDate; // State untuk menyimpan tanggal konsultasi yang dipilih

  // State untuk data rekam medis yang akan ditampilkan
  List<MedicalRecord> records = [];
  bool isLoading = true; // Indikator loading saat mengambil data
  String? errorMessage; // Pesan error jika terjadi kesalahan

  // State dan controller untuk fitur pencarian
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRecords(); // Panggil fungsi untuk mengambil data saat layar diinisialisasi
  }

  // Fungsi untuk mengambil daftar rekam medis dari backend
  Future<void> fetchRecords() async {
    setState(() {
      isLoading = true; // Set loading true saat mulai fetching
      errorMessage = null; // Reset pesan error sebelumnya
    });
    try {
      // Log ID pasien yang akan digunakan untuk mengambil rekam medis
      print(
        '[RekamMedisScreen] Mengambil rekam medis untuk Pasien ID: ${widget.currentPasien.id}',
      );

      // Panggil service untuk mengambil data rekam medis berdasarkan ID pasien
      final data = await RekamMedisService.fetchRekamMedisByPasienId(
        widget.currentPasien.id ?? '', // Gunakan ID pasien, pastikan tidak null
        // Jika backend Anda memerlukan token untuk otorisasi,
        // Anda harus menyertakannya di sini. Contoh:
        // token: 'token_dari_login_anda', // Ambil dari SharedPreferences/Provider/dll.
      );

      setState(() {
        records = data; // Perbarui daftar rekam medis
        isLoading = false; // Set loading false setelah data diterima
        // Log jumlah dan contoh data yang diterima untuk debugging
        print(
          '[RekamMedisScreen] Jumlah rekam medis diterima: ${records.length}',
        );
        if (records.isNotEmpty) {
          print(
            '[RekamMedisScreen] Contoh rekam medis pertama: ${records[0].toJson()}',
          );
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Simpan pesan error jika gagal
        isLoading = false; // Set loading false
        print(
          '[RekamMedisScreen] Error mengambil rekam medis: $errorMessage',
        ); // Log error
      });
    }
  }

  // ✅ Fungsi untuk menampilkan DatePicker dan memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now(), // Tanggal awal bisa tanggal terpilih atau hari ini
      firstDate: DateTime(2000), // Tanggal paling awal yang bisa dipilih
      lastDate: DateTime(2030), // Tanggal paling akhir yang bisa dipilih
    );
    // Jika tanggal dipilih dan berbeda dari yang sebelumnya, update state
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ✅ Fungsi untuk mengirim data rekam medis baru ke backend
  Future<void> _addRecord() async {
    // Validasi input form di frontend
    if (_keluhanController.text.isEmpty ||
        _diagnosaController.text.isEmpty ||
        _tindakanController.text.isEmpty ||
        _dokterController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Harap lengkapi semua field dan pilih tanggal konsultasi.',
          ),
        ),
      );
      return; // Hentikan fungsi jika validasi gagal
    }

    setState(() {
      isLoading = true; // Tampilkan indikator loading saat proses penambahan
    });

    try {
      final result = await RekamMedisService.createRekamMedis(
        pasienId: widget.currentPasien.id!,
        // ✅ TAMBAHKAN INI: kirim nama_pasien dari objek pasien yang login
        nama_pasien: widget.currentPasien.nama!, // Asumsi widget.currentPasien.nama tidak null
        tanggal: _selectedDate!,
        keluhan: _keluhanController.text,
        diagnosa: _diagnosaController.text,
        tindakan: _tindakanController.text,
        dokter: _dokterController.text,
        // token: userToken, // Kirim token jika diperlukan
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Rekam medis berhasil ditambahkan',
            ),
          ),
        );
        // Bersihkan field form setelah data berhasil disimpan
        _keluhanController.clear();
        _diagnosaController.clear();
        _tindakanController.clear();
        _dokterController.clear();
        _selectedDate = null; // Reset tanggal yang dipilih
        Navigator.of(context).pop(); // Tutup dialog setelah sukses
        await fetchRecords(); // Muat ulang daftar rekam medis agar yang baru terlihat
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menambahkan rekam medis'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat menambah rekam medis: $e')),
      );
    } finally {
      setState(() {
        isLoading =
            false; // Akhiri indikator loading (baik sukses maupun gagal)
      });
    }
  }

  // ✅ Fungsi untuk menampilkan dialog form input rekam medis baru
  void _showAddRecordDialog() {
    // Pastikan semua controller dan state tanggal di-reset setiap kali dialog dibuka
    _keluhanController.clear();
    _diagnosaController.clear();
    _tindakanController.clear();
    _dokterController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Rekam Medis Baru'),
          content: SingleChildScrollView(
            // Memungkinkan konten dialog untuk discroll
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Agar Column tidak mengambil ruang lebih
              children: [
                TextField(
                  controller: _keluhanController,
                  decoration: const InputDecoration(labelText: 'Keluhan'),
                ),
                TextField(
                  controller: _diagnosaController,
                  decoration: const InputDecoration(labelText: 'Diagnosa'),
                ),
                TextField(
                  controller: _tindakanController,
                  decoration: const InputDecoration(labelText: 'Tindakan'),
                ),
                TextField(
                  controller: _dokterController,
                  decoration: const InputDecoration(labelText: 'Dokter'),
                ),
                const SizedBox(height: 10),
                // ListTile untuk memilih tanggal, menggunakan StatefulBuilder agar tanggal di dialog bisa update
                StatefulBuilder(
                  builder: (context, setDialogState) {
                    return ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal Konsultasi'
                            : 'Tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        // Ketika tanggal dipilih, update state dialog
                        await _selectDate(context);
                        setDialogState(
                          () {},
                        ); // Memperbarui tampilan di dalam dialog
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : _addRecord, // Tombol Simpan (nonaktif saat loading)
              child:
                  isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) // Indikator loading
                      : const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter records berdasarkan searchQuery
    final filteredRecords = records.where((record) {
      final query = searchQuery.toLowerCase();
      return record.namaPasien.toLowerCase().contains(query) ||
             record.keluhan.toLowerCase().contains(query) ||
             record.diagnosa.toLowerCase().contains(query) ||
             record.dokter.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Medis')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Cari riwayat medis...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredRecords.isEmpty
                          ? const Center(child: Text('Tidak ada catatan medis ditemukan.'))
                          : ListView.builder(
                              itemCount: filteredRecords.length,
                              itemBuilder: (context, index) {
                                final record = filteredRecords.reversed.toList()[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.medical_services, color: Colors.white, size: 28),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                record.keluhan,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.person, color: Colors.white70, size: 20),
                                            const SizedBox(width: 6),
                                            Text(
                                              record.namaPasien,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              DateFormat('dd MMM yyyy').format(record.tanggal),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.local_hospital, color: Colors.white70, size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Dokter: ${record.dokter}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Diagnosa: ${record.diagnosa}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Tindakan: ${record.tindakan}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordDialog,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Rekam Medis Baru',
      ),
    );
  }

  // ✅ Metode dispose untuk membersihkan controllers
  @override
  void dispose() {
    _keluhanController.dispose();
    _diagnosaController.dispose();
    _tindakanController.dispose();
    _dokterController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
