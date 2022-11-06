
import 'package:gsheets/gsheets.dart';

class GSheetsAPI {
  static const credentials = r'''
{
  "type": "service_account",
  "project_id": "expense-tracker-367620",
  "private_key_id": "79029b5ea99a6d28582779395b77e3a173acd7e1",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCC/Fmih8nRk1uU\ntIFN7x1g61XSg9vETapM+Z1EKyPcOPoi6NDnLdXTJxaobrwytq1jy8PQUyjzxRsc\nx9+Q4a5v/xCyp66IS682u3tiNu0TTQYv5vPr4wBHj/ZIaufjb9XM9aeJBDPLA2Z7\n4ApQxPNGyZJzVg2351MolRjuy6iwUIbGvrv1W99PBOY2eIKnjU4iUJQeYqttR56W\n+ZhtM4igsiCozw3CwOjvICoh/ToQPwJwe6nVFYo8ecvZkR299MWwiwHdjF4I3oWe\nHR7mweCAsGhodWJruug2kc8dxoZHOu7jFOxjlt2oJ0vtlhAF1WsYFxui0Q+J/7sO\nJd7mppxFAgMBAAECggEAEnQc6LH6s+TvxQ59HQ6v8+STzbm373sFoByWlHEDd1Yr\nn1lvfPJPKpVaMtaO+xITcXjWmHXu0hEV1cMu8wloeuzTXGgVRaxr/ekB4/9a/Rof\n4gXGnZf4hRx6FQ/CpZ8u3tZJCRundFWBTbhtm51zrKhfUpJwElWruI7w2Uul81jh\nWySW6H4m2UcWnm9bMG0hfjek6LzLEUgK78JoE4JOSd3lirfOr/LDKiKn7VsnSkmo\nxkGrS/6FT9iYppQ4sEnliAEcP69qX7rnHzJnvXfTMnibrzmQhxMSubF+xHsq+MFI\n6m3VGGY2wDqY8sylZs3Oa382HXi+feVZRvSuT8GN7QKBgQC3geT48sKgHqy4sCvi\nRXJTeISqZ4VCzCwaNJmYOcMaOPbPudXDG0bKvrg2JzV/QxxUtuOw1Igzdfr6Oy98\nw/2MM0JUVovBZlo3IHeKCCofyCF/S/kjk6FCtd/cmRGLcuQDQGD3OX3tBddDg/Tx\nwlkW+dibh3lyExKEWDvIHV3v1wKBgQC2uvCbaguGy3oI8EyGqLBC9vS5GVSVS3wO\nIrudOB1I4uNlxFIPoYfzTH+E2da2Pe3GQ+/vFdnpVAPBFrfvNPOnH4zSqLMWKBiX\nvecLvLH2uWU7r5F2la2hC5JamtWoLbIC9irHjDahi59hrm4txy5wMmJHTcDPmrLJ\n9VONv8cBQwKBgAKvbOlTrBNpv39IXKwH9h9QkShpMWMD19VeVa0Lk1ZL5RivEHi1\nanjHB60LL9Y35i87KePJiGCwZkbJHO3HdGtbyKmxRoRC+ij6WaV0byFd7VeOhgvG\nOkLepHL27nHK8Zk2lPSpK7WPM1IymR/8hw82Arxr5BQOQWQcYmuQOnKrAoGBALVe\nnZ0Ux7YWVt1ybfKmkrUU29ixXLQGxW5eaSvm26JRmXWURANByGfkQRoDAkvG8i/9\nlLQRU0Z13ngT7aNfQoxaE3OwgHj4eVh75E1REK8cW2+/lrlGXZ1gl/aYgoM4P90S\nq2l/MWZs6FiTQsbrUZuJVuUBNuSY3ub4OuOSO5tzAoGBALGw+ofHG04UFd2WmsIn\ne1dGeieJ4u3awgBIEAPfd5Jx3zRvfkqrHBzY8Sx6O+YB184o5aSQg1NSbxmhxAHe\nxOIX6QxWNQWr6PTxZYaocfYtRJTH8KKC46EDwvKF4rgSvJEDBVK/iTqS8CPkwQm0\nIVRAHnRrfO0tT2nq44jRJw91\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker@expense-tracker-367620.iam.gserviceaccount.com",
  "client_id": "113912491561210000126",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker%40expense-tracker-367620.iam.gserviceaccount.com"
}
''';

  static const spreadSheetId = "13Tn78poAOcTrIJvul9UdhUMR8L96s1GwK6ElCn2_HZU";

  final gsheets = GSheets(credentials);
 
  static Worksheet? worksheet;
  static List<String> workSheetName = [];

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
  static int numberOfSheets = 0;

  Future<void> init(String name) async {
    final ss = await gsheets.spreadsheet(spreadSheetId);
    worksheet = ss.worksheetByTitle(name);
    //workSheetName.add(worksheet!.title);
    getWorkSheetName();
    countSheets();
    countRows();
  }

  Future<int> countSheets() async {
    final ss = await gsheets.spreadsheet(spreadSheetId);

    numberOfSheets = ss.sheets.length;
    getWorkSheetName();

    return numberOfSheets;
  }

  Future createSheet(String workSheetName) async {
    final ss = await gsheets.spreadsheet(spreadSheetId);
    worksheet = await ss.addWorksheet(workSheetName);
  }

  static Future getWorkSheetName() async {
    if (worksheet == null) return;
    if (workSheetName.length < numberOfSheets) {
      workSheetName.add(worksheet!.title);
    }
  }

  static Future countRows() async {
    while ((await worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (worksheet == null) return;
    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await worksheet!.values.value(column: 1, row: i + 1);
      final double transactionAmount =
          (await worksheet!.values.value(column: 2, row: i + 1)) as double;
      final String transactionType =
          await worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([transactionName, transactionAmount, transactionType]);
      }
    }
    loading = false;
  }

  static Future insert(String name, String amount, bool isCredit) async {
    if (worksheet == null) return;
    numberOfTransactions++;
    currentTransactions
        .add([name, amount, isCredit == true ? 'income' : 'expense']);
    await worksheet!.values
        .appendRow([name, amount, isCredit == true ? 'income' : 'expense']);
  }

  static double calculateIncome() {
    double income = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        income += double.parse(currentTransactions[i][1]);
      }
    }
    return income;
  }

  static double calculateExpense() {
   double expense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
       expense += double.parse(currentTransactions[i][1]);
      }
    }
    return expense;
  }
}
