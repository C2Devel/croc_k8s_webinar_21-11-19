data "template_file" "node" {
  template = "${file("${path.root}/cloudinits/node.tpl")}"

  vars = {
    control_plane_ip = "${aws_instance.master.private_ip}"
    bootstrap_token  = "${var.bootstrap_token}"
  }
}

data "template_cloudinit_config" "node" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.node.rendered}"
  }
}

resource "aws_placement_group" "node" {
  name     = "node"
  strategy = "spread"
}

resource "aws_instance" "node" {
  count         = "${var.nodes_count}"
  ami           = "${var.kubernetes_ami}"
  instance_type = "c3.large"

  placement_group = "${aws_placement_group.node.id}"

  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  source_dest_check                    = false

  subnet_id = "${aws_subnet.private.*.id[count.index % length(data.aws_availability_zones.az.names)]}"

  vpc_security_group_ids = [
    "${aws_security_group.kube.id}",
  ]

  key_name = "${aws_key_pair.kube.key_name}"

  user_data = "${data.template_cloudinit_config.node.rendered}"

  monitoring = "true"

  depends_on = [
    "aws_instance.master",
  ]

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo 'Destroy-time provisioner'"
  }
}
