1. The Dockerfile must be built to a Docker image called 'development_base'.
2. To build the image, do `sudo docker build -t development-base .` while being in the same directory as Dockerfile
3. The create_container.sh script will let you create Docker containers based off this base image.
4. The args are as follows: <container name> <outward facing port [e.g. 22000]> <allowed SSH public key in quotes>
5. You can then do `sudo docker start <container name>`
6. Now do `sudo docker ps` to get the container ID
7. Then do `sudo docker update --restart always <container id>` to ensure the container autostarts
8. Allow the outward facing port you have set to accept connections from the internet