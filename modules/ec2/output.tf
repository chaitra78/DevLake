output "instance_id" {
  value = aws_instance.openproject.id
}

output "instance_private_ip" {
  value = aws_instance.openproject.private_ip
}
