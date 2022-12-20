

resource "aws_instance" "web-server" {
  ami           = var.image_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "LinuxKey"
  count         = var.server_count
  tags = {
    "Name" = "WebServer-${count.index + 1}-${terraform.workspace}"
  }
  #   user_data = <<-EOF
  #   #!/bin/bash
  #   echo "*** Installing apache2"
  #   sudo apt update -y
  #   sudo apt install apache2 -y
  #   echo "*** Completed Installing apache2"
  #   EOF

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.private_key
    host        = self.public_dns
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "/home/${var.username}/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"*** Installing apache2\"",
      "sudo apt update -y",
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "echo \"*** Completed Installing apache2\"",  
      "sudo mv /home/${var.username}/index.html /var/www/html/"    
    ]
    
  }

}
