#output
output "web_ip" {
  value = aws_eip.web_eip.public_ip
}
output "app_ip" {
  value = aws_eip.app_eip.public_ip
}
output "db_ip" {
  value = aws_eip.db_eip.public_ip
}
output "se_ip" {
  value = aws_eip.se_eip.public_ip
}
output "fqdn" {
  value = format("%s.%s", var.cloudflare_record_name, var.cloudflare_domain)
}
