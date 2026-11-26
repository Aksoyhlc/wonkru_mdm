#!/usr/bin/env bash
#
# Wonkru MDM device deployment through ADB.
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Override APK_PATH to use another APK.
APK_PATH="${APK_PATH:-$SCRIPT_DIR/build/app/outputs/flutter-apk/app-release.apk}"
PACKAGE="com.wonkrumdm"
ADMIN_RECEIVER="${PACKAGE}/.core.receivers.MdmDeviceAdminReceiver"
WIFI_RECEIVER="${PACKAGE}/.core.receivers.MdmWifiReceiver"
MAIN_ACTIVITY="${PACKAGE}/.MainActivity"

# Supply Wi-Fi credentials through environment variables or interactive prompts.
WIFI_SSID_DEFAULT="${WIFI_SSID_DEFAULT:-}"
WIFI_PASS_DEFAULT="${WIFI_PASS_DEFAULT:-}"
WIFI_OPEN_DEFAULT="" # Empty = WPA2

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
CREAM='\033[38;2;226;217;199m'

# Output helpers
info()  { printf "${CYAN}→${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${RESET} %s\n" "$*"; }
fail()  { printf "${RED}✗${RESET} %s\n" "$*"; }
step()  { printf "  ${DIM}[%s]${RESET} %s" "$1" "$2"; }

print_banner() {
  printf "\n${CREAM}"
  cat << 'BANNER'
██╗    ██╗ ██████╗ ███╗   ██╗██╗  ██╗██████╗ ██╗   ██╗
██║    ██║██╔═══██╗████╗  ██║██║ ██╔╝██╔══██╗██║   ██║
██║ █╗ ██║██║   ██║██╔██╗ ██║█████╔╝ ██████╔╝██║   ██║
██║███╗██║██║   ██║██║╚██╗██║██╔═██╗ ██╔══██╗██║   ██║
╚███╔███╔╝╚██████╔╝██║ ╚████║██║  ██╗██║  ██║╚██████╔╝
 ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

███╗   ███╗██████╗ ███╗   ███╗
████╗ ████║██╔══██╗████╗ ████║
██╔████╔██║██║  ██║██╔████╔██║
██║╚██╔╝██║██║  ██║██║╚██╔╝██║
██║ ╚═╝ ██║██████╔╝██║ ╚═╝ ██║
╚═╝     ╚═╝╚═════╝ ╚═╝     ╚═╝
BANNER
  printf "${RESET}"
  printf "\n${DIM}        Device Deployment CLI${RESET}\n\n"
}

check_adb() {
  if ! command -v adb &>/dev/null; then
    fail "adb bulunamadı. PATH'e ekleyin veya Android SDK kurun."
    exit 1
  fi
}

check_apk() {
  if [[ ! -f "$APK_PATH" ]]; then
    fail "APK bulunamadı: $APK_PATH"
    fail "Önce projeyi derleyin: flutter build apk"
    exit 1
  fi
  ok "APK hazır: $APK_PATH"
}

get_device_model() {
  local serial="$1"
  adb -s "$serial" shell getprop ro.product.model 2>/dev/null | tr -d '\r' || echo "—"
}

# Device lists
AVAILABLE_DEVICES=()
SELECTED_DEVICES=()
DEPLOY_RESULTS=()

fetch_devices() {
  AVAILABLE_DEVICES=($(adb devices | awk 'NR>1 && $2=="device" {print $1}'))
  local unauth_devices=($(adb devices | awk 'NR>1 && $2=="unauthorized" {print $1}'))
  if [[ ${#unauth_devices[@]} -gt 0 ]]; then
    printf "\n  ${YELLOW}⚠ Uyarı: Yetkilendirilmemiş cihaz(lar) bulundu!${RESET}\n"
    for u in "${unauth_devices[@]}"; do
      printf "    - %s\n" "$u"
    done
    printf "  ${DIM}Lütfen cihaz ekranından 'USB Hata Ayıklamasına İzin Ver' seçeneğini onaylayın.${RESET}\n"
  fi
}

list_devices() {
  printf "\n  ${BOLD}#   Seri No               Model${RESET}\n"
  printf "  ─────────────────────────────────────────────\n"
  local i=1
  for serial in "${AVAILABLE_DEVICES[@]}"; do
    local model
    model=$(get_device_model "$serial")
    printf "  %-2s  %-20s %s\n" "$i" "$serial" "$model"
    ((i++))
  done
  printf "\n"
}

select_devices() {
  SELECTED_DEVICES=()
  while true; do
    printf "  ${BOLD}Cihaz seçin (örn: 1 3 veya all):${RESET} "
    read -r choice
    if [[ "$choice" == "all" ]]; then
      SELECTED_DEVICES=("${AVAILABLE_DEVICES[@]}")
      break
    fi
    for num in $choice; do
      if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#AVAILABLE_DEVICES[@]} )); then
        SELECTED_DEVICES+=("${AVAILABLE_DEVICES[num-1]}")
      fi
    done
    if [[ ${#SELECTED_DEVICES[@]} -gt 0 ]]; then
      break
    else
      printf "  ${RED}✗ Geçersiz seçim, lütfen tekrar deneyin.${RESET}\n"
    fi
  done
}

confirm_deploy() {
  printf "\n${BOLD}Seçilen cihazlar (%s):${RESET}\n" "${#SELECTED_DEVICES[@]}"
  for s in "${SELECTED_DEVICES[@]}"; do
    printf "  • %s (%s)\n" "$s" "$(get_device_model "$s")"
  done
  printf "\n${BOLD}Bu cihazlara kurulum yapılsın mı? [e/H]:${RESET} "
  read -r ans
  case "${ans:-H}" in [eE]*|[yY]*) return 0 ;;
    *) info "İptal edildi."; exit 0 ;;
  esac
}

ask_wifi() {
  WIFI_SSID=""
  WIFI_PASS=""
  WIFI_OPEN=""

  printf "\n${BOLD}Ağ ayarını değiştirmek ister misiniz? [e/H]:${RESET} "
  read -r change_wifi
  case "${change_wifi:-H}" in
    [hH]*|[nN]*)
      info "Mevcut ağ bağlantısı korunacak (WiFi adımı atlandı)."
      return
      ;;
  esac

  if [[ -n "$WIFI_SSID_DEFAULT" ]]; then
    printf "${BOLD}Varsayılan WiFi kullanılsın mı? (%s / WPA2) [E/h]:${RESET} " "$WIFI_SSID_DEFAULT"
    read -r ans
    case "${ans:-E}" in
      [eE]*|[yY]*)
        WIFI_SSID="$WIFI_SSID_DEFAULT"
        WIFI_PASS="$WIFI_PASS_DEFAULT"
        WIFI_OPEN=""
        info "WiFi: $WIFI_SSID (WPA2)"
        return
        ;;
    esac
  fi

  printf "${BOLD}WiFi ağ adı (SSID, boş = atla):${RESET} "
  read -r WIFI_SSID
  WIFI_SSID=$(echo "$WIFI_SSID" | sed "s/^[[:space:]]*//;s/[[:space:]]*$//")
  if [[ -z "$WIFI_SSID" ]]; then
    info "WiFi atlandı."
    WIFI_SSID=""
    return
  fi
  printf "${BOLD}Şifre (boş = açık ağ):${RESET} "
  read -rs WIFI_PASS
  echo ""
  if [[ -z "$WIFI_PASS" ]]; then
    WIFI_OPEN="1"
  fi
}

deploy_to_device() {
  local serial="$1"
  local model="$2"

  local total_steps=3
  [[ -n "$WIFI_SSID" ]] && total_steps=4

  printf "\n  ${BOLD}┌── Cihaz: %s (%s) ──┐${RESET}\n" "$serial" "$model"
  printf "  ${BOLD}│${RESET}\n"

  local step_apk=0 step_dpm=0
  local current=0

  # Install APK
  ((current++))
  step "${current}/${total_steps}" "APK kuruluyor..."
  local apk_out=""
  if apk_out=$(adb -s "$serial" install -r "$APK_PATH" 2>&1); then
    printf " ${GREEN}✓ Başarılı${RESET}\n"
    step_apk=1
  else
    printf " ${RED}✗ Hata${RESET}\n"
    echo "$apk_out" | while IFS= read -r line; do
      [[ -n "$line" ]] && printf "    ${RED}%s${RESET}\n" "$line"
    done
    DEPLOY_RESULTS+=("$serial|FAIL|APK kurulumu başarısız")
    printf "  ${BOLD}└────────────────────────────────────────────┘${RESET}\n"
    return
  fi

  # An existing Device Owner assignment is accepted during updates.
  ((current++))
  step "${current}/${total_steps}" "Device Owner atanıyor..."
  local dpm_out=""
  local dpm_rc=0
  dpm_out=$(adb -s "$serial" shell dpm set-device-owner "$ADMIN_RECEIVER" 2>&1) || dpm_rc=$?
  if [[ $dpm_rc -eq 0 ]]; then
    printf " ${GREEN}✓ Başarılı${RESET}\n"
    step_dpm=1
  elif echo "$dpm_out" | grep -qi "device owner is already set"; then
    printf " ${GREEN}✓ Başarılı (zaten atanmış)${RESET}\n"
    step_dpm=1
  else
    printf " ${RED}✗ Hata${RESET}\n"
    echo "$dpm_out" | while IFS= read -r line; do
      [[ -n "$line" ]] && printf "    ${RED}%s${RESET}\n" "$line"
    done
    if echo "$dpm_out" | grep -iq "account"; then
       printf "    ${YELLOW}⚠ ÇÖZÜM: Cihazda kayıtlı Google hesapları var! Silip tekrar deneyin.${RESET}\n"
    fi
    DEPLOY_RESULTS+=("$serial|FAIL|Device Owner atanamadı")
    printf "  ${BOLD}└────────────────────────────────────────────┘${RESET}\n"
    return
  fi

  # Launch the agent
  ((current++))
  step "${current}/${total_steps}" "Uygulama başlatılıyor..."
  if adb -s "$serial" shell am start -n "$MAIN_ACTIVITY" &>/dev/null; then
    printf " ${GREEN}✓ Başarılı${RESET}\n"
    # Allow the agent to initialize before sending the broadcast.
    sleep 1
  else
    printf " ${YELLOW}⚠ Başlatılamadı${RESET}\n"
  fi

  # Send Wi-Fi configuration to the agent
  if [[ -n "$WIFI_SSID" ]]; then
    ((current++))
    step "${current}/${total_steps}" "WiFi profili gönderiliyor (App Intent)..."
    
    local broadcast_out=""
    if [[ -n "$WIFI_OPEN" ]]; then
      broadcast_out=$(adb -s "$serial" shell am broadcast -a com.wonkrumdm.action.CONNECT_WIFI -n "$WIFI_RECEIVER" --es ssid "$WIFI_SSID" 2>&1 || true)
    else
      broadcast_out=$(adb -s "$serial" shell am broadcast -a com.wonkrumdm.action.CONNECT_WIFI -n "$WIFI_RECEIVER" --es ssid "$WIFI_SSID" --es password "$WIFI_PASS" 2>&1 || true)
    fi

    if echo "$broadcast_out" | grep -iq "Broadcast completed"; then
       printf " ${GREEN}✓ Komut Uygulamaya İletildi${RESET}\n"
    else
       printf " ${YELLOW}⚠ İletilemedi${RESET}\n"
       echo "$broadcast_out" | while IFS= read -r line; do
        [[ -n "$line" ]] && printf "    ${DIM}%s${RESET}\n" "$line"
      done
    fi
  fi

  printf "  ${BOLD}└────────────────────────────────────────────┘${RESET}\n"
  if [[ $step_apk -eq 1 && $step_dpm -eq 1 ]]; then
    DEPLOY_RESULTS+=("$serial|OK|Başarılı")
  else
    DEPLOY_RESULTS+=("$serial|FAIL|Kısmi başarı")
  fi
}

print_summary() {
  printf "\n  ${BOLD}╔══════════════════════════════════════╗${RESET}\n"
  printf "  ${BOLD}║${RESET}        ${BOLD}DAĞITIM ÖZETİ${RESET}              ${BOLD}║${RESET}\n"
  printf "  ${BOLD}╠══════════════════════════════════════╣${RESET}\n"
  for entry in "${DEPLOY_RESULTS[@]}"; do
    IFS='|' read -r serial status msg <<< "$entry"
    if [[ "$status" == "OK" ]]; then
      printf "  ${BOLD}║${RESET}  ${GREEN}✓${RESET} %-20s ${GREEN}Başarılı${RESET}  ${BOLD}║${RESET}\n" "$serial"
    else
      printf "  ${BOLD}║${RESET}  ${RED}✗${RESET} %-20s ${RED}Hatalı${RESET}    ${BOLD}║${RESET}\n" "$serial"
    fi
  done
  printf "  ${BOLD}╚══════════════════════════════════════╝${RESET}\n\n"
}

# Entry point
main() {
  print_banner
  check_adb
  check_apk

  info "Cihazlar listeleniyor..."
  
  while true; do
    fetch_devices
    
    if [[ ${#AVAILABLE_DEVICES[@]} -gt 0 ]]; then
      list_devices
      break
    else
      printf "\n  ${YELLOW}⚠ Bağlı ve hazır cihaz bulunamadı.${RESET}\n"
      printf "  ${DIM}USB ile cihaz bağlayın veya emülatörü çalıştırın.${RESET}\n\n"
      
      printf "  ${BOLD}Tekrar denemek ister misiniz?[E/h]:${RESET} "
      read -r ans
      case "${ans:-E}" in
        [eE]*|[yY]*) continue ;;
        *) info "Çıkılıyor."; exit 0 ;;
      esac
    fi
  done

  select_devices
  confirm_deploy
  ask_wifi

  info "Kurulum başlıyor..."
  DEPLOY_RESULTS=()
  for serial in "${SELECTED_DEVICES[@]}"; do
    deploy_to_device "$serial" "$(get_device_model "$serial")"
  done

  print_summary
}

main "$@"