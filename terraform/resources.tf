resource "aws_key_pair" "rke" {
  key_name = "RKE"
  public_key = "${file("${var.ssh_public_key}")}"
}

resource "aws_security_group" "rke_sg" {
  name = "rke_sg"
  vpc_id = "vpc-6714bb01"
  ingress {
    description = "Allow_ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_postgres1"
    from_port = 30543
    to_port = 30543
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_postgres2"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_minio_service_port"
    from_port = 32000
    to_port = 32000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_minio_console_port"
    from_port = 32001
    to_port = 32001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_argocd"
    from_port = 30080
    to_port = 30080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_nfs"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_nfs2"
    from_port = 111
    to_port = 111
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_kubelet"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_BGP"
    from_port = 179
    to_port = 179
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow_controlplane"
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rke_sg1"
  }
}

# create instances
resource "aws_instance" "k8s_master" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name  = "${aws_key_pair.rke.id}"
  subnet_id     = "subnet-55dc171d"
  vpc_security_group_ids = ["${aws_security_group.rke_sg.id}"]
  tenancy     = "default"
  user_data = file("user_data_bootstrap.sh")

  tags = {
    Name = "rke_master"
  }
  # Define the block device for the instance
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
}


resource "aws_instance" "k8s_node1" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name  = "${aws_key_pair.rke.id}"
  subnet_id     = "subnet-55dc171d"
  vpc_security_group_ids = ["${aws_security_group.rke_sg.id}"]
  tenancy     = "default"
  user_data = file("user_data_bootstrap.sh")

  tags = {
    Name = "rke_node1"
  }

  # Define the block device for the instance
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
}

resource "aws_instance" "k8s_node2" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name  = "${aws_key_pair.rke.id}"
  subnet_id     = "subnet-55dc171d"
  vpc_security_group_ids = ["${aws_security_group.rke_sg.id}"]
  tenancy     = "default"
  user_data = file("user_data_bootstrap.sh")
  
  tags = {
    Name = "rke_node2"
  }
  
  # Define the block device for the instance
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
}