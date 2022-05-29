#network
resource "aws_vpc" "liferay" { 
  cidr_block = "10.0.0.0/24"
  tags       = {
    Name = "liferay-vpc"
  }
}

resource "aws_internet_gateway" "inetgw" {
  vpc_id = aws_vpc.liferay.id
  tags   = {
    Name = "liferay-internet-gateway"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.liferay.id
  cidr_block = "10.0.0.0/28"
  tags       = {
    Name = "liferay-private-subnet"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.liferay.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inetgw.id
  }
  tags   = {
    Name = "liferay-route-to-internet"
  }
}

resource "aws_route_table_association" "private_to_internet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  vpc      = true
  tags     = {
    Name = "liferay-web-eip"
  }
}

resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
  vpc      = true
  tags     = {
    Name = "liferay-app-eip"
  }
}

resource "aws_eip" "db_eip" {
  instance = aws_instance.database.id
  vpc      = true
  tags     = {
    Name = "liferay-db-eip"
  }
}

resource "aws_eip" "se_eip" {
  instance = aws_instance.search.id
  vpc      = true
  tags     = {
    Name = "liferay-se-eip"
  }
}
