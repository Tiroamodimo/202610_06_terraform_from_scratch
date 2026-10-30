terraform {
  required_version = ">= 1.10"

  # TODO 1: required_providers for hashicorp/random (~> 3.6) and hashicorp/local (~> 2.5)
}

# TODO 2: resource "random_pet" "name" - two words, separated by "-"

# TODO 3: resource "local_file" "greeting" - "Hello from <pet>!" in ${path.module}/out/greeting.txt

# TODO 4: outputs pet_name and greeting_path
