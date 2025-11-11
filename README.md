### Bench creation inside the debugger

```
bench init sullam-bench --no-procfile --no-backups --skip-redis-config-generation
```


Bench init requires maraidb-client dependencies even when using postgres (make sure to get it in base)

### Setting up common sites config
```
cat > /home/akwad/sullam-bench/sites/common_site_config.json <<'EOF'
{
  "db_type": "postgres",
  "db_host": "postgresql",
  "db_port": 5432,
  "db_name": "frappe",
  "db_user": "postgres",
  "db_password": "123",
  "redis_cache": "redis://redis-cache:6379",
  "redis_queue": "redis://redis-queue:6379",
  "redis_socketio": "redis://redis-cache:6379",
  "socketio_port": 9000,
  "webserver_port": 8000
}
EOF
```

### Creating a log file for web
```
mkdir -p /home/akwad/logs
```

### 

### Creating a new site
```
bench new-site test \
  --db-user postgres \
  --db-password 123 \
  --admin-password 123 \
  --db-type postgres
  
```


