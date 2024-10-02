module "vpc" {
  source = "./../"
  vpc_config = {
    cidr_block           = "192.168.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "ntier"
    }
  }
  public_subn = [{
    availability_zone = "ap-south-1a"
    cidr_block        = "192.168.0.0/24"
    tags = {
      Name = "web_01"
    }
    },
    {
      availability_zone = "ap-south-1b"
      cidr_block        = "192.168.1.0/24"
      tags = {
        Name = "web_02"
      }
  }]
  private_subn = [{
    availability_zone = "ap-south-1a"
    cidr_block        = "192.168.2.0/24"
    tags = {
      Name = "app_01"
    }
    },
    {
      availability_zone = "ap-south-1b"
      cidr_block        = "192.168.3.0/24"
      tags = {
        Name = "app_02"
      }
    },
    {
      availability_zone = "ap-south-1a"
      cidr_block        = "192.168.4.0/24"
      tags = {
        Name = "db_01"
      }
    },
    {
      availability_zone = "ap-south-1b"
      cidr_block        = "192.168.5.0/24"
      tags = {
        Name = "db_02"
      }
  }]
}
