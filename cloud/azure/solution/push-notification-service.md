# 目的
對外網頁服務網站回應需在 5 秒內，確保服務水準

# 架構
使用 Application Insights 的 Availability Test 監控，透過多個不同地理區域，偵測網站回應時間，並將不合規的結果透過 Line 發送推播

# 步驟
1. Application Insights
    - Availability ➡ Availability Test
    - Create Standard (preview) test
        - Test frequency
        - Test locations
        - Succuess criteria
            - Test timeout
                - 預設最小 30 秒
                - 去 https://resources.azure.com/ 改成以下參數 "Timeout": 2 (秒)
    - Open Rules (Alerts) page
        - Actions
            - URI: `https://prod-07.southeastasia.logic.azure.com:443/workflows/XXX/triggers/manual/paths/...XXX`
            <br><img src="../../../img/cloud/azure/logic-call-api-4.png">
2. Line token
    - https://notify-bot.line.me/my/
3. Logic App
    - When a HTTP request is received
        <br><img src="../../../img/cloud/azure/logic-request.png">
        <br><img src="../../../img/cloud/azure/logic-call-api-1.png">
    - Visualize Analytics query
        - Application Insights ➡ API Access ➡ Create API key
            - 取得 `API Key` 與 `Application Id`
            - API key description: `監控 DMZ Web 回應狀態`
            - Read telemetry: `打勾`
            <br><img src="../../../img/cloud/azure/logic-call-api-5.png">
            <br><img src="../../../img/cloud/azure/logic-call-api-2.png">
    - HTTP
        - Method: `POST`
        - URI: `https://notify-api.line.me/api/notify?message=顯示的訊息`
        - Header
            - Authorization: `Bearer <Line Token>`
            - Content-Type: `application/x-www-form-urlencoded`
    - 整體流程
        <br><img src="../../../img/cloud/azure/logic-call-api-3.png">
    - 結果
        <br><img src="../../../img/cloud/azure/logic-call-api-6.png">