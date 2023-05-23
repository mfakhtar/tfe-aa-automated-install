# Generate the SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.unique_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_pem" {
  description = "The private key (save this in a .pem file) for ssh to instances"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

/*
output "ssh_public_ip" {
  description = "Command for ssh to the Client public IP of the EC2 Instance"
  value = [
    "ssh ubuntu@${aws_eip.bar.public_dns} -i ~/.ssh/terraform.pem"
  ]
}
*/