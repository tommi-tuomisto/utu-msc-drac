resource "cloudflare_record" "liferayapp" {
  allow_overwrite = true
  zone_id         = var.cloudflare_zone_id
  name            = var.cloudflare_record_name
  value           = aws_eip.web_eip.public_ip
  type            = "A"
  proxied         = false
}
