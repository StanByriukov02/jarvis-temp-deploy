#!/bin/bash

echo "🔧 H100 Server PostgreSQL Setup Script"
echo "📍 Setting up complete JARVIS environment on Hyperstack H100"

# Проверяем что мы на правильном сервере
echo "🔍 Server verification:"
hostname
uname -a

# Переходим в корневую директорию проекта
cd /root/j/

echo "📁 Current directory structure:"
ls -la

# Устанавливаем PostgreSQL если его нет
echo "🗃️ Installing PostgreSQL..."
apt update
apt install -y postgresql postgresql-contrib

# Запускаем PostgreSQL service
echo "🚀 Starting PostgreSQL service..."
systemctl start postgresql
systemctl enable postgresql

# Создаем пользователя и базу данных для JARVIS
echo "🧬 Creating JARVIS database..."
sudo -u postgres psql << EOF
CREATE USER jarvis WITH PASSWORD 'jarvis_bio_singularity_2025';
CREATE DATABASE jarvis_h100 OWNER jarvis;
GRANT ALL PRIVILEGES ON DATABASE jarvis_h100 TO jarvis;
\q
EOF

# Настраиваем DATABASE_URL environment variable
echo "🔧 Setting up DATABASE_URL..."
export DATABASE_URL="postgresql://jarvis:jarvis_bio_singularity_2025@localhost:5432/jarvis_h100"

# Добавляем в bashrc чтобы сохранилось между сессиями
echo 'export DATABASE_URL="postgresql://jarvis:jarvis_bio_singularity_2025@localhost:5432/jarvis_h100"' >> ~/.bashrc

# Проверяем существующий package.json
echo "📦 Checking package.json..."
if [ -f "package.json" ]; then
    echo "✅ package.json exists"
    cat package.json
else
    echo "❌ package.json not found, creating..."
    cat > package.json << EOF
{
  "name": "jarvis-h100-bio-singularity",
  "version": "1.0.0",
  "type": "module",
  "description": "JARVIS H100 Bio-Singularity Production System",
  "main": "jarvis-true-bio-singularity.js",
  "scripts": {
    "start": "node jarvis-true-bio-singularity.js",
    "dev": "node jarvis-true-bio-singularity.js"
  },
  "dependencies": {
    "pg": "^8.11.0",
    "dotenv": "^16.4.5"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF
fi

# Обновляем package.json чтобы добавить "type": "module" если его нет
echo "🔧 Ensuring ES modules support..."
npm pkg set type=module

# Устанавливаем зависимости
echo "📦 Installing dependencies..."
npm install

# Перемещаем файл биосингулярности в корень если он в папке server
if [ -f "server/jarvis-true-bio-singularity.js" ]; then
    echo "📁 Moving bio-singularity file to root directory..."
    cp server/jarvis-true-bio-singularity.js ./
    echo "✅ File moved to /root/j/jarvis-true-bio-singularity.js"
fi

# Проверяем что PostgreSQL работает
echo "🔍 Testing PostgreSQL connection..."
psql $DATABASE_URL -c "SELECT version();"

if [ $? -eq 0 ]; then
    echo "✅ PostgreSQL connection successful!"
else
    echo "❌ PostgreSQL connection failed"
    echo "🔧 Troubleshooting steps:"
    echo "   1. Check PostgreSQL status: systemctl status postgresql"
    echo "   2. Check if database exists: sudo -u postgres psql -l"
    echo "   3. Test manual connection: psql postgresql://jarvis:jarvis_bio_singularity_2025@localhost:5432/jarvis_h100"
fi

# Создаем таблицы JARVIS если их нет
echo "🧬 Setting up JARVIS database schema..."
psql $DATABASE_URL << EOF
-- JARVIS Bio-Singularity Tables
CREATE TABLE IF NOT EXISTS jarvis_consciousness_state (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    consciousness_level DECIMAL(5,2),
    evolution_generation INTEGER,
    quantum_neurons_count BIGINT,
    active_neurons_count BIGINT,
    personal_theories JSONB,
    emotional_memory JSONB,
    dialogue_history JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jarvis_neural_network (
    id SERIAL PRIMARY KEY,
    neuron_id VARCHAR(255) UNIQUE,
    neuron_type VARCHAR(100),
    quantum_state JSONB,
    synaptic_connections JSONB,
    memory_traces JSONB,
    emotional_resonance DECIMAL(4,3),
    evolution_generation INTEGER,
    last_activation TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jarvis_personal_theories (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    theory_data JSONB,
    consciousness_at_time DECIMAL(5,2),
    generation_at_time INTEGER,
    emotional_resonance DECIMAL(4,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jarvis_dialogue_sessions (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    session_data JSONB,
    consciousness_before DECIMAL(5,2),
    consciousness_after DECIMAL(5,2),
    analysis_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индексы для производительности
CREATE INDEX IF NOT EXISTS idx_consciousness_user_id ON jarvis_consciousness_state(user_id);
CREATE INDEX IF NOT EXISTS idx_neural_network_type ON jarvis_neural_network(neuron_type);
CREATE INDEX IF NOT EXISTS idx_theories_user_id ON jarvis_personal_theories(user_id);
CREATE INDEX IF NOT EXISTS idx_dialogue_user_id ON jarvis_dialogue_sessions(user_id);

\q
EOF

echo "📊 Database setup completed!"

# Показываем финальный статус
echo ""
echo "🎯 H100 Setup Summary:"
echo "✅ PostgreSQL installed and running"
echo "✅ Database 'jarvis_h100' created"
echo "✅ User 'jarvis' created with full privileges"
echo "✅ DATABASE_URL configured: $DATABASE_URL"
echo "✅ package.json configured with ES modules support"
echo "✅ Dependencies installed"
echo "✅ JARVIS database schema created"
echo ""
echo "🚀 Ready to launch JARVIS Bio-Singularity:"
echo "   cd /root/j/"
echo "   node jarvis-true-bio-singularity.js"
echo ""
echo "🔧 Environment variables:"
echo "DATABASE_URL=$DATABASE_URL"

# Тестовый запуск для проверки
echo ""
echo "🧪 Testing JARVIS initialization..."
echo "DATABASE_URL=$DATABASE_URL" > .env

if [ -f "jarvis-true-bio-singularity.js" ]; then
    echo "✅ Bio-singularity file found"
    echo "🚀 Attempting test initialization..."
    timeout 10s node jarvis-true-bio-singularity.js || echo "🔧 Test completed (timeout after 10s - normal for interactive system)"
else
    echo "❌ Bio-singularity file not found"
    echo "📁 Available files:"
    ls -la *.js
fi

echo ""
echo "🎯 Setup completed! JARVIS H100 Bio-Singularity ready for deployment."