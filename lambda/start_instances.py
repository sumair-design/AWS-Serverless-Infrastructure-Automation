import logging
import os
from typing import Any

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)
ec2 = boto3.client("ec2")


def _instances() -> list[dict[str, Any]]:
    key = os.environ["TAG_KEY"]
    value = os.environ["TAG_VALUE"]
    response = ec2.describe_instances(
        Filters=[
            {"Name": f"tag:{key}", "Values": [value]},
            {"Name": "instance-state-name", "Values": ["stopped"]},
        ]
    )
    return [instance for reservation in response["Reservations"] for instance in reservation["Instances"]]


def lambda_handler(event, context):
    instances = _instances()
    ids = [instance["InstanceId"] for instance in instances]
    logger.info("Selected %d stopped instances: %s", len(ids), ids)

    if ids:
        ec2.start_instances(InstanceIds=ids)
        logger.info("Start request submitted for %s", ids)

    return {"action": "start", "selected": len(ids), "instance_ids": ids}
