variable "vpc_config" {
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    tags                 = map(string)
  })
}
variable "public_subn" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
    tags              = map(string)
  }))
}
variable "private_subn" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
    tags              = map(string)
  }))
}