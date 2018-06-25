provider "aws" {
  region = "us-east-1"
}

resource "random_id" "random" {
  keepers = {
    password = "random string" // Using this for snapshot names
  }

  byte_length = 8
}

# setup api database
variable "api_username" {
  default = "api"
}

variable "api_database_name" {
  default = "api"
}

resource "random_id" "api_database_password" {
  keepers = {
    password = "${var.api_username}"
  }

  byte_length = 16
}

resource "aws_security_group" "api_security_group" {
  name        = "${var.api_username}-ec2"
  description = "Managed by Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_security_group" "api_db_security_group" {
  name        = "${var.api_database_name}-db"
  description = "Managed by Terraform"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.api_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "api_db_instance" {
  identifier             = "${var.api_database_name}"
  allocated_storage      = "5"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.6"
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = ["${aws_security_group.api_db_security_group.id}"]

  final_snapshot_identifier = "${var.api_database_name}-final-snapshot-${random_id.random.hex}"

  name     = "${var.api_database_name}"
  username = "${var.api_username}"
  password = "${random_id.api_database_password.hex}"
}

output "api_database_username" {
  value = "${aws_db_instance.api_db_instance.username}"
}

output "api_database_address" {
  value = "${aws_db_instance.api_db_instance.address}"
}

output "api_database_password" {
  value = "${aws_db_instance.api_db_instance.password}"
}

# setup website database
variable "websites_username" {
  default = "websites"
}

variable "websites_database_name" {
  default = "websites"
}

resource "random_id" "websites_database_password" {
  keepers = {
    password = "${var.websites_username}"
  }

  byte_length = 16
}

resource "aws_security_group" "websites_security_group" {
  name        = "${var.websites_username}-ec2"
  description = "Managed by Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_security_group" "websites_db_security_group" {
  name        = "${var.websites_database_name}-db"
  description = "Managed by Terraform"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.websites_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "websites_db_instance" {
  identifier             = "${var.websites_database_name}"
  allocated_storage      = "5"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.6"
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = ["${aws_security_group.websites_db_security_group.id}"]

  final_snapshot_identifier = "${var.websites_database_name}-final-snapshot-${random_id.random.hex}"

  name     = "${var.websites_database_name}"
  username = "${var.websites_username}"
  password = "${random_id.websites_database_password.hex}"
}

output "websites_database_username" {
  value = "${aws_db_instance.websites_db_instance.username}"
}

output "websites_database_address" {
  value = "${aws_db_instance.websites_db_instance.address}"
}

output "websites_database_password" {
  value = "${aws_db_instance.websites_db_instance.password}"
}
