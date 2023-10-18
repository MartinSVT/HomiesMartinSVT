variable "RGName" {
  type        = string
  description = "Resource groupe name"
}

variable "RGLocation" {
  type        = string
  description = "Resource groupe location"
}

variable "ASPName" {
  type        = string
  description = "App service plan name"
}

variable "AppSName" {
  type        = string
  description = "App service name"
}

variable "SQLSname" {
  type        = string
  description = "SQL server name"
}

variable "SQLDBName" {
  type        = string
  description = "SQL Database name"
}

variable "SQLUsername" {
  type        = string
  description = "SQL administrator username"
}

variable "SQLPassword" {
  type        = string
  description = "SQL administrator password"
}

variable "FRName" {
  type        = string
  description = "Firewall rule name"
}

variable "RepoURL" {
  type        = string
  description = "Repo URL"
}