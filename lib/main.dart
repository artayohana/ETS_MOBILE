import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'ETS PAB - D'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<String> jenis = <String>['Biasa', 'Pelanggan', 'Pelanggan Istimewa'];
// radio buttton { Tidak, Ya};
List<bool> radioButton = [false, false, false, false];
List<String> ProdukyangDijual = ["ABC", "XYZ", "BBB", "WWW"];
List<int> hargaProduk = [100, 200, -500, -100];

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  String tipePelanggan = jenis.first;
  bool hariLibur = false;
  bool saudara = false;

  TextEditingController _nomerNota = TextEditingController();
  TextEditingController _namaPembeli = TextEditingController();
  TextEditingController _jumlahPembelian = TextEditingController();
  TextEditingController _hargappn = TextEditingController(text: '10');
  TextEditingController _hargaDiskon = TextEditingController(text: '0');
  TextEditingController _grandTotal = TextEditingController();
  TextEditingController _uangyangDibayar = TextEditingController();
  TextEditingController _uangKembalian = TextEditingController();
  TextEditingController _kalender = TextEditingController();

  void pembayaran() {
    if (_formKey.currentState!.validate()) {
      
      double diskon = int.parse(_hargaDiskon.text) / 100;
      double ppn = int.parse(_hargappn.text) / 100;
      double totalDiskon = int.parse(_jumlahPembelian.text) * diskon;
      double hargaSetelahDiskon =
          int.parse(_jumlahPembelian.text) - totalDiskon;

      if (hariLibur) {
        hargaSetelahDiskon -= 2500;
      }
      if (saudara) {
        hargaSetelahDiskon -= 5000;
      } else {
        hargaSetelahDiskon += 3000;
      }

      for (var i = 0; i < radioButton.length; i++) {
        if (radioButton[i]) {
          hargaSetelahDiskon += hargaProduk[i];
        }
      }

      double totalppn = hargaSetelahDiskon * ppn;
      double hargaTotal = hargaSetelahDiskon + totalppn;

       //  Jika Inputan uang yang dibayarkan kurang
      if (_uangyangDibayar.text.isNotEmpty) {
        int jumlahUangdibayar = int.parse(_uangyangDibayar.text);

        if (jumlahUangdibayar < hargaTotal) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Uang Kurang'),
            backgroundColor: Colors.red,
          ));
        } else {
          double result = jumlahUangdibayar - hargaTotal;
          _uangKembalian.text = result.toString();
        }
      }

      setState(() {
        _grandTotal.text = hargaTotal.toString();
      });
    }
  }
  // Reset Ulang
  void reset() {
    _formKey.currentState!.reset();
    _nomerNota.clear();
    _namaPembeli.clear();
    _jumlahPembelian.clear();
    _hargappn.clear();
    _hargaDiskon.clear();
    _grandTotal.clear();
    _uangyangDibayar.clear();
    _uangKembalian.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width / 1.1,
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text Atas
                        Text(
                          "FORM-BELANJA",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // Foto
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/cewe.png'),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // NO NOTA
                    buildNomerNota(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // Nama Pembeli
                    buildNamaPembeli(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // Tipe Pelanggan
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: DropdownButtonFormField<String>(
                          value: tipePelanggan,
                          items: jenis
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              tipePelanggan = value!;
                              switch (value as String) {
                                case "Biasa":
                                  _hargaDiskon.text = '0';
                                  break;
                                case "Pelanggan":
                                  _hargaDiskon.text = '2';
                                  break;
                                case "Pelanggan Istimewa":
                                  _hargaDiskon.text = '4';
                                  break;
                                default:
                              }
                            });
                          },
                        )),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // Kalender
                    buildKalender(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // Jumlah pembelian
                    buildJumlahPembelian(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // Diskon
                    builddiskon(),
                    SizedBox(
                      height: 10,
                    ),

                    // RADIO BUTTON LIBUR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hari Libur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                              title: Text('tidak'),
                              value: false,
                              groupValue: hariLibur,
                              onChanged: (value) {
                                setState(() {
                                  hariLibur = value as bool;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: Text('ya'),
                              value: true,
                              groupValue: hariLibur,
                              onChanged: (value) {
                                setState(() {
                                  hariLibur = value as bool;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Radio Button Saudara
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Saudara",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                              title: Text('tidak'),
                              value: false,
                              groupValue: saudara,
                              onChanged: (value) {
                                setState(() {
                                  saudara = value as bool;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: Text('ya'),
                              value: true,
                              groupValue: saudara,
                              onChanged: (value) {
                                setState(() {
                                  saudara = value as bool;
                                });
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // jenis barang yang dibeli
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Jenis Barang yang dibeli",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    for (var item in ProdukyangDijual)
                      CheckboxListTile(
                        title: Text('${item}'.toUpperCase()),
                        value: radioButton[ProdukyangDijual.indexOf(item)],
                        onChanged: (value) {
                          var indexOf = ProdukyangDijual.indexOf(item);
                          setState(() {
                            radioButton[indexOf] = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // PPN
                    buildppn(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // GRAND TOTAL
                    buildTotalHarga(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // UANG YANG DIBAYAR
                    buildUangyangDibayar(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // UANG KEMBALIAN
                    buildUangkembalian(),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // BUTTON PROSES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            pembayaran();
                          },
                          child: Text('PROSES'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green.shade400)),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),

                    // BUTTON RESET
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Halaman Pemberitahuan'),
                                      content: Text(
                                          'Apakah anda yakin menghapus semua data ?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              reset();
                                              Navigator.pop(context);
                                            },
                                            child: Text('iya')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('tidak'))
                                      ],
                                    ));
                            
                          },
                          child: Text('RESET'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                        ))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // NOMER NOTA
  TextFormField buildNomerNota() {
    return TextFormField(
      controller: _nomerNota,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'No.Nota',
          hintText: 'Harap diisi',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "No Nota Wajib Diisi";
        }
      },
    );
  }

  // NAMA PEMBELI
  TextFormField buildNamaPembeli() {
    return TextFormField(
      controller: _namaPembeli,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Nama Pembeli',
          hintText: 'Harap diisi',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Pembeli Wajib Diisi";
        }
      },
    );
  }

  // KALENDER
  TextFormField buildKalender() {
    return TextFormField(
      controller: _kalender,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
        labelText: "Kalender",
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2030));

        if (pickedDate != null) {
          String formatKalender = DateFormat('dd-MM-yyyy').format(pickedDate);
          setState(() {
            _kalender.text = formatKalender;
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Tanggal Beli Wajib Diisi";
        }
      },
    );
  }

  // JUMLAH PEMBELIAN
  TextFormField buildJumlahPembelian() {
    return TextFormField(
      controller: _jumlahPembelian,
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      decoration: InputDecoration(
        labelText: 'Jumlah Pembelian',
        hintText: 'inputkan angka',
        prefix: Text('Rp. '),
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah Beli Wajib Diisi";
        }
      },
    );
  }

  // DISKON
  TextFormField builddiskon() {
    return TextFormField(
      controller: _hargaDiskon,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'diskon',
        hintText: 'otomatis',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  // PPN
  TextFormField buildppn() {
    return TextFormField(
      controller: _hargappn,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
          labelText: 'PPN',
          hintText: 'biaya operasional',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder()),
    );
  }

  // TOTAL HARGA
  TextFormField buildTotalHarga() {
    return TextFormField(
      controller: _grandTotal,
      decoration: InputDecoration(
          labelText: 'Grand Total',
          enabled: false,
          prefix: Text('Rp. '),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  // UANG YANG DIBAYAR
  TextFormField buildUangyangDibayar() {
    return TextFormField(
      controller: _uangyangDibayar,
      decoration: InputDecoration(
          labelText: 'Uang Yang Dibayar',
          prefix: Text('Rp. '),
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  // UANG KEMBALIAN
  TextFormField buildUangkembalian() {
    return TextFormField(
      controller: _uangKembalian,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      enabled: false,
      decoration: InputDecoration(
          labelText: 'Uang Kembalian',
          prefix: Text('Rp. '),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }
}
