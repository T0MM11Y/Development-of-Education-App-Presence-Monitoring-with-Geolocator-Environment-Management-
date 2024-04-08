import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:user_interface/app/material/bottomnav.dart';
import 'package:user_interface/app/routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final GetStorage storage = GetStorage();

  DashboardView({Key? key}) : super(key: key);

  Stream<DateTime> _timeStream =
      Stream.periodic(Duration(seconds: 1), (i) => DateTime.now());

  String greeting(DateTime now) {
    var hour = now.hour;
    if (hour < 12) {
      return 'Good Morning ';
    }
    if (hour < 17) {
      return 'Good Afternoon  ';
    }
    return 'Good Night ';
  }

  String formattedDate =
      DateFormat('yyyy-MM-dd – hh:mm a', 'id').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = storage.read('user');
    String fullName = '${user['Nama_Depan']} ${user['Nama_Belakang']}';
    return WillPopScope(
      onWillPop: () async {
        return await Get.defaultDialog<bool>(
              title: 'Konfirmasi',
              middleText: 'Apakah Anda ingin keluar?',
              textConfirm: 'Ya',
              textCancel: 'Tidak',
              confirmTextColor: Colors.white,
              onConfirm: () => Get.back(result: true),
              onCancel: () => Get.back(result: false),
            ) ??
            false; // return false if dialog is dismissed
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<DateTime>(
          stream: _timeStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DateTime now = snapshot.data!;
              String formattedDate =
                  DateFormat('yyyy-MM-dd – hh:mm a', 'id').format(now);

              return Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 13.0,
                            top: 60.0,
                          ),
                          child: Image.asset('assets/images/AppBar.png',
                              width: 185),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 13.0,
                            top: 60.0,
                            left: 65.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50, // 2x radius
                                height: 60, // 2x radius
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors
                                        .blue, // Change this color to the one you want
                                    width:
                                        3.0, // Change this width to the one you want
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: Image(
                                              image: controller
                                                      .imageUrl.value.isNotEmpty
                                                  ? NetworkImage(
                                                      controller.imageUrl.value)
                                                  : AssetImage(
                                                          'assets/images/default_profile.png')
                                                      as ImageProvider<
                                                          Object>, // replace with your default image
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        controller.imageUrl.value.isNotEmpty
                                            ? NetworkImage(
                                                controller.imageUrl.value)
                                            : null,
                                    radius: 30,
                                    child: controller.imageUrl.value.isEmpty
                                        ? Text(
                                            '${user['Nama_Depan'][0]}${user['Nama_Belakang'][0]}',
                                            style: TextStyle(fontSize: 24),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ), // Add some space between the avatar and the text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['Nama_Depan'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user['NISN'].toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user['kelas']['nama_kelas'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 13.0), // Reduce the top padding
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting(now),
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Inconsolata',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$formattedDate',
                              style: TextStyle(
                                fontFamily: 'Inconsolata',
                                fontSize: 15,
                                color: Color.fromARGB(255, 110, 110, 110),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0,
                                  right: 2.0,
                                  left: 6.0), // Reduce the top padding
                              child: Container(
                                width: 350, // Set the width as needed
                                height: 43, // Set the height as needed
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.9,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    left: 0.3, right: 22), // Add padding
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons
                                            .check_circle_outline), // Add your icon here
                                        SizedBox(
                                            width:
                                                10.0), // Add some space between the icon and the text
                                        Obx(() => Text(
                                              'Status: ${controller.status.value}',
                                              style: TextStyle(
                                                color: controller
                                                            .status.value ==
                                                        'Terlambat'
                                                    ? Colors.red
                                                    : controller.status.value ==
                                                            'Hadir'
                                                        ? Colors.green
                                                        : null,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons
                                            .access_time), // Add your icon here
                                        SizedBox(
                                            width:
                                                10.0), // Add some space between the icon and the text
                                        Obx(() => Text(
                                              'Waktu: ${controller.waktu.value}',
                                              style: TextStyle(
                                                color: controller.waktu.value
                                                            .isEmpty ||
                                                        controller
                                                                .waktu.value ==
                                                            '-'
                                                    ? Colors.black
                                                    : Color.fromARGB(
                                                        255, 110, 110, 110),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0, // Adjust this as needed
                        mainAxisSpacing: 5, // Adjust this as needed
                        crossAxisSpacing: 18, // Adjust this as needed
                        padding: const EdgeInsets.all(30), // Add padding here
                        children: [
                          _buildMenuCard(
                              'Absensi', 'assets/images/absensi.png'),
                          _buildMenuCard('Kelas', 'assets/images/class.png'),
                          _buildMenuCard('Roster', 'assets/images/roster.png'),
                          _buildMenuCard(
                              'Pengumuman', 'assets/images/pengumuman.png'),
                          _buildMenuCard('Guru', 'assets/images/guru.png'),
                          _buildMenuCard(
                              'TanyaJawab', 'assets/images/tanyajawab.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          initialActiveIndex: 0,
          onTap: (int i) async {
            switch (i) {
              case 0: // Home
                Get.offNamed(Routes.DASHBOARD);
                break;
              case 1: // Absensi
                bool? shouldAbsen = await Get.defaultDialog<bool>(
                  title: 'Konfirmasi Absensi',
                  middleText: 'Absensi sekarang?',
                  textConfirm: 'Ya',
                  textCancel: 'Tidak',
                  confirmTextColor: Colors.white,
                  onConfirm: () => Get.back(result: true),
                  onCancel: () => Get.back(result: false),
                );

                if (shouldAbsen == true) {
                  controller.createAbsensi();
                }
                break;
              case 2: // Profile
                Get.offNamed(Routes.PROFILE);
                break;
            }
            print('click index=$i');
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, String imagePath) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: () {
          if (title == 'Absensi') {
            Get.toNamed(Routes.HISTORY_ABSENSI); // replace with your Absensi route
          }
        },
        child: Card(
          color: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.9,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(9.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 90, height: 105),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
