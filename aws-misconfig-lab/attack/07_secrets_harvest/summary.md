# Fase 07 - Secrets Harvest

## Role Utilizado
corp-lambda-execution-role (obtenido via privesc en Fase 06)

## Secrets Manager
Secret: prod/corp/master-key
  username:    corp-admin
  password:    M4st3rK3y-2024!
  db_host:     corp-database.us-east-1.rds.amazonaws.com
  admin_token: JWT token (fake - lab)

## SSM Parameter Store
/corp/admin/secret  → adm1n-sup3r-s3cr3t-2024!
/corp/api/key       → sk-prod-xxxxxxxxxxxxxxxxxxxx
/corp/db/password   → Sup3rS3cr3t!

## Misconfiguration
SecureString parameters desencriptados via kms:Decrypt
implícito en el Lambda execution role. Permisos KMS excesivos.

## Impacto
Acceso total a credenciales de base de datos, admin token
y API keys de producción desde un role de Lambda comprometido.

## Siguiente Fase
Fase 08 - Persistence
