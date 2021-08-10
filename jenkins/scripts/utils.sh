#!/bin/bash
set -e

BOLD='\e[1m'
BLUE='\e[34m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[92m'
NC='\e[0m'


info() {
    printf "\n${BOLD}${BLUE}====> $(echo $@ ) ${NC}\n"
}

warning () {
    printf "\n${BOLD}${YELLOW}====> $(echo $@ )  ${NC}\n"
}

error() {
    printf "\n${BOLD}${RED}====> $(echo $@ )  ${NC}\n"; exit 1
}

success () {
    printf "\n${BOLD}${GREEN}====> $(echo $@ ) ${NC}\n"
}

is_success_or_fail() {
    if [ "$?" == "0" ]; then success $@; else error $@; fi
}

is_success() {
    if [ "$?" == "0" ]; then success $@; fi
}

# require "variable name" "value"
require () {
    if [ -z ${2+x} ]; then error "Required variable ${1} has not been set"; fi
}

SERVICE_KEY_PATH=$HOME/service-account-key.json

# assert required variables
# Production variables needed for deployment
require PRODUCTION_COMPUTE_ZONE $PRODUCTION_COMPUTE_ZONE
require PRODUCTION_STATIC_IP $PRODUCTION_STATIC_IP
require PRODUCTION_CLUSTER_NAME $PRODUCTION_CLUSTER_NAME

# QA variables needed for deployment
require QA_STATIC_IP $QA_STATIC_IP
require QA_CLUSTER_NAME $QA_CLUSTER_NAME

# Staging variables needed for deployment
require STAGING_COMPUTE_ZONE $STAGING_COMPUTE_ZONE
require STAGING_STATIC_IP $STAGING_STATIC_IP
require STAGING_CLUSTER_NAME $STAGING_CLUSTER_NAME

# Production variables needed in application
require PRODUCTION_DATABASE_URL $PRODUCTION_DATABASE_URL
require PRODUCTION_JWT_PUBLIC_KEY $PRODUCTION_JWT_PUBLIC_KEY
require PRODUCTION_DEFAULT_ADMIN $PRODUCTION_DEFAULT_ADMIN
require PRODUCTION_BUGSNAG_API_KEY $PRODUCTION_BUGSNAG_API_KEY
require PRODUCTION_REDIRECT_URL $PRODUCTION_REDIRECT_URL
require PRODUCTION_MAILGUN_API_KEY $PRODUCTION_MAILGUN_API_KEY
require PRODUCTION_MAILGUN_DOMAIN_NAME $PRODUCTION_MAILGUN_DOMAIN_NAME
require PRODUCTION_MAIL_SENDER $PRODUCTION_MAIL_SENDER
require PRODUCTION_SURVEY_URL $PRODUCTION_SURVEY_URL
require PRODUCTION_CLOUDINARY_CLOUD_NAME $PRODUCTION_CLOUDINARY_CLOUD_NAME
require PRODUCTION_CLOUDINARY_API_KEY $PRODUCTION_CLOUDINARY_API_KEY
require PRODUCTION_CLOUDINARY_API_SECRET $PRODUCTION_CLOUDINARY_API_SECRET
require PRODUCTION_CLOUDINARY_ENHANCE_IMAGE $PRODUCTION_CLOUDINARY_ENHANCE_IMAGE
require PRODUCTION_CLOUDINARY_STATIC_IMAGE $PRODUCTION_CLOUDINARY_STATIC_IMAGE
require PRODUCTION_TRAVEL_READINESS_MAIL_CYCLE $PRODUCTION_TRAVEL_READINESS_MAIL_CYCLE
require PRODUCTION_ANDELA_PROD_API $PRODUCTION_ANDELA_PROD_API
require PRODUCTION_BAMBOOHR_API $PRODUCTION_BAMBOOHR_API
require PRODUCTION_DB_INSTANCE_CONNECTION_NAME $PRODUCTION_DB_INSTANCE_CONNECTION_NAME
require PRODUCTION_LASTCHANGED_BAMBOO_API $PRODUCTION_LASTCHANGED_BAMBOO_API
require PRODUCTION_BAMBOOHRID_API $PRODUCTION_BAMBOOHRID_API 
require PRODUCTION_OCRSOLUTION $PRODUCTION_OCRSOLUTION

# QA variables needed in application
require QA_DATABASE_URL $QA_DATABASE_URL
require QA_REDIRECT_URL $QA_REDIRECT_URL
require QA_DB_INSTANCE_CONNECTION_NAME $QA_DB_INSTANCE_CONNECTION_NAME

# Staging variables needed in application
require STAGING_DATABASE_URL $STAGING_DATABASE_URL
require STAGING_JWT_PUBLIC_KEY $STAGING_JWT_PUBLIC_KEY
require STAGING_DEFAULT_ADMIN $STAGING_DEFAULT_ADMIN
require STAGING_BUGSNAG_API_KEY $STAGING_BUGSNAG_API_KEY
require STAGING_REDIRECT_URL $STAGING_REDIRECT_URL
require STAGING_MAILGUN_API_KEY $STAGING_MAILGUN_API_KEY
require STAGING_MAILGUN_DOMAIN_NAME $STAGING_MAILGUN_DOMAIN_NAME
require STAGING_MAIL_SENDER $STAGING_MAIL_SENDER
require STAGING_SURVEY_URL $STAGING_SURVEY_URL
require STAGING_CLOUDINARY_CLOUD_NAME $STAGING_CLOUDINARY_CLOUD_NAME
require STAGING_CLOUDINARY_API_KEY $STAGING_CLOUDINARY_API_KEY
require STAGING_CLOUDINARY_API_SECRET $STAGING_CLOUDINARY_API_SECRET
require STAGING_CLOUDINARY_ENHANCE_IMAGE $STAGING_CLOUDINARY_ENHANCE_IMAGE
require STAGING_CLOUDINARY_STATIC_IMAGE $STAGING_CLOUDINARY_STATIC_IMAGE
require STAGING_TRAVEL_READINESS_MAIL_CYCLE $STAGING_TRAVEL_READINESS_MAIL_CYCLE
require STAGING_ANDELA_PROD_API $STAGING_ANDELA_PROD_API
require STAGING_BAMBOOHR_API $STAGING_BAMBOOHR_API
require STAGING_DB_INSTANCE_CONNECTION_NAME $STAGING_DB_INSTANCE_CONNECTION_NAME
require STAGING_LASTCHANGED_BAMBOO_API $STAGING_LASTCHANGED_BAMBOO_API
require STAGING_BAMBOOHRID_API $STAGING_BAMBOOHRID_API
require STAGING_OCRSOLUTION $STAGING_OCRSOLUTION

if [ "$BRANCH_NAME" == 'master' ]; then
    IMAGE_TAG=production-$(git rev-parse --short HEAD)
    export ENVIRONMENT=production
    export COMPUTE_ZONE=$PRODUCTION_COMPUTE_ZONE
    export CLUSTER_NAME=$PRODUCTION_CLUSTER_NAME
    export STATIC_IP=$PRODUCTION_STATIC_IP

    export DEFAULT_ADMIN=$PRODUCTION_DEFAULT_ADMIN
    export DATABASE_URL=$PRODUCTION_DATABASE_URL
    export DB_INSTANCE_CONNECTION_NAME=$PRODUCTION_DB_INSTANCE_CONNECTION_NAME
    export JWT_PUBLIC_KEY=$PRODUCTION_JWT_PUBLIC_KEY
    export BUGSNAG_API_KEY=$PRODUCTION_BUGSNAG_API_KEY
    export REDIRECT_URL=$PRODUCTION_REDIRECT_URL
    export MAILGUN_API_KEY=$PRODUCTION_MAILGUN_API_KEY
    export MAILGUN_DOMAIN_NAME=$PRODUCTION_MAILGUN_DOMAIN_NAME
    export MAIL_SENDER=$PRODUCTION_MAIL_SENDER
    export SURVEY_URL=$PRODUCTION_SURVEY_URL
    export CLOUDINARY_CLOUD_NAME=$PRODUCTION_CLOUDINARY_CLOUD_NAME
    export CLOUDINARY_API_KEY=$PRODUCTION_CLOUDINARY_API_KEY
    export CLOUDINARY_API_SECRET=$PRODUCTION_CLOUDINARY_API_SECRET
    export CLOUDINARY_ENHANCE_IMAGE=$PRODUCTION_CLOUDINARY_ENHANCE_IMAGE
    export CLOUDINARY_STATIC_IMAGE=$PRODUCTION_CLOUDINARY_STATIC_IMAGE
    export TRAVEL_READINESS_MAIL_CYCLE=$PRODUCTION_TRAVEL_READINESS_MAIL_CYCLE
    export ANDELA_PROD_API=$PRODUCTION_ANDELA_PROD_API
    export BAMBOOHR_API=$PRODUCTION_BAMBOOHR_API
    export LASTCHANGED_BAMBOO_API=$PRODUCTION_LASTCHANGED_BAMBOO_API
    export BAMBOOHRID_API=$PRODUCTION_BAMBOOHRID_API
    export OCRSOLUTION=$PRODUCTION_OCRSOLUTION
else
    IMAGE_TAG=staging-$(git rev-parse --short HEAD)
    export ENVIRONMENT=staging
    export COMPUTE_ZONE=$STAGING_COMPUTE_ZONE
    export CLUSTER_NAME=$STAGING_CLUSTER_NAME
    export STATIC_IP=$STAGING_STATIC_IP

    export DEFAULT_ADMIN=$STAGING_DEFAULT_ADMIN
    export DATABASE_URL=$STAGING_DATABASE_URL
    export DB_INSTANCE_CONNECTION_NAME=$STAGING_DB_INSTANCE_CONNECTION_NAME
    # Staging will be using production's JWT_PUBLIC_KEY
    # Change PRODUCTION to STAGING to revert changes
    export JWT_PUBLIC_KEY=$PRODUCTION_JWT_PUBLIC_KEY
    export BUGSNAG_API_KEY=$STAGING_BUGSNAG_API_KEY
    export REDIRECT_URL=$STAGING_REDIRECT_URL
    export MAILGUN_API_KEY=$STAGING_MAILGUN_API_KEY
    export MAILGUN_DOMAIN_NAME=$STAGING_MAILGUN_DOMAIN_NAME
    export MAIL_SENDER=$STAGING_MAIL_SENDER
    export SURVEY_URL=$STAGING_SURVEY_URL
    export CLOUDINARY_CLOUD_NAME=$STAGING_CLOUDINARY_CLOUD_NAME
    export CLOUDINARY_API_KEY=$STAGING_CLOUDINARY_API_KEY
    export CLOUDINARY_API_SECRET=$STAGING_CLOUDINARY_API_SECRET
    export CLOUDINARY_ENHANCE_IMAGE=$STAGING_CLOUDINARY_ENHANCE_IMAGE
    export CLOUDINARY_STATIC_IMAGE=$STAGING_CLOUDINARY_STATIC_IMAGE
    export TRAVEL_READINESS_MAIL_CYCLE=$STAGING_TRAVEL_READINESS_MAIL_CYCLE
    # Staging will be using production's ANDELA_PROD_API
    # Change PRODUCTION to STAGING to revert changes
    export ANDELA_PROD_API=$PRODUCTION_ANDELA_PROD_API
    export BAMBOOHR_API=$STAGING_BAMBOOHR_API
    export LASTCHANGED_BAMBOO_API=$STAGING_LASTCHANGED_BAMBOO_API
    export BAMBOOHRID_API=$STAGING_BAMBOOHRID_API
    export OCRSOLUTION=$STAGING_OCRSOLUTION
fi

export NAMESPACE=$ENVIRONMENT

# overwrite certain env vars for qa testing environment
if [ "$BRANCH_NAME" == 'deploy-qa' ]; then
  export ENVIRONMENT=qa
  export CLUSTER_NAME=$QA_CLUSTER_NAME
  export STATIC_IP=$QA_STATIC_IP

  export DATABASE_URL=$QA_DATABASE_URL
  export DB_INSTANCE_CONNECTION_NAME=$QA_DB_INSTANCE_CONNECTION_NAME
  export REDIRECT_URL=$QA_REDIRECT_URL
fi


EMOJIS=(
    ":celebrate:"  ":party_dinosaur:"  ":andela:" ":aw-yeah:" ":carlton-dance:"
    ":partyparrot:" ":dancing-penguin:" ":aww-yeah-remix:"
)

RANDOM=$$$(date +%s)

EMOJI=${EMOJIS[$RANDOM % ${#EMOJIS[@]} ]}

LINK="https://github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/commit/${GIT_COMMIT}"

SLACK_TEXT="Git Commit Tag: <$LINK|${IMAGE_TAG}> has just been deployed to *${PROJECT_NAME}* in *${ENVIRONMENT}* ${EMOJI}"