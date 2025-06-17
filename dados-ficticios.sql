-- Script para inserir dados fictícios na aplicação Pulveriza Neném
-- Base de dados: PostgreSQL
-- Execute este script após a aplicação estar rodando

-- Inserir Usuários
INSERT INTO usuarios (id, created_at, updated_at, nome, email, senha, role, ativo) VALUES
('550e8400-e29b-41d4-a716-446655440001', NOW(), NOW(), 'João Silva', 'joao.silva@fazenda.com', '$2a$10$N.zmdr9k7uOCQb2hwllKqOU3aUxJHjE5tSw3hW8sK0j8nK0BXQ8jm', 'ADMIN', true),
('550e8400-e29b-41d4-a716-446655440002', NOW(), NOW(), 'Maria Santos', 'maria.santos@fazenda.com', '$2a$10$N.zmdr9k7uOCQb2hwllKqOU3aUxJHjE5tSw3hW8sK0j8nK0BXQ8jm', 'TECNICO', true),
('550e8400-e29b-41d4-a716-446655440003', NOW(), NOW(), 'Carlos Oliveira', 'carlos.oliveira@fazenda.com', '$2a$10$N.zmdr9k7uOCQb2hwllKqOU3aUxJHjE5tSw3hW8sK0j8nK0BXQ8jm', 'OPERADOR', true),
('550e8400-e29b-41d4-a716-446655440004', NOW(), NOW(), 'Ana Costa', 'ana.costa@fazenda.com', '$2a$10$N.zmdr9k7uOCQb2hwllKqOU3aUxJHjE5tSw3hW8sK0j8nK0BXQ8jm', 'TECNICO', true),
('550e8400-e29b-41d4-a716-446655440005', NOW(), NOW(), 'Roberto Lima', 'roberto.lima@fazenda.com', '$2a$10$N.zmdr9k7uOCQb2hwllKqOU3aUxJHjE5tSw3hW8sK0j8nK0BXQ8jm', 'OPERADOR', true);

-- Inserir Equipamentos
INSERT INTO equipamentos (id, created_at, updated_at, nome, modelo, fabricante, ano_fabricacao, largura_barra, capacidade_tanque, numero_serie) VALUES
('650e8400-e29b-41d4-a716-446655440001', NOW(), NOW(), 'Pulverizador Alpha 1', 'Uniport 3030', 'Jacto', 2021, 36.0, 3000.0, 'JT2021001'),
('650e8400-e29b-41d4-a716-446655440002', NOW(), NOW(), 'Pulverizador Beta 2', 'R4040', 'John Deere', 2020, 42.0, 4000.0, 'JD2020002'),
('650e8400-e29b-41d4-a716-446655440003', NOW(), NOW(), 'Pulverizador Gamma 3', 'FLX4260', 'Case IH', 2022, 36.5, 4200.0, 'CI2022003'),
('650e8400-e29b-41d4-a716-446655440004', NOW(), NOW(), 'Pulverizador Delta 4', 'Montana Parruda', 'Montana', 2019, 28.0, 2500.0, 'MT2019004'),
('650e8400-e29b-41d4-a716-446655440005', NOW(), NOW(), 'Pulverizador Epsilon 5', 'Advance Vortex', 'Jacto', 2023, 40.0, 5000.0, 'JT2023005');

-- Inserir Talhões
INSERT INTO talhoes (id, created_at, updated_at, nome, area_hectares, cultura, variedade, coordenadas_geograficas) VALUES
('750e8400-e29b-41d4-a716-446655440001', NOW(), NOW(), 'Talhão Norte', 25.5, 'Soja', 'M 6410 IPRO', '-25.0945,-50.1593'),
('750e8400-e29b-41d4-a716-446655440002', NOW(), NOW(), 'Talhão Sul', 32.8, 'Milho', 'AG 9030 PRO3', '-25.1045,-50.1693'),
('750e8400-e29b-41d4-a716-446655440003', NOW(), NOW(), 'Talhão Leste', 18.2, 'Soja', 'NS 6906 IPRO', '-25.0845,-50.1493'),
('750e8400-e29b-41d4-a716-446655440004', NOW(), NOW(), 'Talhão Oeste', 41.7, 'Trigo', 'TBIO Sintonia', '-25.1145,-50.1793'),
('750e8400-e29b-41d4-a716-446655440005', NOW(), NOW(), 'Talhão Central', 28.9, 'Algodão', 'TMG 44 B2RF', '-25.0995,-50.1643'),
('750e8400-e29b-41d4-a716-446655440006', NOW(), NOW(), 'Talhão Nascente', 35.1, 'Soja', 'BMX Turbo RR', '-25.0895,-50.1543'),
('750e8400-e29b-41d4-a716-446655440007', NOW(), NOW(), 'Talhão Poente', 22.4, 'Milho', 'DKB 390 PRO3', '-25.1095,-50.1743');

-- Inserir Tipos de Aplicação
INSERT INTO tipos_aplicacao (id, created_at, updated_at, nome, descricao, vazao_padrao, tipo_produto, unidade_medida) VALUES
('850e8400-e29b-41d4-a716-446655440001', NOW(), NOW(), 'Herbicida Pré-Emergente', 'Aplicação de herbicida antes da germinação da cultura', 150.0, 'Herbicida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440002', NOW(), NOW(), 'Herbicida Pós-Emergente', 'Aplicação de herbicida após emergência da cultura', 120.0, 'Herbicida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440003', NOW(), NOW(), 'Fungicida Preventivo', 'Aplicação preventiva de fungicida', 100.0, 'Fungicida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440004', NOW(), NOW(), 'Fungicida Curativo', 'Aplicação curativa de fungicida', 100.0, 'Fungicida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440005', NOW(), NOW(), 'Inseticida Sistêmico', 'Aplicação de inseticida sistêmico', 80.0, 'Inseticida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440006', NOW(), NOW(), 'Inseticida de Contato', 'Aplicação de inseticida de contato', 120.0, 'Inseticida', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440007', NOW(), NOW(), 'Adubo Foliar', 'Aplicação de fertilizante foliar', 200.0, 'Fertilizante', 'L/ha'),
('850e8400-e29b-41d4-a716-446655440008', NOW(), NOW(), 'Dessecante', 'Aplicação de dessecante para colheita', 100.0, 'Dessecante', 'L/ha');

-- Inserir Aplicações
INSERT INTO aplicacoes (id, created_at, updated_at, talhao_id, equipamento_id, tipo_aplicacao_id, data_inicio, data_fim, dosagem, volume_aplicado, operador, condicao_climatica, observacoes, finalizada) VALUES
-- Aplicações finalizadas (últimos 2 meses)
('950e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '45 days', NOW() - INTERVAL '44 days', '750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '45 days' + TIME '08:00:00', NOW() - INTERVAL '45 days' + TIME '12:30:00', 3.5, 892.5, 'Carlos Oliveira', 'Ensolarado, vento 8 km/h', 'Aplicação realizada conforme recomendação técnica', true),

('950e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '38 days', NOW() - INTERVAL '38 days', '750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '38 days' + TIME '07:30:00', NOW() - INTERVAL '38 days' + TIME '11:45:00', 1.2, 393.6, 'Roberto Lima', 'Nublado, sem vento', 'Primeira aplicação preventiva da safra', true),

('950e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '32 days', NOW() - INTERVAL '32 days', '750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '32 days' + TIME '09:00:00', NOW() - INTERVAL '32 days' + TIME '12:00:00', 2.8, 509.6, 'Carlos Oliveira', 'Parcialmente nublado, vento 5 km/h', 'Controle de plantas daninhas pós-emergente', true),

('950e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '28 days', NOW() - INTERVAL '28 days', '750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440004', '850e8400-e29b-41d4-a716-446655440005', NOW() - INTERVAL '28 days' + TIME '08:15:00', NOW() - INTERVAL '28 days' + TIME '14:30:00', 0.8, 333.6, 'Roberto Lima', 'Ensolarado, vento 12 km/h', 'Controle de pragas no trigo', true),

('950e8400-e29b-41d4-a716-446655440005', NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days', '750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440005', '850e8400-e29b-41d4-a716-446655440007', NOW() - INTERVAL '25 days' + TIME '07:45:00', NOW() - INTERVAL '25 days' + TIME '10:30:00', 4.0, 1156.0, 'Carlos Oliveira', 'Ensolarado, vento 6 km/h', 'Adubação foliar no algodão', true),

('950e8400-e29b-41d4-a716-446655440006', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days', '750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '20 days' + TIME '08:30:00', NOW() - INTERVAL '20 days' + TIME '13:15:00', 1.5, 526.5, 'Roberto Lima', 'Nublado, vento 3 km/h', 'Fungicida curativo para ferrugem', true),

('950e8400-e29b-41d4-a716-446655440007', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days', '750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440006', NOW() - INTERVAL '15 days' + TIME '09:15:00', NOW() - INTERVAL '15 days' + TIME '12:45:00', 1.8, 403.2, 'Carlos Oliveira', 'Ensolarado, vento 10 km/h', 'Controle de lagartas no milho', true),

('950e8400-e29b-41d4-a716-446655440008', NOW() - INTERVAL '12 days', NOW() - INTERVAL '12 days', '750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '12 days' + TIME '07:00:00', NOW() - INTERVAL '12 days' + TIME '11:30:00', 1.0, 255.0, 'Roberto Lima', 'Parcialmente nublado, vento 7 km/h', 'Segunda aplicação preventiva', true),

('950e8400-e29b-41d4-a716-446655440009', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days', '750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440004', '850e8400-e29b-41d4-a716-446655440005', NOW() - INTERVAL '8 days' + TIME '08:45:00', NOW() - INTERVAL '8 days' + TIME '11:15:00', 0.9, 163.8, 'Carlos Oliveira', 'Ensolarado, vento 4 km/h', 'Controle de percevejos', true),

('950e8400-e29b-41d4-a716-446655440010', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', '750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440005', '850e8400-e29b-41d4-a716-446655440008', NOW() - INTERVAL '5 days' + TIME '09:30:00', NOW() - INTERVAL '5 days' + TIME '13:00:00', 2.2, 721.6, 'Roberto Lima', 'Nublado, vento 9 km/h', 'Dessecação para colheita', true),

-- Aplicações em andamento/programadas
('950e8400-e29b-41d4-a716-446655440011', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', '750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440007', NOW() - INTERVAL '2 days' + TIME '08:00:00', NULL, 3.8, 1584.6, 'Carlos Oliveira', 'Ensolarado, vento 11 km/h', 'Adubação foliar em andamento', false),

('950e8400-e29b-41d4-a716-446655440012', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', '750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '1 day' + TIME '07:30:00', NULL, 1.3, NULL, 'Roberto Lima', 'Parcialmente nublado, vento 6 km/h', 'Tratamento fungicida em execução', false),

('950e8400-e29b-41d4-a716-446655440013', NOW(), NOW(), '750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440002', NOW() + TIME '09:00:00', NULL, 2.5, NULL, 'Carlos Oliveira', 'Programado para hoje', 'Aplicação programada para hoje de manhã', false);

-- Comentários sobre os dados inseridos:
-- - 5 usuários com diferentes roles
-- - 5 equipamentos de diferentes fabricantes e capacidades
-- - 7 talhões com culturas variadas da região
-- - 8 tipos de aplicação comuns na agricultura
-- - 13 aplicações: 10 finalizadas (últimos 45 dias) e 3 em andamento/programadas
-- - Dados realistas com coordenadas da região de Ponta Grossa/PR
-- - Volumes e dosagens dentro de parâmetros técnicos
-- - Senhas hasheadas (senha padrão: 123456)
-- - UUIDs únicos para todas as entidades