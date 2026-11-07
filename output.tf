output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "aws_public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "aws_private_subnet_id" {
  value = aws_subnet.private[*].id
}

output "aws_database_subnet_id" {
  value = aws_subnet.database[*].id
}