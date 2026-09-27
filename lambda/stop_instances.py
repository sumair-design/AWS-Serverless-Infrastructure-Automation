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
            {"Name": "instance-state-name", "Values": ["running"]},
        ]
    )
    return [instance for reservation in response["Reservations"] for instance in reservation["Instances"]]


def lambda_handler(event, context):
    instances = _instances()
    ids = [instance["InstanceId"] for instance in instances]
    logger.info("Selected %d running instances: %s", len(ids), ids)

    if ids:
        ec2.stop_instances(InstanceIds=ids)
        logger.info("Stop request submitted for %s", ids)

    return {"action": "stop", "selected": len(ids), "instance_ids": ids}
