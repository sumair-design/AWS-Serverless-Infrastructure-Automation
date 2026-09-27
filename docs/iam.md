# IAM Design

The Lambda execution role uses a trust policy for the Lambda service and an inline permissions policy.

Required EC2 operations:

- `ec2:DescribeInstances`
- `ec2:StartInstances`
- `ec2:StopInstances`

CloudWatch logging permissions:

- `logs:CreateLogStream`
- `logs:PutLogEvents`

Start/stop permissions are conditioned on the configured EC2 resource tag. This prevents the Lambda from intentionally operating on instances that are not opted into the automation.

EventBridge gets only Lambda invocation permission for the two specific functions through `aws_lambda_permission`.

For production, use a dedicated deployment identity and remote Terraform state with locking rather than local state.
