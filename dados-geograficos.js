// Script para inserir dados geográficos fictícios no MongoDB
// Execute este script conectado ao MongoDB da aplicação
// Dados de trajetórias para as aplicações criadas no PostgreSQL

// Coordenadas base da região de Ponta Grossa/PR
const baseLatitude = -25.0945;
const baseLongitude = -50.1593;

// Função para gerar pontos de trajetória realistas
function gerarTrajetoria(pontoInicial, distanciaTotal, larguraBarra, velocidadeMedia) {
    const pontos = [];
    const numPontos = Math.floor(distanciaTotal / 50); // Um ponto a cada 50 metros
    const incrementoLat = 0.0001; // Aproximadamente 11 metros
    const incrementoLng = 0.00015; // Aproximadamente 11 metros
    
    let latAtual = pontoInicial.latitude;
    let lngAtual = pontoInicial.longitude;
    let timestamp = new Date(pontoInicial.timestamp);
    
    for (let i = 0; i < numPontos; i++) {
        // Simular movimento em linha reta com pequenas variações
        if (i % 20 === 0) { // Mudança de direção a cada ~1km
            latAtual += (Math.random() - 0.5) * incrementoLat * 2;
        } else {
            lngAtual += incrementoLng * (Math.random() * 0.5 + 0.75); // Movimento principal
            latAtual += (Math.random() - 0.5) * incrementoLat * 0.3; // Pequena variação
        }
        
        timestamp = new Date(timestamp.getTime() + (50 / (velocidadeMedia / 3.6)) * 1000); // 50m / velocidade
        
        pontos.push({
            latitude: latAtual,
            longitude: lngAtual,
            timestamp: timestamp,
            altitude: 850 + Math.random() * 20, // Altitude da região
            speed: velocidadeMedia + (Math.random() - 0.5) * 4, // Variação de ±2 km/h
            accuracy: 2 + Math.random() * 3 // Precisão GPS 2-5m
        });
    }
    
    return pontos;
}

// Dados das trajetórias para cada aplicação finalizada
const trajetorias = [
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440001", // Talhão Norte - Soja
        pontoInicial: {
            latitude: -25.0945,
            longitude: -50.1593,
            timestamp: new Date("2024-11-02T08:00:00Z"),
            altitude: 850,
            speed: 15,
            accuracy: 3
        },
        pontoFinal: {
            latitude: -25.0920,
            longitude: -50.1550,
            timestamp: new Date("2024-11-02T12:30:00Z"),
            altitude: 855,
            speed: 0,
            accuracy: 2
        },
        areaCobertura: 25.5,
        distanciaPercorrida: 2850
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440002", // Talhão Sul - Milho
        pontoInicial: {
            latitude: -25.1045,
            longitude: -50.1693,
            timestamp: new Date("2024-11-09T07:30:00Z"),
            altitude: 845,
            speed: 14,
            accuracy: 2
        },
        pontoFinal: {
            latitude: -25.1015,
            longitude: -50.1645,
            timestamp: new Date("2024-11-09T11:45:00Z"),
            altitude: 848,
            speed: 0,
            accuracy: 3
        },
        areaCobertura: 32.8,
        distanciaPercorrida: 3680
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440003", // Talhão Leste - Soja
        pontoInicial: {
            latitude: -25.0845,
            longitude: -50.1493,
            timestamp: new Date("2024-11-15T09:00:00Z"),
            altitude: 855,
            speed: 16,
            accuracy: 2
        },
        pontoFinal: {
            latitude: -25.0825,
            longitude: -50.1460,
            timestamp: new Date("2024-11-15T12:00:00Z"),
            altitude: 860,
            speed: 0,
            accuracy: 4
        },
        areaCobertura: 18.2,
        distanciaPercorrida: 2040
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440004", // Talhão Oeste - Trigo
        pontoInicial: {
            latitude: -25.1145,
            longitude: -50.1793,
            timestamp: new Date("2024-11-19T08:15:00Z"),
            altitude: 840,
            speed: 13,
            accuracy: 3
        },
        pontoFinal: {
            latitude: -25.1100,
            longitude: -50.1735,
            timestamp: new Date("2024-11-19T14:30:00Z"),
            altitude: 845,
            speed: 0,
            accuracy: 2
        },
        areaCobertura: 41.7,
        distanciaPercorrida: 4650
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440005", // Talhão Central - Algodão
        pontoInicial: {
            latitude: -25.0995,
            longitude: -50.1643,
            timestamp: new Date("2024-11-22T07:45:00Z"),
            altitude: 852,
            speed: 15,
            accuracy: 2
        },
        pontoFinal: {
            latitude: -25.0970,
            longitude: -50.1610,
            timestamp: new Date("2024-11-22T10:30:00Z"),
            altitude: 857,
            speed: 0,
            accuracy: 3
        },
        areaCobertura: 28.9,
        distanciaPercorrida: 3220
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440006", // Talhão Nascente - Soja
        pontoInicial: {
            latitude: -25.0895,
            longitude: -50.1543,
            timestamp: new Date("2024-11-27T08:30:00Z"),
            altitude: 858,
            speed: 14,
            accuracy: 3
        },
        pontoFinal: {
            latitude: -25.0865,
            longitude: -50.1505,
            timestamp: new Date("2024-11-27T13:15:00Z"),
            altitude: 862,
            speed: 0,
            accuracy: 2
        },
        areaCobertura: 35.1,
        distanciaPercorrida: 3920
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440007", // Talhão Poente - Milho
        pontoInicial: {
            latitude: -25.1095,
            longitude: -50.1743,
            timestamp: new Date("2024-12-02T09:15:00Z"),
            altitude: 847,
            speed: 16,
            accuracy: 2
        },
        pontoFinal: {
            latitude: -25.1075,
            longitude: -50.1715,
            timestamp: new Date("2024-12-02T12:45:00Z"),
            altitude: 850,
            speed: 0,
            accuracy: 4
        },
        areaCobertura: 22.4,
        distanciaPercorrida: 2500
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440008", // Talhão Norte - Segunda aplicação
        pontoInicial: {
            latitude: -25.0950,
            longitude: -50.1590,
            timestamp: new Date("2024-12-05T07:00:00Z"),
            altitude: 851,
            speed: 15,
            accuracy: 3
        },
        pontoFinal: {
            latitude: -25.0925,
            longitude: -50.1555,
            timestamp: new Date("2024-12-05T11:30:00Z"),
            altitude: 856,
            speed: 0,
            accuracy: 2
        },
        areaCobertura: 25.5,
        distanciaPercorrida: 2850
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440009", // Talhão Leste - Controle pragas
        pontoInicial: {
            latitude: -25.0850,
            longitude: -50.1490,
            timestamp: new Date("2024-12-09T08:45:00Z"),
            altitude: 856,
            speed: 14,
            accuracy: 2
        },
        pontoFinal: {
            latitude: -25.0830,
            longitude: -50.1465,
            timestamp: new Date("2024-12-09T11:15:00Z"),
            altitude: 861,
            speed: 0,
            accuracy: 3
        },
        areaCobertura: 18.2,
        distanciaPercorrida: 2040
    },
    
    {
        aplicacaoId: "950e8400-e29b-41d4-a716-446655440010", // Talhão Sul - Dessecação
        pontoInicial: {
            latitude: -25.1050,
            longitude: -50.1690,
            timestamp: new Date("2024-12-12T09:30:00Z"),
            altitude: 846,
            speed: 13,
            accuracy: 3
        },
        pontoFinal: {
            latitude: -25.1020,
            longitude: -50.1650,
            timestamp: new Date("2024-12-12T13:00:00Z"),
            altitude: 849,
            speed: 0,
            accuracy: 2
        },
        areaCobertura: 32.8,
        distanciaPercorrida: 3680
    }
];

// Script de inserção no MongoDB
console.log("Inserindo trajetórias geográficas...");

trajetorias.forEach((item, index) => {
    const velocidadeMedia = item.pontoInicial.speed;
    const trajetoria = gerarTrajetoria(item.pontoInicial, item.distanciaPercorrida, 36, velocidadeMedia);
    
    const documento = {
        aplicacaoId: item.aplicacaoId,
        pontoInicial: item.pontoInicial,
        pontoFinal: item.pontoFinal,
        trajetoria: trajetoria,
        areaCobertura: item.areaCobertura,
        distanciaPercorrida: item.distanciaPercorrida,
        createdAt: new Date(),
        updatedAt: new Date()
    };
    
    // Comando para inserir no MongoDB
    db.geo_trajetorias.insertOne(documento);
    console.log(`Trajetória ${index + 1} inserida - Aplicação: ${item.aplicacaoId}`);
});

console.log("Todas as trajetórias foram inseridas com sucesso!");
console.log(`Total de documentos inseridos: ${trajetorias.length}`);

// Comando para verificar os dados inseridos
console.log("\nPara verificar os dados inseridos, execute:");
console.log("db.geo_trajetorias.find().limit(5).pretty()");
console.log("db.geo_trajetorias.count()");

// Comandos úteis para consultas
console.log("\nConsultas úteis:");
console.log("// Buscar trajetória por aplicação:");
console.log('db.geo_trajetorias.findOne({"aplicacaoId": "950e8400-e29b-41d4-a716-446655440001"})');
console.log("\n// Buscar aplicações com área maior que 30 hectares:");
console.log('db.geo_trajetorias.find({"areaCobertura": {$gt: 30}})');
console.log("\n// Buscar aplicações por data:");
console.log('db.geo_trajetorias.find({"pontoInicial.timestamp": {$gte: new Date("2024-11-01")}})');