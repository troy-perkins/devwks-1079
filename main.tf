provider "aws" {
   region = "us-west-2"
   access_key                   = "<copy_access_key_here>"
   secret_key                   = "<copy_secret_key_here>"
}

resource "aws_instance" "clus" {
   ami                          = "ami-08ff3b00ec566077f"
   instance_type                = "t3.medium"
   availability_zone            = "us-west-2a"
   subnet_id                    = "subnet-037583d36835d96b2" 
   vpc_security_group_ids       = ["sg-0455f1afa6a3c3542", "sg-07962dfffbd00570e"]
   key_name                     = "FCKeyPair1"

   user_data = <<-EOF
       Section: IOS configuration
       hostname clus
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
