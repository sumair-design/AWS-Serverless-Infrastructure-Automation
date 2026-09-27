# Deployment

## Prerequisites

- AWS CLI authenticated with a deployment identity.
- Terraform >= 1.6.
- Python 3.12 for local validation.

Do not put access keys, secret keys, account IDs, or personal credentials in the repository.

## 1. Configure Terraform

Copy the example variables file:

    cp terraform/terraform.tfvars.example terraform/terraform.tfvars

Review the schedules before deployment. EventBridge cron expressions are UTC.

## 2. Initialize and validate

    cd terraform
    terraform init
    terraform fmt -check
    terraform validate
    terraform plan

Review the plan carefully.

## 3. Apply

    terraform apply

## 4. Tag test EC2 instances

Only instances matching the configured opt-in tag are controlled. Example:

    AutoSchedule=true

The Lambda functions do not contain hard-coded instance IDs.

## 5. Test manually

Use the AWS Lambda console to invoke the start and stop functions with `{}`. Inspect CloudWatch logs after each invocation.

## 6. Test schedules

EventBridge invokes each Lambda according to the configured UTC schedule. For a safe lab test, temporarily use a near-future schedule, validate the result, then restore the desired schedule.

## 7. Destroy lab resources

    terraform destroy

Do not destroy resources outside this project that were not created by Terraform.
