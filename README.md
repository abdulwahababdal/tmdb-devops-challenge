## To run from CMD

In project folder run

npm start

## Build Docker

In project folder run

docker build -t {image name} .

docker run -p 3000 {image name}

## Challenge Summary

- A GitLab CI pipeline was implemented and committed using `.gitlab-ci.yml`.
- The pipeline runs automatically on pushes and includes linting, testing, build, and container packaging stages.
- Pipeline stages, status, and runtime are visible in the GitLab CI interface.
- A Linux virtual machine was provisioned as the deployment environment.
- Secure access to the VM was configured using public/private SSH key authentication.
- The application was containerized using Docker to ensure consistent deployments.
- A multi-architecture Docker image was built to support linux/amd64.
- The Docker image was pushed to Docker Hub and pulled from the virtual machine.
- The application was deployed on the VM as a Docker container and exposed via a public port.
- A Docker restart policy was configured to ensure the service automatically recovers after failures.
- Service recovery was validated by manually stopping the container and confirming automatic restart.

- GitLab CI pipeline execution and runtime:
  https://gitlab.com/abdulwahababdal/tmdb-devops-challenge/-/pipelines/2277241486


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