# ADD PUBLIC KEY TO AWS. IT WILL BE USED DURING VM CREATION
resource "aws_key_pair" "aws_key" {
  key_name   = "aws_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# SETUP SECURITY GROUP - AWS FIREWALL
resource "aws_security_group" "sg_jenkins" {
  name = "sg_jenkins"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VM INSTANCE
resource "aws_instance" "jenkins" {
  ami                       = var.AMIS["ubuntu"]
  instance_type             = var.INSTANCE_TYPE
  key_name                  = aws_key_pair.aws_key.key_name
  vpc_security_group_ids    = [aws_security_group.sg_jenkins.id]

  # WAIT FOR SSH TO BE READY
  provisioner "remote-exec" {
    inline = ["echo 'SSH is up!'"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.SSH_USER
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }
  }

  # RUN ANSIBLE PLAYBOOK TO SETUP JENKINS
  provisioner "local-exec" {
    working_dir = "${path.module}/ansible/"
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${var.PATH_TO_PRIVATE_KEY} jenkins.yaml"
  }
  
}