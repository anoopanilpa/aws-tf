output "public_ip" {
    value = aws_instance.samplew_web.public_ip
}

output "private_ip" {
    value = aws_instance.samplew_web.private_ip
}