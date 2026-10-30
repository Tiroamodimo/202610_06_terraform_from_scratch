CONFIDENTIALITY: INTERNAL
STATUS: DRAFT - UNREVIEWED

# terraform_from_scratch

A hands-on Terraform learning path: see `LEARNING_PATH.md`, and track it in `PROGRESS.md`.

```bash
make list                          # exercises
make check EX=01_first_config      # the spec for one exercise: fmt, validate, terraform test
terraform -chdir=exercises/01_first_config plan    # explore by hand as well
```

It follows course A (*Terraform on AWS for Beginners*), then course B (*Terraform on AWS with SRE & IaC DevOps*). See `LEARNING_PATH.md` for which sections go with which exercise.

Exercises 01–02 need no cloud. From 03 onwards, the specs use a mocked AWS provider, and hands-on runs use the shared sandbox kit (`../202610_05_aws_sandbox_kit`): `make plan EX=… TARGET=local` for LocalStack, `TARGET=sandbox` for a short-lived AWS account.
