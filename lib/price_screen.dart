import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform; // only using Platform in the dart:io
// import 'dart:io' hide Platform; // only not using Platform in the dart:io

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String selectedRate = '?';

  @override
  void initState() {
    super.initState();
    getData();
    // getBitcoinData();
    // updateUI(widget.coinData);
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency, //default value to show
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(); // update the data!!
        });
        print(selectedCurrency);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = []; // 꼭 []; 빈 리스트를 만들어줘야 돼. 걍 pickteritems; 만 하면 안됨
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      // backgroundColor: Colors.lightblue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData(); // update the data!!
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = true;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }
  // void getBitcoinData(String curType) async {
  //   var coinData1 = await CoinModel().getCoin(curType, selectedCurrency);
  //   // var coinData2 = await CoinModel().getCoin(currenciesList[1], selectedCurrency);
  //   // var coinData3 = await CoinModel().getCoin(currenciesList[2], selectedCurrency);
  //   // print(coinData1);
  //   print(coinData1['rate']);
  //   selectedRate = coinData1['rate'].toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: <Widget>[
                CryptoCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? '?' : coinValues['BTC'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  cryptoCurrency: 'ETH',
                  value: isWaiting ? '?' : coinValues['ETH'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? '?' : coinValues['LTC'],
                  selectedCurrency: selectedCurrency,
                ),
                // CryptoCard(cryptoCurrency: selectedCurrency: selectedCurrency),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: androidDropdown(),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(), //ternary
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key key,
    @required this.cryptoCurrency,
    @required this.value,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String selectedCurrency;
  final String value;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
