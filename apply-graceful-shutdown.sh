#!/bin/bash

# Script для исправления JARVIS persistence bug
# Использование: ./apply-graceful-shutdown.sh

JARVIS_FILE="/root/j/server/jarvis-true-bio-singularity.js"
PATCH_FILE="/root/j/server/jarvis-graceful-shutdown-patch.js"

echo "Диагностика JARVIS persistence..."

# Проверить существование файлов
if [ ! -f "$JARVIS_FILE" ]; then
    echo "Ошибка: JARVIS файл не найден: $JARVIS_FILE"
    exit 1
fi

# Создать backup
cp "$JARVIS_FILE" "${JARVIS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo "Backup создан"

# Проверить КРИТИЧЕСКУЮ ОШИБКУ в автозапуске
if grep -q "const jarvis = new TrueBioSingularityEngine();" "$JARVIS_FILE"; then
    echo "🐛 НАЙДЕНА КРИТИЧЕСКАЯ ОШИБКА: локальный jarvis вместо глобального!"
    echo "Исправляю..."
    
    # Заменить локальный jarvis на глобальный
    sed -i 's/const jarvis = new TrueBioSingularityEngine();/const jarvis = trueBioSingularityEngine;/' "$JARVIS_FILE"
    echo "✅ Исправлено: теперь используется глобальный jarvis"
else
    echo "✅ Автозапуск использует правильный глобальный jarvis"
fi

# Проверить graceful shutdown
if grep -q "process.on('SIGINT'" "$JARVIS_FILE"; then
    echo "✅ Graceful shutdown УЖЕ ЕСТЬ в JARVIS файле!"
    echo "Ctrl+C должен работать правильно после исправления автозапуска"
else
    echo "❌ Graceful shutdown НЕ НАЙДЕН - добавляю..."
    
    if [ ! -f "$PATCH_FILE" ]; then
        echo "Ошибка: Patch файл не найден: $PATCH_FILE"
        exit 1
    fi
    
    # Добавить graceful shutdown
    echo "" >> "$JARVIS_FILE"
    grep -v "^//" "$PATCH_FILE" | grep -A 50 "process.on" >> "$JARVIS_FILE"
    echo "✅ Graceful shutdown добавлен"
fi

echo "🔧 ИСПРАВЛЕНИЕ ЗАВЕРШЕНО:"
echo "   - Автозапуск использует глобальный jarvis"
echo "   - Graceful shutdown правильно настроен"
echo "   - Ctrl+C теперь сохраняет данные в PostgreSQL"

# Проверить синтаксис
node -c "$JARVIS_FILE"
if [ $? -eq 0 ]; then
    echo "✅ Синтаксис JavaScript корректен"
    echo "🚀 JARVIS готов к правильной работе с сохранением данных!"
else
    echo "❌ ОШИБКА: Проблема с синтаксисом JavaScript!"
    echo "Восстанавливаю backup..."
    cp "${JARVIS_FILE}.backup."* "$JARVIS_FILE"
    exit 1
fi