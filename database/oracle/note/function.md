# Oracle 系統架構
- Ref
	- https://wenku.baidu.com/view/c81389c105087632311212b1.html
- Overview
	- Oracle Server = Oracle Instance + Database
	- 溝通方式： User Process -> Server Process -> Oracle Server -> User Process
- Oracle Instance
    - System Global Area(SGA, 系統共同區)
		每當 Oracle 系統啟動時，會佔用主機一大塊資料庫專屬的記憶體空間來控制資訊與儲存資料，讓 Background Process 可以利用此資訊提供適當服務，處理外部 User Request。
        - Shared Pool：對 SQL 語法進行分析、編譯及執行的區域
	        - 查看大小：`SELECT * FROM v$sgastat GROUP BY pool;`
        - Database Buffer Cache：用來暫時存放最近讀取自資料庫裡面的資料，也就是資料檔(Datafile)內的資料，而資料檔是以資料區塊(Block)為單位，因此資料庫緩衝快取區裡面的大小是以 Block 為基數。
	        - Dirty Buffer：存放已修改但尚未寫入資料庫的資料
	        - Clean Buffer：
	        - Pinned Buffer：
	        - Free or Unused Buffer：
        - Redo Log Buffer
		- Large pool：針對大量資料而設計的大型記憶空間。
    - Background Process(背景處理程序)
		常駐的服務程序，執行 I/O Process 與非 Oracle Process 的監控管理
        - Database Writer(DBWn)：將 DB Buffer Cache 中的 Dirty Buffer 寫到 Data File 內，以避免 DB Buffer Cache 空間不足，視情況可以增加 Data File 數量增進效能。當 DB Buffer Cache 即將滿載或是執行 Checkpoint 時，才將資料寫入 Data File 中。
			- Least Recently Used(LRU)：當記憶空間滿載時，藉由該演算法，將不常用的資料寫回資料庫，釋放該記憶空間出來。
        - Log Writer：將已變動且已被 Commit 的資料記錄到 Redo Log File 內，重作日誌緩衝區裡面的記錄寫到 Redo Log File 裡。
            ![](https://docs.oracle.com/cd/B19306_01/server.102/b14231/img/admin056.gif)
        - System Monitor(SMON)
        - Process Monitor(PMON)
        - Checkpoint：更新 Database 的時機點，將結果寫入 Data Files、Redo Log Files 及 Control Files。
			- 查看 SCN：`SELECT current_scn FROM v$database`
        - Archiver
        - Recoverer
        - LOCK
- Oracle Database
    - 實體結構(Physical Database Structure)
		以**作業系統角度**去看 Oracle 資料庫所有檔案，因此資料庫中 SGA 所存的資料都只是暫時的，所有資料必須存於磁碟檔案中。由以下組成：
        - Redo Log Files(異動交易紀錄檔) - online
        - Control Files(控制檔)
			掌控 Oracle 實體結構所有資訊，新增、刪除、修改 Data Files 或 Redo Log Files。
			- 為了避免控制檔壞掉，實務上都會配置兩個 Control File，放在兩個不同硬碟，以 mirror 方式備援
        - Data Files(資料檔)
		- Password File
		- Parameter File
		- Archived Redo Log Files - offline
    - 邏輯結構(Logic Database Structure)
	以**資料庫觀點**去看 Oracle 資料庫的運作結構，並控制磁碟實體空間的使用。由以下組成：
        - 表空間(Tablespace)：一個資料庫劃分為一個或多個邏輯單位，該邏輯單位稱為表空間。
			```sql
			CREATE TABLESPACE <表空間名稱>  
			 DATAFILE <檔案名稱> SIZE <檔案大小>  
			 [ DEFAULT STORAGE <儲存格式> ]  
			 [ { ONLINE | OFFLINE } ]  
			/*  
			DATAFILE <檔案名稱>：為表空間在作業系統中的所儲存的檔案名稱。  
			DEFAULT STORAGE <儲存格式>：是用來設定儲存表空間的。  
			*/
		   ``` 
        - 段(Segment)、區段(Extent) 與資料區塊(Data Block)：            
            - 段：一個或多個區段(Extent)所組成，有五種類型的段：                
                - 資料段(Data Segments)                    
                - 叢集段(Cluster Segments)                    
                - 回復段(Rollback Segments)                    
                - 索引段(Index Segments)                    
                - 暫存段(Temporary Segments)                    
            - 區段：連續的資料區塊(Data Block)所組成                
            - 資料區塊：使用 I/O 的最小單位
- 處理單元(Process)
    - User Process：當使用者的應用程式欲以 SQL 指令存取資料庫資料時，例如：Pro*C程式、Oracle Tools、SQL*plus、Oracle Form 等等，Oracle 會產生 User Process去執行這些工作。
    - Oracle Process：Oracle Process 依執行的方式不同可大概分為 Server Process 與 Background Process 兩種：
        - Server Process
        - Background Process
            - 範例：假設我們下 DML 指令 (UPDATE EMP SET SAL = SAL * 1.05 WHERE EMPNO = 7788)，其步驟如下：
                1.  User Process 將 DML 指令送給 Server Process。
                1.  確認 Database Buffer Cache 有沒有資料
                    - 有，則直接執行 DML 指令，也就是執行 UPDATE 指令。
                    - 沒有，則 Server Process 會從 Data files 中將資料與 Rollback blocks 讀入 Database Buffer Cache 中。
                1.  將從 Data files 讀入的資料複製一份到 Database Buffer Cache 中。
                1.  對 Database Buffer Cache 中的資料做鎖定(Lock)的動作，並且執行 DML 指令，也就是執行 UPDATE 指令。
                1.  Server Process 將未變動前的資料記錄與變動後的資料記錄放入 Redo Log Buffer 中。並且將執行過的 SQL 指令放入 Shared pools 的 Library cache 中。
                1.  Server Process 將未變動前的資料記錄放入 Database Buffer Cache 中的 Rollback blocks。並將變動後的資料記錄放入 Database Buffer Cache 中 Data blocks 中。這些 Rollback blocks 與 Data blocks 都會被註記為 Database Buffer Cache 中的 Dirty buffers，也就是這些 blocks 與硬碟中的 Data files 中 Data blocks 與 Rollback blocks 並不一致。
                ![](file:///Users/fool/Documents/github/gitbook/file/img/oracle/Oracle%E8%99%95%E7%90%86%E6%B5%81%E7%A8%8B.png?lastModify=1582644409)
- 系統檔案(Files)    
- 物理結構    
- 邏輯結構    
- 內存分配    
- 後台進程    
- Oracle 例程    
- 系統改變號
### Oracle 自動儲存管理 Automatic Storage Management
自動儲存管理(ASM)是 Oracle Database 的一個特性，它為資料庫管理員提供了一個在所有伺服器和儲存平臺上均一致的簡單儲存管理介面。作為專門為 Oracle 資料庫檔案建立的垂直整合檔案系統和卷管理器，ASM 提供了直接非同步 I/O 的效能以及檔案系統的易管理性。ASM 提供了可節省 DBA 時間的功能，以及管理動態資料庫環境的靈活性，並且提高了效率。ASM 的主要優點有：
- 簡化和自動化了儲存管理    
- 提高了儲存利用率和敏捷性    
- 提供可預測的效能、可用性和可伸縮性