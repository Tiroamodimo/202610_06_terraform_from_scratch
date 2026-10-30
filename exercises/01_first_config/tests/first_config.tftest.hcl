# Spec for exercise 01. Run with: make check EX=01_first_config
# terraform test applies into a throwaway state and destroys everything afterwards.

run "pet_name_has_two_words" {
  command = plan

  assert {
    condition     = random_pet.name.length == 2 && random_pet.name.separator == "-"
    error_message = "random_pet.name should have length 2 and separator \"-\"."
  }
}

run "writes_the_greeting_file" {
  command = apply

  assert {
    condition     = local_file.greeting.content == "Hello from ${random_pet.name.id}!"
    error_message = "The greeting should be exactly: Hello from <pet name>!"
  }

  assert {
    condition     = endswith(local_file.greeting.filename, "out/greeting.txt")
    error_message = "The file should be written to out/greeting.txt in the exercise folder."
  }

  assert {
    condition     = output.pet_name == random_pet.name.id
    error_message = "Output pet_name should be the pet name."
  }

  assert {
    condition     = output.greeting_path == local_file.greeting.filename
    error_message = "Output greeting_path should be the file's path."
  }
}
