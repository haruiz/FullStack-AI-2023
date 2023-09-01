
IMAGE_NAME="iris-model-ui:latest"
CONTAINER_NAME="iris-model-ui"
RUN_INTERACTIVE=false    

# list all running containers
#docker ps -a

if docker inspect -f '{{.Config.Image}}' $CONTAINER_NAME >/dev/null 2>&1; then
    echo "Stopping running containers..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# check if image exists and remove it
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
  echo "Image $IMAGE_NAME exists. Removing image..."
  docker rmi $IMAGE_NAME
fi

# create docker image
docker build -t $IMAGE_NAME .

# run the container
if $RUN_INTERACTIVE; then
  echo "Running container in interactive mode..."
  docker run -it --name $CONTAINER_NAME -v .:/app  -p 8501:8501 $IMAGE_NAME
  exit 0
else
    echo "Running container in detached mode..."
    docker run -d --name $CONTAINER_NAME -v .:/app  -p 8501:8501 $IMAGE_NAME
    # open shell in container
    docker exec -it $CONTAINER_NAME /bin/bash
    exit 0
fi

