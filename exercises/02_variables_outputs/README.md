# 02: Variables, locals and outputs (Phase 1)

**Course match:** A §5 (the variables half), §9 (outputs), §10 (conditional expressions).

Still no cloud. You'll build the naming and tagging logic that every real stack needs. Later, in `05`, you'll put the same logic onto AWS resources.

## Brief

In `variables.tf`, declare:
- `project` (string, no default). It must be 3–20 characters of lowercase letters, digits or `-`. Use a `validation` block with `can(regex(...))`.
- `environment` (string, default `"dev"`). It must be one of `dev`, `test` or `prod`, and the error message must list the allowed values.
- `owner` (string, no default).
- `extra_tags` (`map(string)`, default `{}`).
- `bucket_suffixes` (`list(string)`, default `["landing", "processed"]`).

In `main.tf`, define these locals:
- `name_prefix` = `"<project>-<environment>"`.
- `tags` = `Project`, `Environment` and `Owner`, merged with `extra_tags`. **The required tags must win**, so `extra_tags` can't override them.
- `bucket_names` = a **map** from each suffix to `"<name_prefix>-<suffix>"`, built with a `for` expression.

In `outputs.tf`, output `name_prefix`, `tags` and `bucket_names`.

Then write `dev.tfvars` with your own values.

## Predict, then run

```bash
cd exercises/02_variables_outputs
terraform init
terraform console                  # try: upper("x"), merge({a=1},{a=2}), [for s in ["a","b"] : "${s}!"], { for s in ["a","b"] : s => length(s) }
terraform plan -var-file=dev.tfvars
terraform plan -var-file=dev.tfvars -var environment=qa       # predict the error
TF_VAR_owner=someone terraform plan -var-file=dev.tfvars      # which value wins, the env var or the tfvars file? Why?
terraform plan -var project=demo   # predict: what does Terraform do about the missing owner?
```

Question for your log: with `merge(a, b)`, which map wins when both have the same key? How did that decide the order you used for `tags`?

## Done when

- `make check EX=02_variables_outputs` is green.
- A bad `environment` and a bad `project` are both rejected at plan time with your own messages.
