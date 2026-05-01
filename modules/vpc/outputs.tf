output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "subnet_2_id" {
  value = aws_subnet.private_2.id
}

output "public_subnet_id" {
  value = aws_subnet.public_1.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}