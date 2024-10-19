resource "aws_instance" "test-server" {
  ami = "ami-09b23fgaesd8cd148"
  instance_type = "t2.micro"
  key_name = "final-key"
  vpc_security_group_ids = ["sg-04as4e1591bd05236"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./mykey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Project/terraform-files/ansibleplaybook.yml"
     }
  }
