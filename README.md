### Bench creation inside the debugger

```
bench init sullam-bench --no-procfile --no-backups --skip-redis-config-generation
```


Bench init requires maraidb-client dependencies even when using postgres (make sure to get it in base)

### Setting up common sites config
```
cat > /home/akwad/benches/sullam-bench/sites/common_site_config.json <<'EOF'
{
  "redis_cache": "redis://redis-cache:6379",
  "redis_queue": "redis://redis-queue:6379",
  "redis_socketio": "redis://redis-cache:6379",
  "socketio_port": 9000,
  "webserver_port": 8000
}
EOF
```

### Creating a new site
```
bench new-site test.localhost2 \
  --db-type postgres \
  --db-host postgresql \
  --db-port 5432 \
  --db-root-username postgres \
  --db-root-password 123 \
  --db-name frappe \
  --db-user postgres \
  --db-password 123 \
  --admin-password 123 \
  --force

  
```

### TZDate depedency issue
```
source /home/akwad/benches/sullam-bench/env/bin/activate
pip install tzdata
deactivate

```

### Nginx frobidden issue
```
chmod -R o+rX /home/akwad
```