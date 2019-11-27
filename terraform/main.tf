provider "aws" {
  endpoints {
    ec2 = "https://api.cloud.croc.ru"
  }

  # NOTE: STS API is not implemented, skip validation
  skip_credentials_validation = true

  # NOTE: IAM API is not implemented, skip validation
  skip_requesting_account_id = true

  # NOTE: Region has different name, skip validation
  skip_region_validation = true

  region = "${var.region}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "aws_key_pair" "kube" {
  key_name   = "terraform"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

output "ssh" {
  value = "${tls_private_key.ssh.private_key_pem}"
}
