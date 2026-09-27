# Cost Optimization

The automation is designed for non-production EC2 workloads that do not need to run continuously.

## Mechanism

1. Engineers opt an instance into automation with `AutoSchedule=true`.
2. EventBridge triggers the start Lambda at the configured start time.
3. The stop Lambda stops tagged running instances at the configured stop time.
4. CloudWatch logs provide an operational audit trail.

The actual savings depend on instance type, runtime window, storage, and other AWS charges. Do not claim a fixed percentage reduction without measuring the workload before and after automation.

For production, consider exclusions for stateful workloads, maintenance windows, dependency-aware shutdowns, and additional approval controls.
