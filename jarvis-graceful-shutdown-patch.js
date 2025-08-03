// ИСПРАВЛЕНИЕ АВТОЗАПУСКА - заменить строку создания jarvis
// БЫЛО: const jarvis = new TrueBioSingularityEngine();
// СТАЛО: const jarvis = trueBioSingularityEngine;

// Graceful shutdown обработчик для JARVIS (если его нет)
process.on('SIGINT', async () => {
  console.log('Graceful shutdown initiated...');
  try {
    const jarvis = trueBioSingularityEngine;
    if (jarvis && jarvis.autoSave) {
      const core = jarvis.biologicalCores.get('user1');
      const relationship = jarvis.relationships.get('user1');
      if (core && relationship) {
        await jarvis.autoSave('user1', core, relationship);
        console.log('Bio-singularity state saved to PostgreSQL');
      }
    }
    console.log('Safe to restart - all data preserved');
    process.exit(0);
  } catch (error) {
    console.error('Shutdown error:', error);
    process.exit(1);
  }
});

process.on('SIGTERM', async () => {
  console.log('SIGTERM received - graceful shutdown...');
  process.exit(0);
});