#!/bin/bash

# Konfigurasi
LOG_FILE="/var/log/zimbra.log"     # Path ke log Zimbra
TELEGRAM_BOT_TOKEN="234233432:AAFjnixV7Rh5LLHpHNu_Wwo_yuo5RplLDvM"  # Token Bot Telegram Anda
CHAT_ID="-324324324"                # Chat ID Anda
THRESHOLD=7                       # Ambang batas gagal login

# Fungsi untuk mengirim notifikasi ke Telegram
send_telegram_message() {
    local ip="$1"
    local count="$2"
    local message="⚠️ Gagal Login Terdeteksi! IP: ${ip} | Percobaan Gagal: ${count} kali"

    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${CHAT_ID}&text=${message}" > /dev/null
}

# Fungsi utama untuk memantau log
monitor_log() {
    # Inisialisasi file sementara
    TEMP_FILE="/tmp/failed_login.tmp"
    > "$TEMP_FILE"

    echo "Memantau log Zimbra untuk IP yang gagal login..."

    # Looping terus-menerus
    tail -Fn0 "$LOG_FILE" | while read -r line; do
        # Ekstrak IP dari log gagal login
        if echo "$line" | grep -q "SASL LOGIN authentication failed"; then
            ip=$(echo "$line" | grep -oP 'unknown\[\K[^\]]+')

            # Jika IP ditemukan, catat di file sementara
            if [ -n "$ip" ]; then
                echo "$ip" >> "$TEMP_FILE"

                # Hitung jumlah gagal login untuk IP tersebut
                count=$(grep -c "$ip" "$TEMP_FILE")

                # Jika melebihi threshold, kirim notifikasi
                if [ "$count" -eq "$THRESHOLD" ]; then
                    send_telegram_message "$ip" "$count"

                    # Hapus semua entri IP ini agar tidak terjadi duplikasi notifikasi
                    sed -i "/$ip/d" "$TEMP_FILE"
                fi
            fi
        fi
    done
}

# Jalankan fungsi utama
monitor_log
