# Fase -01 - Reconocimiento Externo

## Target
IP: 13.218.182.76
DNS: ec2-13-218-182-76.compute-1.amazonaws.com
Cloud: AWS EC2 us-east-1
Account ID: 351668480234

## Puertos Abiertos
- 22/tcp SSH (wrapeado)
- 8080/tcp HTTP Python/3.10.12
- 80/tcp cerrado

## Hallazgos Críticos
1. Server banner expone endpoint /fetch?url= → SSRF confirmado
2. Infraestructura AWS EC2 confirmada via reverse DNS
3. S3 buckets no enumerables externamente (nombres con sufijos únicos)
4. ffuf descubrió catch-all handler → todos los paths devuelven 200

## Vectores Identificados
- SSRF via /fetch?url= → objetivo principal Fase 01

## Siguiente Fase
Explotar SSRF para acceder a IMDS 169.254.169.254
