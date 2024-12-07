@echo off

REM Delete old containers and images
docker rm -f $(docker ps -a -q --filter ancestor=t6server-tests)
docker rmi t6server-tests

REM Build the Docker image
docker build -f .config/utility/dev/Dockerfile -t t6server-tests .

REM Run the tests in a new container
docker run --rm t6server-tests

pause