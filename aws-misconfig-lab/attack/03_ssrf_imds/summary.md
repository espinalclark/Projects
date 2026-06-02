# Fase 03 - SSRF + IMDS - Robo de Credenciales

## Vulnerabilidades Encadenadas
- SSRF via /fetch?url= sin validación de URL
- IMDSv1 habilitado sin requerir token

## Attack Chain
1. SSRF apunta a http://169.254.169.254/latest/meta-data/
2. Enumeración de IAM role: corp-ec2-instance-role
3. Extracción de credenciales temporales via IMDS
4. Configuración local y verificación de identidad

## Credenciales Obtenidas
AccessKeyId: ASIAVDYITFDVLSBEVNMQ
Expiration:  2026-06-02T02:59:15Z

## Identidad Comprometida
UserId:  AROAVDYITFDVKQCZZKAJR:i-08d23c456f1851f76
Account: 351668480234
Arn:     arn:aws:sts::351668480234:assumed-role/corp-ec2-instance-role/i-08d23c456f1851f76

## Impacto
Acceso completo a la API de AWS como corp-ec2-instance-role.
Cualquier permiso asignado a este role es ahora explotable.

## Siguiente Fase
Enumerar permisos del role comprometido → Fase 02
