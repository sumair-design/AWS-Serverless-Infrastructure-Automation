# Troubleshooting

## Lambda reports AccessDenied

Check the Lambda execution role and verify the policy contains the required EC2 and CloudWatch Logs actions. Confirm the EC2 resource tag key/value matches the Terraform variables.

## Lambda runs but selects zero instances

Check the instance tags and current instance state. The start function searches for `stopped` instances; the stop function searches for `running` instances.

## EventBridge is not invoking Lambda

Check:

    aws events list-rules
    aws events list-targets-by-rule --rule NAME

Verify the Lambda permission resource exists and the EventBridge rule is enabled.

## Lambda has no useful logs

Check the corresponding `/aws/lambda/<function-name>` log group. Terraform creates the log group with 14-day retention.

## Terraform packaging error

Run:

    terraform init
    terraform validate

The project uses the HashiCorp archive provider to create Lambda ZIP packages during Terraform evaluation.
