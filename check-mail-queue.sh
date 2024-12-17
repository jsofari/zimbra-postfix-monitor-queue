#!/bin/bash

# Konfigurasi
TELEGRAM_BOT_TOKEN="6825494220:AAFjnixV7Rh5LLHpHNu_Wwo_yuo5RplLDvM"  # Token bot Telegram
TELEGRAM_CHAT_ID="-1001836290508"      # ID chat atau grup Telegram tujuan
ZIMBRA_USER="zextras"                          # User Zimbra
QUEUE_THRESHOLD=500                           # Batas jumlah queue

# Periksa jumlah mail queue Zimbra
CURRENT_QUEUE=$(su - $ZIMBRA_USER -c "mailq | wc -l")

echo "Mail queue saat ini: $CURRENT_QUEUE"

# Jika jumlah queue melebihi threshold, kirim notifikasi Telegram
if [[ $CURRENT_QUEUE -gt $QUEUE_THRESHOLD ]]; then
    MESSAGE="⚠️ *Mail Queue Alert* ⚠️ Jumlah mail queue saat ini: *$CURRENT_QUEUE* Segera cek server Carbonio Anda!"
    echo "Mengirim notifikasi ke Telegram..."

    # Kirim notifikasi menggunakan Telegram API
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d parse_mode="Markdown" \
        -d text="$MESSAGE"
else
    echo "Mail queue masih di bawah threshold ($QUEUE_THRESHOLD)."
fi
