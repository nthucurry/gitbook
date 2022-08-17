# App Service 設定
- Configuration
    - Application settings
        - WEBSITE_DNS_SERVER: **168.63.129.16**
        - WEBSITE_PULL_IMAGE_OVER_VNET: **true**

# Container Registry 設定
- Networking
    - Public network access: **Selected networks**
    - Firewall: **白名單 Public IP**

# Successful Log
```
2022-08-16T12:45:32.043Z INFO  - Pulling image: mcr.microsoft.com/appsvc/middleware:stage5
2022-08-16T12:45:32.378Z INFO  - stage5 Pulling from appsvc/middleware
2022-08-16T12:45:32.379Z INFO  - Digest: sha256:f2a0c60712a928834c3dcc13c3f76f99bec497001417c303fed69c0a2a1bdac1
2022-08-16T12:45:32.381Z INFO  - Status: Image is up to date for mcr.microsoft.com/appsvc/middleware:stage5
2022-08-16T12:45:32.384Z INFO  - Pull Image successful, Time taken: 0 Minutes and 0 Seconds
2022-08-16T12:45:32.469Z INFO  - Starting container for site
2022-08-16T12:45:32.470Z INFO  - docker run -d --expose=8181 --expose=8082 --name adt-sala_1_3c69673d_middleware -e WEBSITE_CORS_ALLOWED_ORIGINS=* -e WEBSITE_CORS_SUPPORT_CREDENTIALS=False -e WEBSITES_ENABLE_APP_SERVICE_STORAGE=false -e WEBSITE_SITE_NAME=adt-sala -e WEBSITE_AUTH_ENABLED=False -e PORT=8181 -e WEBSITE_ROLE_INSTANCE_ID=0 -e WEBSITE_HOSTNAME=adt-sala.azurewebsites.net -e WEBSITE_INSTANCE_ID=33c7196c0e2022-08-16T12:45:37.776Z INFO  - Initiating warmup request to container adt-sala_1_3c69673d for site adt-sala
2022-08-16T12:45:53.681Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 15.9050064 sec
2022-08-16T12:46:08.819Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 31.0427575 sec
2022-08-16T12:46:23.990Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 46.2139949 sec
2022-08-16T12:46:39.130Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 61.3536435 sec
2022-08-16T12:46:54.313Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 76.5373202 sec
2022-08-16T12:47:09.412Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 91.6355156 sec
2022-08-16T12:47:24.519Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 106.7432141 sec
2022-08-16T12:47:39.672Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 121.896426 sec
2022-08-16T12:47:54.783Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 137.0067839 sec
2022-08-16T12:48:09.890Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 152.1137216 sec
2022-08-16T12:48:25.006Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 167.2296727 sec
2022-08-16T12:48:43.491Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 185.7144687 sec
2022-08-16T12:48:58.594Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 200.8182032 sec
2022-08-16T12:49:13.745Z INFO  - Waiting for response to warmup request for container adt-sala_1_3c69673d. Elapsed time = 215.9688205 sec
2022-08-16T12:49:27.967Z ERROR - Container adt-sala_1_3c69673d for site adt-sala did not start within expected time limit. Elapsed time = 230.1907723 sec
2022-08-16T12:49:27.968Z INFO  - Initiating warmup request to container adt-sala_1_3c69673d_middleware for site adt-sala
2022-08-16T12:49:28.492Z INFO  - Container adt-sala_1_3c69673d_middleware for site adt-sala initialized successfully and is ready to serve requests.
```