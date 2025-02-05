#!/bin/bash

# Konfigurasi
ZIMBRA_LOG="/var/log/zimbra.log"        # Lokasi file log Zimbra
TELEGRAM_BOT_TOKEN="3242343242432:AAFjnixV7Rh5LLHpHNu_Wwo_yuo5RplLDvM"  # Ganti dengan token bot Telegram Anda
TELEGRAM_CHAT_ID="-32432432324"        # Ganti dengan ID chat atau grup Telegram tujuan

# Tanggal hari ini dalam format yang cocok untuk grep (misal Dec 17)
TODAY=$(date '+%b %d')

# Ambil user yang login lebih dari 600 kali pada hari ini
USERS=$(grep "$TODAY" "$ZIMBRA_LOG" | grep sasl_user | sed 's/.*sasl_username=//g' | sort | uniq -c | sort -nr | awk '$1 > 600 {print $2}')

# Inisialisasi list IP untuk Telegram dalam format Markdown
IP_LIST="*⚠️ List IP Spam Login Zimbra:*\n"

# Loop untuk setiap user yang terdeteksi spam login
for USER in $USERS; do
    echo "Memproses user: $USER"

    # Ambil IP yang digunakan oleh user tadi dan login lebih dari 100 kali
    IPS=$(grep "$TODAY" "$ZIMBRA_LOG" | grep sasl_user | grep "$USER" | awk '{print $7}' | sed -rn 's/.*\[//;s/\].*//p' | sort -nr -k 1 | uniq -c | sort -nr -k 1 | awk '$1 > 100 {print $2}')

    # Tambahkan IP ke daftar dalam format Markdown
    if [[ -n "$IPS" ]]; then
        IP_LIST+="*User:* \`$USER\`"
        for IP in $IPS; do
            IP_LIST+="  - *IP:* \`$IP\`"
        done
    fi
done

# Jika ada IP yang terdeteksi, kirimkan ke Telegram
if [[ -n "$IP_LIST" ]]; then
    echo -e "Mengirim list IP ke Telegram...\n$IP_LIST"

    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
        -d chat_id=$TELEGRAM_CHAT_ID \
        -d parse_mode="Markdown" \
        -d text="$IP_LIST"
else
    echo "Tidak ada IP yang melebihi threshold hari ini."
fi
