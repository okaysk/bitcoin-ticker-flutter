// import 'package:bitcoin_ticker/network.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '275CC998-F757-47FD-AB5E-328063BBE918';
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate'; //BTC/USD'

const List<String> currenciesList = ['AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'IDR', 'ILS', 'INR', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'RON', 'RUB', 'SEK', 'SGD', 'USD', 'ZAR'];
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  // Future getCoinData(String bitName, String countryName) async {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices;
    for (String crypto in cryptoList) {
      var requestURL = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
        // return lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
