resource "aws_instance" "myec2" {
  ami                    = "ami-0866a3c8686eaeeba"
  key_name               = "onlaptop"
  vpc_security_group_ids = ["sg-091013677fa48d826"]
  root_block_device {
    volume_size = 20    # Size of the root EBS volume in GB
    volume_type = "gp2" # General Purpose SSD (you can also use gp3)
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./onlaptop.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install openjdk-21-jdk-headless -y",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y",
      "sudo apt install docker.io -y"
    ]
  }
}
