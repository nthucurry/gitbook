# Reorganization
- Move down the HWM
- Releases unused extents

# Step
1. Reorganization
    - `alter table hr.big1 move;`
        - index, M-View 會失效
    - `alter table hr.big1 shrink space;`
2. Rebuild Index
    - `alter index idx_hr rebuild online;`