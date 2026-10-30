# Spec for exercise 02. Run with: make check EX=02_variables_outputs

variables {
  project = "gol-lab"
  owner   = "platform-team"
}

run "defaults_build_names_and_tags" {
  command = plan

  assert {
    condition     = output.name_prefix == "gol-lab-dev"
    error_message = "name_prefix should be <project>-<environment>, with environment defaulting to dev."
  }

  assert {
    condition = output.bucket_names == {
      landing   = "gol-lab-dev-landing"
      processed = "gol-lab-dev-processed"
    }
    error_message = "bucket_names should map each suffix to <name_prefix>-<suffix>."
  }

  assert {
    condition = output.tags == {
      Project     = "gol-lab"
      Environment = "dev"
      Owner       = "platform-team"
    }
    error_message = "tags should be exactly Project, Environment and Owner when extra_tags is empty."
  }
}

run "extra_tags_cannot_override_required_tags" {
  command = plan

  variables {
    environment = "prod"
    extra_tags = {
      CostCentre  = "lab"
      Environment = "sneaky"
    }
  }

  assert {
    condition     = output.tags["Environment"] == "prod"
    error_message = "Required tags must win over extra_tags (think about merge order)."
  }

  assert {
    condition     = output.tags["CostCentre"] == "lab"
    error_message = "Extra tags should be added."
  }
}

run "rejects_unknown_environment" {
  command = plan

  variables {
    environment = "qa"
  }

  expect_failures = [var.environment]
}

run "rejects_bad_project_name" {
  command = plan

  variables {
    project = "Not_Valid"
  }

  expect_failures = [var.project]
}
