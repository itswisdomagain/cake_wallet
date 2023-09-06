cd scripts/macos

echo -e "============================ BUILDING DEPS ============================\n"
source ./app_env.sh cakewallet
../android/manifest.sh # to avoid "`connectivity_plus` requires your app to be migrated" error
./app_config.sh
./build_all.sh
./setup.sh
./gen_arm64.sh

echo -e "\n\n============================ generate secrets, localization ============================\n"
cd ../.. && flutter pub get
flutter packages pub run tool/generate_new_secrets.dart
flutter packages pub run tool/generate_localization.dart
echo -e "\n\n============================ cw_core mobx ============================\n"
cd cw_core && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
echo -e "\n\n============================ cw_monero mobx ============================\n"
cd cw_monero && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
echo -e "\n\n============================ cw_bitcoin mobx ============================\n"
cd cw_bitcoin && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
echo -e "\n\n============================ cw_ethereum mobx ============================\n"
cd cw_ethereum && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
echo -e "\n\n============================ cw_decred mobx ============================\n"
cd cw_decred && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && cd ..
echo -e "\n\n============================ app mobx ============================\n"
flutter packages pub run build_runner build --delete-conflicting-outputs
# update team and bundle in xcode => signing & capabilities
