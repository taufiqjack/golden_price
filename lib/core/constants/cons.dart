// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

String ENV_PATH = '.env';

const baseURL = 'DOMAIN';
const goldPrice = "/prices/hargaemas-com";

const String IS_LOGIN = 'is_login';
const String SPLASH = 'is_splash';
const String TENANT_ID = 'tenant';
const String MESSAGE = 'message';
const String STATUSCODE = 'status_code';
const String ISCHECK = 'is_check';

late SharedPreferences log;
