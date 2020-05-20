variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map

  default = {
    application = "terraform-hack2"
    environment = "development"
    buildagent = "local"
  }
}