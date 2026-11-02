terraform {
  required_providers {

    # TODO 1: required_providers for hashicorp/random (~> 3.6) and hashicorp/local (~> 2.5)

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = ">= 1.10"

}

# TODO 2: resource "random_pet" "name" - two words, separated by "-"
resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

# TODO 3: resource "local_file" "greeting" - "Hello from <pet>!" in ${path.module}/out/greeting.txt

# TODO 4: outputs pet_name and greeting_path
