locals {
  are_there_any_public_subnets  = length(var.public_subn) > 0
  are_there_any_private_subnets = length(var.private_subn) > 0
  anywhere                      = "0.0.0.0/0"
}