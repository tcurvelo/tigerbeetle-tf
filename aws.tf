# Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "cloud_init" {
    template = file("${path.module}/templates/tigerbeetle.tpl")
}

# EC2 instances (TigerBeetle replicas)
resource "aws_instance" "tigerbeetle" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  user_data     = data.template_file.cloud_init.rendered
}
