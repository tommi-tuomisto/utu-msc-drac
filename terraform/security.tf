#security
#https://stackoverflow.com/questions/69079945/terraform-inappropriate-value-for-attribute-ingress-while-creating-sg
resource "aws_security_group" "allow_default" {
  name        = "allow_default"
  description = "Default security group for all instances"
  vpc_id      = aws_vpc.liferay.id

  ingress = [
    {
      description      = "Allow SSH from selected IPs"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["185.192.12.128/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  egress = [
    {
      description      = "Allow all outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "liferay-allow-default"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow ingress web connections"
  vpc_id      = aws_vpc.liferay.id

  ingress = [
    {
      description      = "Allow TLS from everywhere"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    },
    {
      description      = "Allow HTTP from everywhere"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "liferay-allow-web"
  }
}

resource "aws_security_group" "allow_app" {
  name        = "allow_app"
  description = "Allow ingress application connections"
  vpc_id      = aws_vpc.liferay.id

  ingress = [
    {
      description      = "Allow connection to Tomcat from the webserver"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.6/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "liferay-allow-app"
  }
}

resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow ingress database connections"
  vpc_id      = aws_vpc.liferay.id

  ingress = [
    {
      description      = "Allow connection to SQL from the application server"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.8/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "liferay-allow-database"
  }
}

resource "aws_security_group" "allow_se" {
  name        = "allow_se"
  description = "Allow ingress search engine connections"
  vpc_id      = aws_vpc.liferay.id

  ingress = [
    {
      description      = "Allow connection to Elasticsearch from the application server"
      from_port        = 9200
      to_port          = 9200
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.8/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "liferay-allow-search"
  }
}
