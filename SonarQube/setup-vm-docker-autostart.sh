#!/bin/bash
# Setup script to configure Ubuntu VM for Docker auto-start on boot
# Run this on your Azure VM via SSH

set -e

echo "=== Docker Auto-Start Configuration for SonarQube ==="

# Ensure Docker service is enabled and running
echo "Enabling Docker service to start on boot..."
sudo systemctl enable docker
sudo systemctl start docker

# Get the directory where docker-compose.yml is located
# Update this path to match your actual deployment directory
COMPOSE_DIR="${1:-/home/$(whoami)/sonarqube}"

echo "Using compose directory: $COMPOSE_DIR"

# Create systemd service for SonarQube containers
cat << EOF | sudo tee /etc/systemd/system/sonarqube-compose.service
[Unit]
Description=SonarQube Docker Compose
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$COMPOSE_DIR
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
echo "Creating and enabling systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable sonarqube-compose.service

# Start the service now
echo "Starting SonarQube containers..."
sudo systemctl start sonarqube-compose.service

echo ""
echo "=== Setup Complete ==="
echo "Docker and SonarQube containers will now auto-start when the VM boots."
echo ""
echo "Useful commands:"
echo "  sudo systemctl status sonarqube-compose.service  - Check service status"
echo "  sudo journalctl -u sonarqube-compose.service     - View service logs"
echo "  sudo docker compose ps                           - Check container status"
