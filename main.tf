provider "aws" {
   region = "eu-central-1"
   access_key                   = "<copy_access_key_here>"
   secret_key                   = "<copy_secret_key_here>"
}

resource "aws_instance" "clus" {
   ami                          = "ami-071e61cec88c326c5"
   instance_type                = "t3.medium"
   availability_zone            = "eu-central-1a"
   subnet_id                    = "subnet-8a1180e0" 
   vpc_security_group_ids       = ["sg-6511e718","sg-03c652c443254a927"]
   key_name                     = "fracaen-key01"

   user_data = <<-EOF
       Section: IOS configuration
       hostname ciscolive
       ip domain name cisco.local
       aaa new-model
       aaa authentication login default local
       crypto key generate rsa general-keys modulus 4096
       ip ssh version 2
       username cisco123 privilege 15 secret cisco123
       enable secret cisco123
       restconf
   EOF
   
   #provisioner "local-exec" {
   #   command = "ansible-playbook edge.yml --extra-vars 'edge_public=${aws_instance.clus.public_ip}'"
   #}
}

output "instance_public_ip" {
   value                        = aws_instance.clus.public_ip
}

output "instance_private_ip" {
   value                        = aws_instance.clus.private_ip
}
