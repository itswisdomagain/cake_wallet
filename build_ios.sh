cd scripts/ios

echo "============================ BUILDING DEPS ============================"
source ./app_env.sh "cakewallet"
../android/manifest.sh # to avoid "`connectivity_plus` requires your app to be migrated" error
./app_config.sh
./build_decred.sh

echo "=================== generate secrets, localization ===================="
cd ../.. && flutter pub get
flutter packages pub run tool/generate_new_secrets.dart
flutter packages pub run tool/generate_localization.dart
cd cw_core && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
cd cw_bitcoin && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
cd cw_decred && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "
============================ ALL DONE. NEXT STEPS: ====================
=                                                                     =
= UPDATE TEAM AND BUNDLE IDENTIFIER IN XCODE > SIGNING & CAPABILITIES =
=                                                                     =
=======================================================================
"