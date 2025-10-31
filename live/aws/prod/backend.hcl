locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  aws_region = local.region_vars.locals.aws_region

  moduleFolder    = path_relative_to_include()
  environment_with_dashes = replace(local.env_vars.locals.environment, ".", "-")
}

remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    encrypt = true
    bucket = "${local.environment_with_dashes}-remote-state"
    key    = "${local.moduleFolder}/terraform.tfstate"
    region = local.aws_region
    dynamodb_table = "${local.environment_with_dashes}-terraform-locks"
    s3_bucket_tags = {
      "managed_by" = "Terraform"
      "managed_by_module" = "${local.moduleFolder}"
    }
    dynamodb_table_tags = {
      "managed_by" = "Terraform"
      "managed_by_module" = "${local.moduleFolder}"
    }
  }
}

