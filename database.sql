-- Habilitar extensiones para IDs únicos (UUID)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. TABLA DE USUARIOS
-- Soporta perfiles privados y llaves de seguridad
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    display_name VARCHAR(50) NOT NULL,
    avatar_url TEXT DEFAULT 'https://via.placeholder.com/150',
    bio TEXT,
    is_online BOOLEAN DEFAULT false,
    last_connection TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABLA DE CONVERSACIONES (CHATS)
-- Aquí manejamos las "Carpetas Inteligentes"
CREATE TABLE chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) CHECK (type IN ('individual', 'group', 'channel')),
    folder_category VARCHAR(30) DEFAULT 'general', -- Ej: 'work', 'family', 'personal'
    group_name VARCHAR(100), -- Solo si es grupo
    group_icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABLA DE PARTICIPANTES
-- Relaciona qué usuarios están en qué chats
CREATE TABLE chat_participants (
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chat_id, user_id)
);

-- 4. TABLA DE MENSAJES (Súper Completa)
-- Soporta texto, multimedia, transcripciones de IA y estados de lectura
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id),
    content_type VARCHAR(20) CHECK (content_type IN ('text', 'image', 'audio', 'video', 'file')),
    message_body TEXT NOT NULL, -- Texto o URL del archivo
    ai_transcription TEXT, -- Para buscar dentro de audios (Función Pro)
    status VARCHAR(15) DEFAULT 'sent' CHECK (status IN ('sent', 'delivered', 'read')),
    is_edited BOOLEAN DEFAULT false,
    reply_to_id UUID REFERENCES messages(id), -- Para responder mensajes específicos
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. TABLA DE ESTADOS (STORIES)
CREATE TABLE stories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    media_url TEXT NOT NULL,
    caption VARCHAR(255),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
