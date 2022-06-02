# Hello world project: creation of a CICD docker container which deploys pod to kubernetes + elastic APM integration

#### YouTube channel: https://www.youtube.com/channel/UCRjOYVh15Ul-b2kHTfEMm6A

#### The CICD container needs to connect to the host docker daemon, that's why set this volume binding:
docker run -v /var/run/docker.sock:/var/run/docker.sock

#### See: https://devopscube.com/run-docker-in-docker/


