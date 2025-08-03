import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';


class QrCodePrinting extends StatelessWidget {
  String data;
  QrCodePrinting({required this.data});

  @override
  Widget build(Context context) {
    // TODO: implement build
    return SizedBox(
      height: 70,
      width: 70,
      child: BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: data,
      ),
    );
  }
  
}