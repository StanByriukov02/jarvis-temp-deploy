#!/bin/bash

# Скрипт для автоматической вставки ecosystem launcher в jarvis-true-bio-singularity.js

echo "Вставляем ecosystem launcher в jarvis-true-bio-singularity.js..."

# Создаем временный файл с новым содержимым
cat > /tmp/ecosystem_code.txt << 'EOF'
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

function findJarvisSystems(dir) {
  const systems = [];
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);
    
    if (stat.isDirectory()) {
      systems.push(...findJarvisSystems(fullPath));
    } else if (file.startsWith('jarvis-') && (file.endsWith('.ts') || file.endsWith('.js'))) {
      if (!file.includes('.backup') && 
          !file.includes('-backup') && 
          file !== 'jarvis-true-bio-singularity.js') {
        systems.push(fullPath);
      }
    }
  });
  
  return systems;
}

const jarvisSystems = findJarvisSystems('./server');

console.log('JARVIS ECOSYSTEM LAUNCHER');
console.log('Found systems:', jarvisSystems.length);
jarvisSystems.forEach(system => console.log('System:', system));

jarvisSystems.forEach(systemPath => {
  const systemName = path.basename(systemPath);
  console.log('Starting:', systemName);
  spawn('node', [systemPath], { stdio: 'inherit' });
});

console.log('All systems launched');

EOF

# Создаем backup оригинального файла
cp jarvis-true-bio-singularity.js jarvis-true-bio-singularity.js.backup

# Вставляем код в начало файла (после комментариев, перед const QuantumNeuronTypes)
sed '/^\/\/ EMBEDDED ТИПЫ/i\
' jarvis-true-bio-singularity.js > /tmp/jarvis_temp.js

# Объединяем файлы
(
  # Берем начало до "EMBEDDED ТИПЫ"
  sed '/^\/\/ EMBEDDED ТИПЫ/q' jarvis-true-bio-singularity.js | head -n -1
  
  # Добавляем ecosystem launcher
  cat /tmp/ecosystem_code.txt
  echo ""
  
  # Добавляем остальную часть файла (начиная с "EMBEDDED ТИПЫ")
  sed -n '/^\/\/ EMBEDDED ТИПЫ/,$p' jarvis-true-bio-singularity.js
) > jarvis-true-bio-singularity-new.js

# Заменяем оригинальный файл
mv jarvis-true-bio-singularity-new.js jarvis-true-bio-singularity.js

# Удаляем временные файлы
rm -f /tmp/ecosystem_code.txt /tmp/jarvis_temp.js

echo "Ecosystem launcher успешно вставлен!"
echo "Backup сохранен как jarvis-true-bio-singularity.js.backup"
echo "Проверьте файл командой: head -50 jarvis-true-bio-singularity.js"