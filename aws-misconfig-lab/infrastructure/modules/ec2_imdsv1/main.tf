# ⚠️ SOLO PARA LABORATORIO CONTROLADO
# Vector: SSRF → IMDSv1 credential theft

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "webserver" {
  name        = "${var.lab_prefix}-webserver-sg"
  description = "SG vulnerable - lab only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lab_prefix}-webserver-sg", Lab = "misconfig" }
}

resource "aws_security_group" "jumpbox" {
  name        = "${var.lab_prefix}-jumpbox-sg"
  description = "SG jumpbox - lab only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lab_prefix}-jumpbox-sg", Lab = "misconfig" }
}

resource "aws_key_pair" "lab" {
  key_name   = "${var.lab_prefix}-lab-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

locals {
  user_data = base64encode(join("\n", [
    "#!/bin/bash",
    "apt-get update -y",
    "apt-get install -y python3",
    "cat > /home/ubuntu/app.py << 'PYEOF'",
    "import urllib.request",
    "from http.server import HTTPServer, BaseHTTPRequestHandler",
    "from urllib.parse import urlparse, parse_qs",
    "",
    "class SSRFHandler(BaseHTTPRequestHandler):",
    "    def do_GET(self):",
    "        parsed = urlparse(self.path)",
    "        params = parse_qs(parsed.query)",
    "        if parsed.path == '/fetch' and 'url' in params:",
    "            url = params['url'][0]",
    "            try:",
    "                with urllib.request.urlopen(url, timeout=5) as r:",
    "                    body = r.read()",
    "                self.send_response(200)",
    "                self.end_headers()",
    "                self.wfile.write(body)",
    "            except Exception as e:",
    "                self.send_response(500)",
    "                self.end_headers()",
    "                self.wfile.write(str(e).encode())",
    "        else:",
    "            self.send_response(200)",
    "            self.end_headers()",
    "            self.wfile.write(b'Corp Webserver - try /fetch?url=')",
    "    def log_message(self, format, *args):",
    "        pass",
    "",
    "HTTPServer(('0.0.0.0', 8080), SSRFHandler).serve_forever()",
    "PYEOF",
    "python3 /home/ubuntu/app.py &"
  ]))
}

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.webserver.id]
  iam_instance_profile   = var.ec2_instance_profile_name
  key_name               = aws_key_pair.lab.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }

  user_data_base64 = local.user_data

  tags = {
    Name = "${var.lab_prefix}-webserver"
    Lab  = "misconfig"
  }
}

resource "aws_instance" "jumpbox" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.jumpbox.id]
  key_name               = aws_key_pair.lab.key_name

  tags = {
    Name = "${var.lab_prefix}-jumpbox"
    Lab  = "misconfig"
  }
}
