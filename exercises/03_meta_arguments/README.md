# 03: Meta-arguments, dependencies, dynamic blocks, data sources (Phase 2)

**Course match:** A §5 (`count` / `for_each`), §6 (dependencies), §7 (dynamic blocks), §8 (data sources), §10 (conditionals). Later revision: B 04–05.

This is the first exercise with AWS. The spec uses Terraform's **mock AWS provider**, so `make check` needs no cloud and no credentials. For hands-on runs, use LocalStack (`TARGET=local`), which emulates EC2. Nothing real is created.

## Brief

Complete `main.tf`:

1. **Variables:**
   - `environment` (default `"dev"`)
   - `instance_names` (`set(string)`, default `["web", "api"]`)
   - `allowed_ports` (`list(number)`, default `[80, 443]`)
   - `ami_name_pattern` (default `"al2023-ami-2023.*-x86_64"`)
2. **Data sources:**
   - `data "aws_ami" "base"`: the most recent Amazon-owned image whose `name` matches `ami_name_pattern`.
   - `data "aws_availability_zones" "available"`: zones whose state is `available`.
3. **`aws_security_group.web`:**
   - `name_prefix = "<environment>-web-"`.
   - A **dynamic `ingress` block**: one TCP rule per entry in `allowed_ports`, from `0.0.0.0/0`.
   - One egress rule allowing everything.
4. **`aws_instance.app`, with `for_each` over `instance_names`:**
   - Uses the AMI from the data source.
   - Placed in the first available AZ.
   - Attached to the security group.
   - Tagged `Name = "<environment>-<name>"`.
   - `instance_type` is `t3.small` when `environment` is `prod`, otherwise `t3.micro`. Use a **conditional expression**, not a variable.
5. **Outputs:**
   - `ami_id`.
   - `instance_ids`: a **map** of name → instance ID, built with a `for` expression.

## Predict, then run

Run these from the repository folder:
```bash
make check EX=03_meta_arguments             # the spec (mock provider, no cloud)
make plan  EX=03_meta_arguments             # TARGET=local by default: starts nothing, needs `make localstack-up` first
make apply EX=03_meta_arguments
terraform -chdir=exercises/03_meta_arguments graph | head -30   # which edges did Terraform infer? Did you write any depends_on?
```

Experiments (write your prediction in the log first):
1. Switch `for_each` to `count = length(var.instance_names)` with a **list** `["web", "api", "batch"]`, then apply. Remove `"api"` and plan. What happens to `batch`? Now do the same with `for_each`. Why is `for_each` safer?
2. Add port `22` to `allowed_ports` and plan. Is it an update in place or a replace? Why does the AWS provider treat inline rules that way? (Look up `aws_vpc_security_group_ingress_rule`.)
3. Add `depends_on = [aws_security_group.web]` to the instance. Does the plan change? When is an explicit `depends_on` actually needed?
4. Use a splat: `values(aws_instance.app)[*].id`. Why doesn't `aws_instance.app[*].id` work with `for_each`?

Finish with `make destroy EX=03_meta_arguments`.

## Done when

- `make check EX=03_meta_arguments` is green.
- The four experiment answers are in your `PROGRESS.md` log.
