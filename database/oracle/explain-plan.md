# 檢視執行計畫
```bash
explain plan for select 1 from t
```

# 執行順序
- 根據縮排判斷，縮排最多的最先執行
- 縮排相同時，最上面的是最先執行的

# 訪問資料的方法
## table access full
- HWL 越高，掃描越久，I/O 越高

## table access by rowid
## index unique scan

# Referecne
- [Oracle Select SQL Tuning 查詢效能調整](https://tomkuo139.blogspot.com/2009/08/oracle-select-sql-tuning.html)
- [Oracle 調優之看懂 Oracle 執行計劃](https://iter01.com/511880.html)
- [Oracle Database 使用 Advisor 了解 SQL Tuning 方向](https://tomkuo139.blogspot.com/2010/03/oracle-database-advisor-sql-tuning.html)