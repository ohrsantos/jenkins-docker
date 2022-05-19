#docker build -t myjenkins-blueocean:1 .

#docker network create jenkins 

docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs                  \
  --volume "$(pwd)/jenkins-docker-certs":/certs/client      \
  --volume "$(pwd)/jenkins-docker-data":/var/jenkins_home \
  --publish 2376:2376                              \
  docker:dind                                      \
  --storage-driver overlay2                        

docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume "$(pwd)/jenkins-docker-data":/var/jenkins_home \
  --volume "$(pwd)/jenkins-docker-certs":/certs/client:ro \
  myjenkins-blueocean:1
