## To run from CMD

In project folder run

npm start

## Build Docker

In project folder run

docker build -t {image name} .

docker run -p 3000 {image name}

## Challenge Summary

- CI pipeline implemented using GitHub Actions (basic validation on push/PR).
- Application containerized with Docker.
- Automatic restart configured using Docker restart policy.
- External uptime monitoring configured to detect downtime and recovery.

> Note: Monitoring was validated using a public endpoint exposed temporarily for testing purposes.

# TMDB DevOps Challenge

# to run

docker build -t tmdb-devops .
docker run -d --name tmdb-app -p 3000:3000 tmdb-devops

# to stop

docker stop tmdb-app
docker rm tmdb-app
