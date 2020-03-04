LAB - Markdown Sample
=====================

Sample workshop content using Markdown formatting for pages.

## Preparing the workshop

oc new-project lab-quarkus

DASHBOARD_IMAGE in .workshop/default-settings.sh ==> Dokerfile !

WORKSHOP_NAME => .workshop/settings.sh

WORKSHOP_TITLE       => .workshop/settings.sh
WORKSHOP_DESCRIPTION => .workshop/settings.sh
SPAWNER_REPO         => .workshop/settings.sh

AUTH_USERNAME => .workshop/develop-settings.sh
AUTH_PASSWORD => .workshop/develop-settings.sh

Update Workshop Scripts => git submodule update --remote

## Deploying the workshop


## Local Development
docker build -t lab-quarkus:0.2 .
docker run --rm -p 10080:10080 -e CLUSTER_SUBDOMAIN=apps.cluster-lisbon-5342.lisbon-5342.example.opentlc.com -e OCP_USERNAME=user1 -e USERID=1 -e OCP_PASSWORD=openshift -e KUBERNETES_SERVICE_HOST=api.cluster-lisbon-5342.lisbon-5342.example.opentlc.com -e KUBERNETES_SERVICE_PORT=6443 --name lab-quarkus lab-quarkus:0.2
