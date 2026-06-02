# Fase 06 - Privilege Escalation

## Punto de Partida
Role: corp-ec2-instance-role
Permisos: Solo s3:GetObject, s3:ListBucket

## Vectores Intentados
1. iam:ListRoles → DENEGADO
2. iam:ListRolePolicies → DENEGADO  
3. Credenciales dev-user en S3 → INVÁLIDAS (keys de ejemplo)
4. sts:AssumeRole corp-lambda-execution-role → EXITOSO

## Escalada Exitosa
corp-ec2-instance-role → corp-lambda-execution-role

## Credenciales Obtenidas
AccessKeyId: ASIAVDYITFDVOP6MT6MQ
Arn: arn:aws:sts::351668480234:assumed-role/corp-lambda-execution-role/privesc-lambda

## Por qué funcionó
El trust policy de corp-lambda-execution-role permitía
sts:AssumeRole desde corp-ec2-instance-role sin restricciones.
Misconfiguration en la relación de confianza entre roles.

## Impacto
Acceso a lambda:InvokeFunction → RCE en corp-data-processor
Escalada de permisos limitados a ejecución de código arbitrario en Lambda.

## Siguiente Fase
Extraer secrets via credenciales del Lambda environment → Fase 07
