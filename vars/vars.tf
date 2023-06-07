variable "Team" {
  default = "Manchester United"
}

variable "Year" {
  default = 2003
}

output "Team" {
  value = var.Team
}


output "Year" {
  value = var.Year
}

output "My_Team" {
  value = "Value of Team - ${var.Team}"
}
