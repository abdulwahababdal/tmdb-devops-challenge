## To run from CMD

In project folder run

npm start

## Build Docker

In project folder run

docker build -t {image name} .

docker run -p 3000 {image name}

## Challenge Summary

- A basic CI workflow was configured using GitHub Actions to run checks on pushes and pull requests.
- A Linux virtual machine was provisioned to act as the deployment environment.
- Secure access to the VM was set up using public/private SSH key authentication.
- The application was containerized with Docker to ensure consistent deployment.
- The Docker image was built for the server architecture and pushed to Docker Hub.
- The application was deployed on the VM as a Docker container and exposed via a public port.
- A Docker restart policy was applied so the service automatically restarts after failures.
- External uptime monitoring was configured to detect downtime and confirm recovery.

## Generate an SSH key pair locally (private key remains on the local machine, only the public key is shared)
ssh-keygen -t ed25519 -f ~/.ssh/oracle_tmdb -C "tmdb-devops"

## Connect to the virtual machine using SSH key authentication
ssh -i ~/.ssh/oracle_tmdb root@<SERVER_IP>

## Update the server and install Docker using the official installer
apt update && apt upgrade -y
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

## Build and push the Docker image for linux/amd64 using Docker Buildx (Apple Silicon to Linux VM)
docker buildx use desktop-linux
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64 -t aabdal/tmdb-devops:latest --push .

## Pull the Docker image on the virtual machine
docker pull aabdal/tmdb-devops:latest

## Run the application container with an automatic restart policy
docker rm -f tmdb-app 2>/dev/null || true
docker run -d --name tmdb-app --restart unless-stopped -p 3000:3000 aabdal/tmdb-devops:latest

## Verify the application locally on the virtual machine
curl -I http://localhost:3000

## Access the application externally in a browser
http://<SERVER_IP>:3000

## Confirm the Docker restart policy
docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' tmdb-app

## Test automatic recovery by stopping the container and verifying it restarts
docker kill tmdb-app
sleep 3
docker ps | grep tmdb-app

## Stop and remove the container if required
docker stop tmdb-app
docker rm tmdb-app