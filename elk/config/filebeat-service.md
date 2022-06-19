- [Logstash Service](#logstash-service)
- [Fiebeat Service](#fiebeat-service)
  - [SOP](#sop)
  - [Azure NSG Flow](#azure-nsg-flow)
  - [Azure Firewall](#azure-firewall)
  - [Azure WAF Access](#azure-waf-access)
  - [Azure Activity](#azure-activity)
  - [M365 Office Activity](#m365-office-activity)
  - [AAD Signin](#aad-signin)
  - [AAD Signin (Service Principal)](#aad-signin-service-principal)

# Logstash Service
```
[Service]
Type=simple
User=root
Group=root
EnvironmentFile=-/etc/default/logstash
EnvironmentFile=-/etc/sysconfig/logstash
ExecStart=/usr/share/logstash/bin/logstash "-r" "--path.settings" "/etc/logstash"
Restart=always
WorkingDirectory=/
Nice=19
LimitNOFILE=16384
```

# Fiebeat Service
## SOP
- `cp /usr/lib/systemd/system/filebeat.service /usr/lib/systemd/system/filebeat-xxx.service`
- `ln -s /usr/lib/systemd/system/filebeat-xxx.service`

## Azure NSG Flow
```bash
systemctl enable filebeat-nsg-flow
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-nsg-flow.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-nsg-flow --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## Azure Firewall
```bash
systemctl enable filebeat-firewall
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-firewall.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-firewall --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## Azure WAF Access
```bash
systemctl enable filebeat-waf-access
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-waf-access.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-waf-access --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## Azure Activity
```bash
systemctl enable filebeat-activity
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-activity.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-activity --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## M365 Office Activity
```bash
systemctl enable filebeat-m365-office-activity
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-m365-office-activity.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-m365-office-activity --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## AAD Signin
```bash
systemctl enable filebeat-m365
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-aad-signin.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-aad-signin --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```

## AAD Signin (Service Principal)
```bash
systemctl status filebeat-service-principal-signin
```
```
[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat-service-principal-signin.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat-service-principal-signin --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd $BEAT_LOG_OPTS $BEAT_CONFIG_OPTS $BEAT_PATH_OPTS
Restart=always
```