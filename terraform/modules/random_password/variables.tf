variable "length" {
  description = "The length of the password"
  type        = number
}

variable "min_upper" {
  description = "The minimum number of uppercase letters in the password"
  type        = number
}

variable "min_lower" {
  description = "The minimum number of lowercase letters in the password"
  type        = number
}

variable "min_numeric" {
  description = "The minimum number of numeric characters in the password"
  type        = number
}

variable "min_special" {
  description = "The minimum number of special characters in the password"
  type        = number
}

variable "override_special" {
  description = "Special characters to use in the password"
  type        = string
}
