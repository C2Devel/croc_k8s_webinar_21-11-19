data "template_file" "master" {
  template = "${file("${path.root}/cloudinits/master.tpl")}"

  vars = {
    bootstrap_token = "${var.bootstrap_token}"
    kubernetes_version = "${var.kubernetes_version}"
  }
}

data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.master.rendered}"
  }
}

resource "aws_instance" "master" {
  count = "1"

  ami           = "${var.kubernetes_ami}"
  instance_type = "c3.large"

  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  source_dest_check                    = false

  subnet_id = "${aws_subnet.private.*.id[count.index % length(data.aws_availability_zones.az.names)]}"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.kube.id}",
  ]

  key_name = "${aws_key_pair.kube.key_name}"

  user_data = "${data.template_cloudinit_config.master.rendered}"

  monitoring = "true"
}
