provider "aws" {
   region = "us-west-2"
   access_key                   = "AKIAURZJ36KXOHXNMIM3"
   secret_key                   = "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"
}

resource "aws_instance" "clusxx" {
   ami                          = "ami-08ff3b00ec566077f"
   instance_type                = "t3.medium"
   availability_zone            = "us-west-2a"
   subnet_id                    = "subnet-05f592b7d29d6ffb6" 
   vpc_security_group_ids       = ["sg-07e4c0feae9610689", "sg-009cadf7ad0eed2ca", "sg-08550876608db9ccc"]
   key_name                     = "FCKeyPair1"

   user_data = <<-EOF
       Section: IOS configuration
       hostname clusxx
       ip domain name cisco.local
       aaa new-model
       aaa authentication login default local
       crypto key generate rsa general-keys modulus 4096
       ip ssh version 2
       username cisco123 privilege 15 secret cisco123
       enable secret cisco123
       restconf
   EOF
}

output "instance_public_ip" {
   value                        = aws_instance.clusxx.public_ip
}

output "instance_private_ip" {
   value                        = aws_instance.clusxx.private_ip
}
