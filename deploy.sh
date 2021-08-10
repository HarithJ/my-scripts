#!/bin/bash

RED='\033[1;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'

check_vars()
{
    var_names=("$@")
    for var_name in "${var_names[@]}"; do
        [ -z "${!var_name}" ] && echo -e "${RED}$var_name is unset." && var_unset=true
    done
    [ -n "$var_unset" ] && exit 1
    return 0
}


if [ ! -f .env.deploy ]; then
    echo -e "\n${RED}.env.deploy file not found.\n"
    echo -e "${GREEN}Please create .env.deploy file and set the following env vars:"
    echo -e "${PURPLE}PROJECT_ID"
    echo -e "${PURPLE}IMAGE"
    echo -e "${PURPLE}TAG" 
    echo -e "${PURPLE}SECRET"
    echo -e "${PURPLE}SECRET_VER"
    echo -e "${PURPLE}APP"

    exit 1
fi

source .env.deploy

check_vars PROJECT_ID IMAGE TAG SECRET SECRET_VER APP

docker build --target prod -t gcr.io/${PROJECT_ID}/${IMAGE}:${TAG} .
docker push gcr.io/${PROJECT_ID}/${IMAGE}:${TAG}

gcloud --project ${PROJECT_ID} run deploy ${APP} \
        --image gcr.io/${PROJECT_ID}/${IMAGE}:${TAG} \
        --region europe-west1 --platform managed --allow-unauthenticated \
        --set-env-vars PROJECT_ID=${PROJECT_ID},SECRET=${SECRET},SECRET_VER=${SECRET_VER} \
        --service-account=pp-secret@last-mile-distribution.iam.gserviceaccount.com
