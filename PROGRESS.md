CONFIDENTIALITY: INTERNAL
STATUS: DRAFT - UNREVIEWED

# Progress

Start date: 2026-10-30 · Target pace: ~6 hrs/week

## Checklist

- [ ] **Phase 0:** `01_first_config` is green, and the checkpoint is answered in the log
- [ ] **Phase 1:** `02_variables_outputs` is green, including the validation failure test
- [ ] **Phase 2:** `03_meta_arguments` is green; the four experiments are answered. **Course A complete.**
- [ ] **Phase 3:** `04_state` is green (S3 backend, remote state, moved/import, drift); B 01–05 skimmed
- [ ] **Phase 4:** `05_vpc_ec2` is green on LocalStack and applied in a sandbox (B 06–07)
- [ ] **Phase 5:** `06_load_balancing`: every ALB/NLB rule proven with curl (B 08–12, 16)
- [ ] **Phase 6:** `07_dns_to_db`: no secret in the code or plan (B 13)
- [ ] **Phase 7:** `08_asg_cloudwatch`: AMI change rolls with no downtime (B 15, 17)
- [ ] **Phase 8:** `09_modules_testing`: tests, lint and scanning green (B 18–19)
- [ ] **Phase 9:** `10_pipeline`: deploys through an approval gate (B 22)
- [ ] **Optional:** Terraform Associate booked or passed

## Courses
- [ ] A: *[New] Terraform on AWS for Beginners: Real-World Project* (started 2026-10-30)
- [ ] B: *Terraform on AWS with SRE & IaC DevOps | Real-World 20 Demos*

## Log

| Date | Phase | Notes (what surprised you, what you predicted wrong) |
|---|---|---|
| 2026-10-30 | 0 | Folder set up, with exercises 01–03 ready and courses A and B mapped to the phases |
