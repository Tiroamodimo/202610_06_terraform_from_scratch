# CLAUDE.md

Guidance for Claude Code in this subproject.

## What this is

A from-scratch Terraform learning path. `LEARNING_PATH.md` lists the phases, and `PROGRESS.md` shows where the user is. It follows two Udemy courses: **A**, *[New] Terraform on AWS for Beginners* (the user starts here, phases 0–2), then **B**, *Terraform on AWS with SRE & IaC DevOps* (22 demos, phases 3–9). The courses are what the user watches; the exercises here are course-style demos with specs. Never copy course code (`stacksimplify/terraform-on-aws-ec2`) into this repo. The exercises are in `exercises/NN_*`. Each one has a brief (`README.md`), a starter `main.tf`, and a spec in `tests/*.tftest.hcl`.

## How to help

- **This is a learning project: don't solve the exercises** unless the user asks for the answer. Prefer hints, questions and pointers to docs. When the user asks for a review, review their code against the brief.
- Never weaken or delete a spec test to make it pass. Adding tests is fine.
- New exercises follow the same shape: a brief with predictions and "done when", a starter file with TODOs, and failing tests.

## Commands (from this folder)

- `make check EX=01_first_config` runs `init`, `fmt -check`, `validate` and `terraform test` for one exercise.
- `make clean EX=…` removes `.terraform`, state and generated output for that exercise.
- AWS exercises (`03` onwards): the spec uses `mock_provider` (no cloud). Hands-on runs go through the sandbox kit: `make plan|apply|destroy EX=… TARGET=local` (LocalStack, after `make localstack-up`) or `TARGET=sandbox` (a real AWS account: ask before any apply, and never use the client AWS profiles on this machine).
- New exercises 04–10 are written when the user reaches them (see `LEARNING_PATH.md`). Verify each spec against a scratch solution outside the repo before handing it over.
