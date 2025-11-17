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
  "webserver_port": 8000,
  "disable_file_logging": 1
}
EOF
```

### Setting up common sites config in AWS
```
cat > /home/akwad/benches/sullam-bench/sites/common_site_config.json <<'EOF'
{
  "db_host": "ip-10-0-197-164.me-south-1.compute.internal",
  "redis_cache": "redis://ip-10-0-197-164.me-south-1.compute.internal:6379/0",
  "redis_queue": "redis://ip-10-0-197-164.me-south-1.compute.internal:6379/1",
  "redis_socketio": "redis://ip-10-0-197-164.me-south-1.compute.internal:6379/2",
  "socketio_host": "http://ip-10-0-197-164.me-south-1.compute.internal",
  "socketio_port": 9000,
  "webserver_port": 8000,
  "disable_file_logging": 1
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
### New site on AWS
```
bench new-site dockerdemo.akwad.qa \
  --db-type postgres \
  --db-host ip-10-0-197-164.me-south-1.compute.internal \
  --db-port 5432 \
  --db-root-username frappe \
  --db-root-password frappe \
  --admin-password frappe \
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
