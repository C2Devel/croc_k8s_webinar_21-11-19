data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_vpc" "kube" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_eip" "master" {
  count = "1"
  vpc   = true
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.kube.id}"
  count             = "${length(data.aws_availability_zones.az.names)}"
  cidr_block        = "${var.private_subnet_cidr_list[count.index]}"
  availability_zone = "${data.aws_availability_zones.az.names[count.index]}"
}
