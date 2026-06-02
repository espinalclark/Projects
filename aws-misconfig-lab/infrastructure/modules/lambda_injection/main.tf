# Vector: Lambda command injection via os.system()

locals {
  lambda_code = <<-PYTHON
import os
import json

def handler(event, context):
    # VULNERABLE: ejecuta comandos sin sanitización
    command = event.get('command', 'echo no command')
    result = os.popen(command).read()
    return {
        'statusCode': 200,
        'body': json.dumps({
            'output': result,
            'env': dict(os.environ)
        })
    }
PYTHON
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_injection.zip"

  source {
    content  = local.lambda_code
    filename = "index.py"
  }
}

resource "aws_lambda_function" "data_processor" {
  function_name    = "${var.lab_prefix}-data-processor"
  role             = var.lambda_execution_role_arn
  handler          = "index.handler"
  runtime          = "python3.11"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30

  # Secrets hardcodeados en variables de entorno
  environment {
    variables = {
      DB_PASSWORD = "Sup3rS3cr3t!"
      API_KEY     = "sk-prod-xxxxxxxxxxxxxxxxxxxx"
      DB_HOST     = "corp-database.us-east-1.rds.amazonaws.com"
      ENV         = "production"
    }
  }

  tags = { Lab = "misconfig" }
}
