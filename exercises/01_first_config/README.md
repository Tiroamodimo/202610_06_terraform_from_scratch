# 01: First config (Phase 0)

**Course match:** A §1–4 (IaC intro, configuration files, important commands, inspecting state).

No cloud needed. You'll use two providers that act only on your machine:
- `random` makes random values that stay stable once they're in state.
- `local` writes files.

## Brief

Complete `main.tf` so that it:
1. Declares both providers in `required_providers`, pinned to a major version (`hashicorp/random ~> 3.6`, `hashicorp/local ~> 2.5`).
2. Creates a `random_pet` named `name`, with 2 words joined by `-`.
3. Creates a `local_file` named `greeting`. It should write `Hello from <pet name>!` to `${path.module}/out/greeting.txt`.
4. Has an output `pet_name` (the pet name) and an output `greeting_path` (the file path).

## Predict, then run

Write each prediction in your log before running the command.

```bash
cd exercises/01_first_config
terraform init       # What is downloaded, and where? Which new file appears next to main.tf, and why commit it?
terraform plan       # How many resources? Which values show "(known after apply)", and why?
terraform apply      # Then: cat out/greeting.txt and terraform output
terraform apply      # Second time: what does the plan say? Why?
terraform state list
terraform state show random_pet.name
cat terraform.tfstate | head -40   # What is in here that should never be committed?
rm out/greeting.txt && terraform plan   # Predict before running: what will Terraform want to do?
terraform destroy
```

Bonus: change `length` to 3 and plan. Is it an update in place or a replace (`-/+`)? Why does this resource have to be replaced?

## Done when

- `make check EX=01_first_config` is green (run it from the repository folder).
- You can answer the Phase 0 checkpoint in `PROGRESS.md`: why a second `apply` changes nothing, and what would happen if you deleted the state file.
