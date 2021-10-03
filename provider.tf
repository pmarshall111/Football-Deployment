// provider definition to prevent terraform from asking for region for each command
provider "aws" {
  region = "eu-west-2"
}