# Fase 02 - Enumeración Post-Compromiso

## Identidad Comprometida
Role: corp-ec2-instance-role
ARN: arn:aws:sts::351668480234:assumed-role/corp-ec2-instance-role/i-08d23c456f1851f76

## Permisos Descubiertos
| Acción | Resultado |
|--------|-----------|
| iam:ListAttachedRolePolicies | DENEGADO |
| lambda:ListFunctions | DENEGADO |
| secretsmanager:ListSecrets | DENEGADO |
| ssm:DescribeParameters | DENEGADO |
| s3:ListAllMyBuckets | PERMITIDO |
| s3:GetObject | PERMITIDO |

## Buckets S3 Encontrados
- corp-backup-2024
- corp-internal-docs
- corp-tf-state-lab
- corp-cloudtrail-351668480234

## Hallazgos Críticos

### H01 - Password en Terraform State
Archivo: s3://corp-tf-state-lab/terraform.tfstate
Dato: password = "Sup3rS3cr3t!"
Severidad: CRÍTICA

### H02 - Credenciales AWS Hardcodeadas
Archivo: s3://corp-backup-2024/configs/credentials.txt
Usuario: dev-user
AccessKeyId: AKIAIOSFODNN7EXAMPLE
Severidad: CRÍTICA

### H03 - Datos PII de Empleados
Archivo: s3://corp-internal-docs/hr/employees.csv
Registros: 3 empleados con nombre, email, rol y salario
Severidad: ALTA

## Impacto
Exposición de credenciales AWS, passwords de base de datos
y datos personales de empleados incluyendo CTO.

## Siguiente Fase
Explotar Lambda RCE → Fase 04

