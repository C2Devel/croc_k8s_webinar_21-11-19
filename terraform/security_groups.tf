resource "aws_security_group" "kube" {
  vpc_id = "${aws_vpc.kube.id}"
  name   = "kubernetes"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all internal
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

resource "aws_security_group" "ssh" {
  vpc_id = "${aws_vpc.kube.id}"
  name   = "ssh"

  # Allow ssh inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
