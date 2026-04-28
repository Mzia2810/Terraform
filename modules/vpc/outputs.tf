output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "subnet_2_id" {
  value = aws_subnet.private_2.id
}
output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}