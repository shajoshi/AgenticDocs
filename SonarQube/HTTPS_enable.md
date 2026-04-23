This document provides a technical walkthrough of how HTTPS was enabled for the SonarQube instance hosted on an Azure VM using Nginx as a reverse proxy and Let's Encrypt for SSL certificates.

# HTTPS_enable.md

## 1. Directory Structure Setup
Before deploying the containers, the following directory structure was created on the VM to hold configuration and certificate data.

**Commands:**
```bash
mkdir -p ~/sonar-production/nginx/conf
mkdir -p ~/sonar-production/certbot/conf
mkdir -p ~/sonar-production/certbot/www
```

---

## 2. Phase 1: The "Bootstrap" Configuration
To obtain a certificate from Let's Encrypt, Nginx must be running on Port 80 to pass the "Webroot" challenge. Since the SSL certificates did not exist yet, a temporary configuration was used to avoid Nginx startup crashes.

**File:** `~/sonar-production/nginx/conf/sonar.conf` (Initial Version)
```nginx
server {
    listen 80;
    server_name rivvundevops1.eastus.cloudapp.azure.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://sonarqube:9000;
        proxy_set_header Host $host;
    }
}
```

---

## 3. Phase 2: Certificate Acquisition
With Nginx running in "Bootstrap" mode, the Certbot tool was used to request the initial certificates.

**Bash Commands:**
```bash
# Start Nginx in the background
sudo docker compose up -d nginx

# Run Certbot to request the certificate
sudo docker run --rm -it \
  -v $(pwd)/certbot/conf:/etc/letsencrypt \
  -v $(pwd)/certbot/www:/var/www/certbot \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  -d rivvundevops1.eastus.cloudapp.azure.com
```

---

## 4. Phase 3: Final Secure Configuration
After the certificates were successfully generated and saved to the VM, the Nginx configuration was updated to enforce HTTPS and use the new `.pem` files.

**File:** `~/sonar-production/nginx/conf/sonar.conf` (Final Version)
```nginx
server {
    listen 80;
    server_name rivvundevops1.eastus.cloudapp.azure.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name rivvundevops1.eastus.cloudapp.azure.com;

    ssl_certificate /etc/letsencrypt/live/rivvundevops1.eastus.cloudapp.azure.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/rivvundevops1.eastus.cloudapp.azure.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://sonarqube:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size 100M;
    }
}
```

---

## 5. Docker Compose Infrastructure
The `docker-compose.yml` was updated to include the `nginx` and `certbot` services, ensuring they share the same internal network as SonarQube.

**File:** `~/sonar-production/docker-compose.yml` (Nginx/Certbot Snippet)
```yaml
  nginx:
    image: nginx:latest
    container_name: nginx-proxy
    networks:
      - sonarnet
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    depends_on:
      - sonarqube
    restart: unless-stopped

  certbot:
    image: certbot/certbot
    container_name: certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
    restart: unless-stopped
```

---

## 6. Deployment & Verification
To apply the final secure state, the following commands were used:

**Bash Commands:**
```bash
# Restart Nginx to load the new config and certificates
sudo docker compose restart nginx

# Verify all containers are running
sudo docker compose ps

# Check Nginx logs for any SSL errors
sudo docker compose logs nginx-proxy
```

---

### Final Requirements
* **GitHub Actions:** The `SONAR_HOST_URL` variable was updated to `https://rivvundevops1.eastus.cloudapp.azure.com`.
* **SonarQube UI:** The **Server Base URL** was updated to the HTTPS address in the Administration settings.