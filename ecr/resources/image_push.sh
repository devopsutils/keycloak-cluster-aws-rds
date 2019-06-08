REGION=$1
IMAGE_NAME=$2
REPO_URL=$3
IMAGE_ID=`docker images $IMAGE_NAME -q`

echo "REGION=$REGION"
echo "IMAGE_NAME=$IMAGE_NAME"
echo "REPO_URL=$REPO_URL"
echo "IMAGE_ID=$IMAGE_ID"

echo "Login to ECR..."
eval $(aws ecr get-login --no-include-email --region $REGION)

echo "Tagging image..."
echo "running command:  docker tag $IMAGE_ID $REPO_URL"
docker tag $IMAGE_ID $REPO_URL

echo "Pushing image..."
# docker push $REPO_URL/$IMAGE_NAME
docker push $REPO_URL
