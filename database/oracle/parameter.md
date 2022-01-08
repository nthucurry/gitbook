# Parameter
## Job
- job_queue_processes

## RAM
- sga_target: 指定 SGA 大小
    - sga_target=8G (autotuning)
    - sga_target=0
- pga_aggregate_target: 指定 PGA 大小
    - pga = sga * 20%
    - pga_aggregate_target=8G (autotuning)