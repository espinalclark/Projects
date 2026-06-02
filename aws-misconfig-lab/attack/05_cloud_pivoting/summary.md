# Fase 05 - Cloud Pivoting

## Estado
FUERA DE SCOPE - Sin credenciales SSH al jumpbox

## Vector Identificado
Jumpbox IP: 18.206.135.210
Puerto 22 abierto (confirmado en Fase 00 recon)

## Por qué no se ejecutó
No se obtuvieron credenciales SSH durante el engagement.
En un pentest real se intentaría via:
  - SSM Session Manager (si SSM agent está instalado)
  - Keys encontradas en S3 o Secrets Manager
  - EC2 Instance Connect

## Impacto Potencial
Acceso a subnet privada → recursos internos no expuestos
a internet (RDS, servicios internos, otras instancias).
