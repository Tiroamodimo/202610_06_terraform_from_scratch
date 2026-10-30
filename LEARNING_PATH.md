CONFIDENTIALITY: INTERNAL
STATUS: DRAFT - UNREVIEWED

# Learning Path: Terraform from Scratch

**Goal:** be able to read, write, test and safely run Terraform on AWS on your own. That is the skill `gol_mig_lab` (Phase 3 onwards) and the GOL day job (`202610_02_phantom_devops`) assume.
**Pace:** about 6 hrs/week, 10 phases, roughly 10–11 weeks. The Terraform Associate exam is optional at the end.
**Tooling:** Terraform 1.14 (installed). For AWS, use the sandbox kit (`../202610_05_aws_sandbox_kit`): `TARGET=local` is LocalStack (free) and `TARGET=sandbox` is a short-lived AWS account.

## Courses

| Code | Course | Size | Used for |
|---|---|---|---|
| **A** | *[New] Terraform on AWS for Beginners: Real-World Project* (Udemy, TechLab Guru) | 10 sections, ~3 h | **Start here.** Fundamentals, phases 0–2 |
| **B** | *Terraform on AWS with SRE & IaC DevOps \| Real-World 20 Demos* (Udemy, Kalyan Reddy Daida / stacksimplify) | 22 demos, ~21 h | After A. Skim demos 01–05 as revision, then real AWS architecture, phases 3–9 |

Course B's demo code is public at `github.com/stacksimplify/terraform-on-aws-ec2`, with folders `01-…` to `22-…`. Watch or read along, but **do the exercises here**: they're the same demos reshaped to run on LocalStack, the sandbox kit and a `terraform test` spec. Don't copy course code into this repo.

### Keeping course B up to date (it was recorded on older versions)

| Course does | Do this instead (and why) |
|---|---|
| Pins old AWS provider versions | `hashicorp/aws ~> 5.100`. This is the newest version LocalStack can run (see the sandbox kit README). |
| Remote state locking with a DynamoDB table (demo 20) | Learn it, then use the S3 backend's `use_lockfile = true`. DynamoDB locking is deprecated since Terraform 1.11. |
| Launch configurations (demo 14, marked deprecated) | Skip it. Use launch templates (demo 15). |
| EC2 key pairs and SSH through a bastion | SSM Session Manager, with no keys. This is how the GOL case study does it. |
| A registered Route53 domain plus ACM for HTTPS (demos 12–13) | Sandbox accounts have no domain. Use a private hosted zone and HTTP, or a self-signed certificate imported into ACM. Treat the public domain steps as read-only. |
| A NAT gateway per AZ, and RDS | Sandbox only, with `single_nat_gateway = true`. Destroy at the end of every session, because these cost money hourly. |
| CodePipeline for IaC DevOps (demo 22) | Do it in the sandbox. Also compare it with the Jenkins pipeline in `gol_lab`, which is what GOL uses. |

## How it works

Each phase is **watch → exercise → checkpoint**. Every exercise in `exercises/NN_*` has:
- `README.md`: the brief, the course sections it matches, what to predict before running anything, and when it counts as done.
- `main.tf`: a starter file you complete.
- `tests/*.tftest.hcl`: the spec. **Done means `make check EX=NN_name` is green** (fmt, validate and `terraform test`). AWS specs use `mock_provider`, so they need no cloud.
- For AWS exercises, you can also run them by hand: `make plan|apply|destroy EX=NN_name TARGET=local|sandbox`.

The rule: **predict, then run.** Before each `plan`, write down what you expect it to show.

Exercises 01–03 are ready. The rest are written when you reach them (ask Claude), so they can build on your earlier code.

---

## Phase 0: Mental model and first config (week 1). No cloud.
**Watch:** A §1–4: IaC intro, configuration files, important commands, inspecting state.

**Exercise:** `01_first_config` uses the `random` and `local` providers.

**Checkpoint:** explain why a second `apply` changes nothing, and what deleting the state file would do.

## Phase 1: Variables, outputs, conditionals (week 2). No cloud.
**Watch:** A §5 (the variables half), §9 outputs, §10 conditional expressions.

**Exercise:** `02_variables_outputs`: naming and tagging logic with validation.

**Checkpoint:** a bad `environment` is rejected at plan time with your message.

## Phase 2: Meta-arguments, dependencies, dynamic blocks, data sources (week 3). LocalStack.
**Watch:** A §5 (`count` and `for_each`), §6 dependencies, §7 dynamic blocks, §8 data sources.

**You've now finished course A.**

**Exercise:** `03_meta_arguments`: EC2 instances with `for_each`, a security group with a dynamic `ingress` block, AMI and AZ lookups, and a conditional instance type.

**Checkpoint:** you predicted correctly what removing a name from the middle does with `count` versus `for_each`.

## Phase 3: State, remote state and refactoring (week 4). LocalStack.
**Starting course B:** skim B 01–05 at speed as revision of course A. Note anything new, such as the splat operator and `aws_ec2_instance_type_offerings` loops.
**Watch:** B 20 (remote state in S3 + DynamoDB), B 21 (the `terraform_remote_state` data source). B covers these out of course order; it's fine to jump ahead.

**Exercise `04_state`:**
- Move the `03` stack to an S3 backend on LocalStack with `use_lockfile`.
- Read one stack's outputs from another with `terraform_remote_state`.
- Use `moved` blocks to rename without destroying, and `import` a bucket you made by hand.
- Detect drift with `plan -refresh-only`.

**Checkpoint:** a refactor whose plan shows `0 to add, 0 to destroy`.

## Phase 4: VPC, EC2 and security groups (week 5). LocalStack, then the sandbox.
**Watch:** B 06 (AWS VPC with the `terraform-aws-modules/vpc` module), B 07 (EC2 and security groups, bastion).

**Exercise `05_vpc_ec2`:**
- A three-tier VPC (public, private and database subnets) from the registry module, with a single NAT gateway.
- Private EC2 instances reachable through SSM, with no bastion and no key pairs.
- Security groups that only accept traffic from the tier in front.

**Checkpoint:** you can draw the route tables, and say which subnet reaches the internet and how.

## Phase 5: Load balancers and routing (weeks 6–7). Sandbox.
**Watch:**
- B 08: classic load balancer (skim).
- B 09–12: ALB basics, path-based routing, host-header routing, HTTP header and query-string routing, redirects.
- B 16: NLB.

**Exercise `06_load_balancing`:** an ALB in front of two target groups, with listener rules for path, host and header routing and an HTTP→HTTPS redirect (self-signed certificate). Add an NLB variant.

**Checkpoint:** a `curl` script proves every routing rule. Everything is destroyed afterwards.

## Phase 6: DNS to database (week 7). Sandbox.
**Watch:** B 13 (DNS to DB: Route53, ACM, RDS).

**Exercise `07_dns_to_db`:** a private hosted zone with records pointing at the ALB, plus RDS (PostgreSQL, `db.t4g.micro`, single-AZ) in the database subnets. The password comes from `random_password` and is stored in Secrets Manager, never in a variable file. The app instances read it at boot.

**Checkpoint:** no secret appears in the code or in plan output. Can you find it in the state file? (Yes. Discuss what that means.)

## Phase 7: Auto Scaling and CloudWatch (week 8). Sandbox.
**Watch:** B 15 (Auto Scaling with launch templates), B 17 (CloudWatch). Skip B 14.

**Exercise `08_asg_cloudwatch`:**
- An ASG from a launch template behind the ALB, with a target-tracking scaling policy and an instance refresh on template changes.
- CloudWatch alarms on ALB 5xx errors and unhealthy hosts, sent to SNS, plus a synthetics canary (optional, because of cost).

**Checkpoint:** changing the AMI rolls the ASG with no downtime, as watched through the canary or a curl loop.

## Phase 8: Modules and testing (week 9). Mock provider, LocalStack.
**Watch:** B 18 (developing modules locally), B 19 (a module from scratch). Revisit A's "modularising" lectures if they helped.

**Exercise `09_modules_testing`:**
- Turn the network and web tier from `05`–`08` into local modules, each with its own README, `variables.tf`, `outputs.tf` and `terraform test` suite (mock provider).
- Add `check` blocks and pre/postconditions.
- Get `tflint` and `trivy config` clean.

**Checkpoint:** `make check` runs tests, lint and scanning across all modules, and it is green.

## Phase 9: IaC DevOps pipeline (week 10). Sandbox.
**Watch:** B 22 (IaC DevOps with AWS CodePipeline).

**Exercise `10_pipeline`:**
- A CodePipeline with CodeBuild: plan → manual approval → apply for dev, then stage, using the `09` modules.
- The plan-file workflow (`plan -out`, then `apply planfile`).
- Write a one-page comparison with the Jenkins flow in `gol_lab`.

**Checkpoint:** a merge to `main` deploys through the pipeline with an approval gate. Everything is destroyed afterwards.

## Optional: Terraform Associate (week 11)
Check the current exam version and objectives on the HashiCorp certification page before booking. Fill any gaps, for example HCP Terraform / Terraform Cloud workspaces, then do two timed practice exams.

## Where it leads
- `202610_04_gol_aws_migration`: Phase 3 (landing zone modules), 6 (environments from snapshots) and 7 (CloudFront, WAF, Config).
- `202610_02_phantom_devops`: its Terraform demo (provider upgrades, drift detection, tagging compliance).

## References
- Terraform docs and tutorials: https://developer.hashicorp.com/terraform
- `terraform test` and mocks: https://developer.hashicorp.com/terraform/language/tests
- AWS provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Course B code: https://github.com/stacksimplify/terraform-on-aws-ec2
