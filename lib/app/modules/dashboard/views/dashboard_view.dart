import 'package:app1/app/data/headline_response.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
final ScrollController scrollController = ScrollController();
final auth = GetStorage();
    return SafeArea(
    // Widget SafeArea menempatkan semua konten widget ke dalam area yang aman (safe area) dari layar.
    child: DefaultTabController(
      length: 4,
      // Widget DefaultTabController digunakan untuk mengatur tab di aplikasi.
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
        onPressed: () async {
        await auth.erase();
        Get.offAll(() => const HomeView());
  },
  backgroundColor: Colors.redAccent,
  child: const Icon(Icons.logout_rounded),
),
        // Widget Scaffold digunakan sebagai struktur dasar aplikasi.
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          // Widget PreferredSize digunakan untuk menyesuaikan tinggi appBar.
          child: Column(
            // Widget Column adalah widget yang menyatukan widget-childnya secara vertikal.
            children: [
              ListTile(
                // Widget ListTile digunakan untuk menampilkan tampilan list sederhana.
                title: const Text(
                  "Hallo!",
                  textAlign: TextAlign.end,
                  // Properti textAlign digunakan untuk menentukan perataan teks.
                ),
                subtitle: Text(
                  auth.read('full_name').toString(),
                  textAlign: TextAlign.end,
                ),
                trailing: Container(
                  // Widget Container digunakan untuk mengatur tampilan konten dalam kotak.
                  margin: const EdgeInsets.only(right: 10),
                  // Properti margin digunakan untuk menentukan jarak dari tepi kontainer ke tepi widget yang di dalamnya.
                  width: 50.0,
                  height: 50.0,
                  child: Lottie.network(
                    // Widget Lottie.network digunakan untuk menampilkan animasi Lottie dari suatu URL.
                    'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                    fit: BoxFit.cover,
                    // Properti fit digunakan untuk menyesuaikan ukuran konten agar sesuai dengan kontainer.
                  ),
                ),
              ),
              const Align(
                // Widget Align digunakan untuk menempatkan widget pada posisi tertentu di dalam widget induk.
                alignment: Alignment.topLeft,
                // Properti alignment digunakan untuk menentukan letak widget di dalam widget induk.
                child: TabBar(
                  // Widget TabBar digunakan untuk menampilkan tab di aplikasi.
                  labelColor: Colors.black,
                  // Properti labelColor digunakan untuk menentukan warna teks tab yang dipilih.
                  indicatorSize: TabBarIndicatorSize.label,
                  // Properti indicatorSize digunakan untuk menentukan ukuran indikator tab yang dipilih.
                  isScrollable: true,
                  // Properti isScrollable digunakan untuk menentukan apakah tab dapat di-scroll atau tidak.
                  indicatorColor: Colors.white,
                  // Properti indicatorColor digunakan untuk menentukan warna indikator tab yang dipilih.
                  tabs: [
                    // Properti tabs digunakan untuk menentukan teks yang akan ditampilkan pada masing-masing tab.
                    Tab(text: "Headline"),
                    Tab(text: "Teknologi"),
                    Tab(text: "Olahraga"),
                    Tab(text: "Hiburan"),
                  ],
                ),
              ),
            ],
          ),
        ),
       body: TabBarView(
          children: [
            headline(controller, scrollController),
      ]),
    ),
    ),
  );
  }
}



    FutureBuilder<headlineResponse> headline(DashboardController controller, ScrollController scrollController) {
  return FutureBuilder<headlineResponse>(
    // Mendapatkan future data headline dari controller
    future: controller.getHeadline(),
    builder: (context, snapshot) {
      // Jika koneksi masih dalam keadaan waiting/tunggu, tampilkan widget Lottie loading
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Lottie.network(
            // Menggunakan animasi Lottie untuk tampilan loading
            'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
            repeat: true,
            width: MediaQuery.of(context).size.width / 1,
          ),
        );
      }
      // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
      if (!snapshot.hasData) {
        return const Center(child: Text("Tidak ada data"));
      }

      // Jika data diterima, tampilkan daftar headline dalam bentuk ListView.Builder
      return ListView.builder(
        itemCount: snapshot.data!.data!.length,
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Tampilan untuk setiap item headline dalam ListView.Builder
          return Container(
            padding: const EdgeInsets.only(
              top: 5,
              left: 8,
              right: 8,
              bottom: 5,
            ),
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget untuk menampilkan gambar headline dengan menggunakan url gambar dari data yang diterima
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    snapshot.data!.data![index].urlToImage.toString(),
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Widget untuk menampilkan judul headline dengan menggunakan data yang diterima
                      Text(
                        snapshot.data!.data![index].title.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Widget untuk menampilkan informasi author dan sumber headline dengan menggunakan data yang diterima
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Author : ${snapshot.data!.data![index].author}'),
                          Text('Sumber :${snapshot.data!.data![index].name}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
  