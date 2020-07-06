# Troubleshooting
## Block sessions
1. user 的 sql GG，執行後 hand 住
    ![](../../../img/oracle/troubleshooting/block-session-cause-reason.png)
2. 進 OEM 看 top activity，看到紅紅的就不對勁，發現是這個 sql(86nyv6myq09p2)
    ![](../../../img/oracle/troubleshooting/block-session-top-activity.png)
3. 進去找原因，看到 update 指令，馬上聯想到 block session
    ![](../../../img/oracle/troubleshooting/block-session-find-sql.png)
4. 進 block session 看看
    ![](../../../img/oracle/troubleshooting/block-session.png)
5. 找到作案手法了
    ![](../../../img/oracle/troubleshooting/block-session-info.png)
6. 身家調查 session 看看
    - 兇手
        ![](../../../img/oracle/troubleshooting/block-session-block-source.png)
    - 被害者
        ![](../../../img/oracle/troubleshooting/block-session-block-target.png)
7. 只好 kill block session