# 參數
- 設定
    1. HTTPS 連線
    2. request files without extension
- `vi /etc/nginx/nginx.conf`
    ```
    server {
      listen       443 ssl http2;
      listen       [::]:443 ssl http2;
      server_name  _;
      root         /usr/share/nginx/html;

      ssl_certificate      /etc/ssl/certificate.crt;
      ssl_certificate_key  /etc/ssl/private.key;
      ssl_session_cache shared:SSL:1m;
      ssl_session_timeout  10m;
      ssl_ciphers HIGH:!aNULL:!MD5;
      ssl_prefer_server_ciphers on;

      # Load configuration files for the default server block.
      include /etc/nginx/default.d/*.conf;

      try_files $uri.json $uri $uri/ =404;

      error_page 404 /404.html;
        location = /40x.html {
      }

      error_page 500 502 503 504 /50x.html;
        location = /50x.html {
      }
    }
    ```