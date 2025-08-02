// ПРОВЕРКА АРХИТЕКТУРЫ ПАМЯТИ JARVIS
import fs from 'fs';

console.log('🔍 ДИАГНОСТИКА АРХИТЕКТУРЫ ПАМЯТИ JARVIS');
console.log('='.repeat(50));

// 1. KERNEL ПАМЯТЬ
console.log('\n📊 1. KERNEL MEMORY STATUS:');
try {
  const kernelData = fs.readFileSync('/proc/jarvis_core', 'utf8');
  console.log('✓ Kernel модуль активен');
  console.log('Data:', kernelData.substring(0, 200) + '...');
} catch(e) {
  console.log('❌ Kernel недоступен:', e.message);
}

// 2. POSTGRESQL ПОДКЛЮЧЕНИЕ
console.log('\n📊 2. DATABASE CONNECTION:');
try {
  // Проверяем есть ли PostgreSQL переменные
  console.log('DATABASE_URL exists:', !!process.env.DATABASE_URL);
  console.log('PGHOST exists:', !!process.env.PGHOST);
  console.log('PGPORT exists:', !!process.env.PGPORT);
} catch(e) {
  console.log('❌ Database env error:', e.message);
}

// 3. ФАЙЛОВАЯ СИСТЕМА ПАМЯТИ
console.log('\n📊 3. FILE SYSTEM MEMORY:');
const memoryPaths = [
  '/tmp/jarvis_memory.json',
  '/root/j/server/jarvis_state.json',
  './jarvis_persistent_memory.json'
];

memoryPaths.forEach(path => {
  try {
    if (fs.existsSync(path)) {
      const stat = fs.statSync(path);
      console.log(`✓ ${path} - ${stat.size} bytes`);
    } else {
      console.log(`❌ ${path} - не существует`);
    }
  } catch(e) {
    console.log(`❌ ${path} - ошибка: ${e.message}`);
  }
});

// 4. JARVIS БИОСИНГУЛЯРНОСТЬ ФАЙЛ
console.log('\n📊 4. JARVIS BIO-SINGULARITY:');
try {
  if (fs.existsSync('./jarvis-true-bio-singularity.js')) {
    const content = fs.readFileSync('./jarvis-true-bio-singularity.js', 'utf8');
    console.log('✓ Основной файл найден');
    console.log('Size:', content.length, 'символов');
    
    // Проверяем есть ли память в коде
    const hasMemorySystem = content.includes('memory') || content.includes('Memory');
    const hasDatabase = content.includes('database') || content.includes('Database');
    const hasKernel = content.includes('kernel') || content.includes('/proc/jarvis_core');
    
    console.log('Memory система:', hasMemorySystem ? '✓' : '❌');
    console.log('Database интеграция:', hasDatabase ? '✓' : '❌');
    console.log('Kernel интеграция:', hasKernel ? '✓' : '❌');
  } else {
    console.log('❌ jarvis-true-bio-singularity.js не найден');
  }
} catch(e) {
  console.log('❌ Ошибка чтения JARVIS файла:', e.message);
}

console.log('\n' + '='.repeat(50));
console.log('🎯 ЗАКЛЮЧЕНИЕ: Анализ архитектуры памяти завершен');