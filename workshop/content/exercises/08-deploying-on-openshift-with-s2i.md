The idea here is that once you're fine with your code you want to deploy it on OpenShift but there are several options:

- create your own Docker file
- use one of the docker files provided in ./src/main/docker

Of course you would need to create all the additional elements to run your image in OpenShift: deployment, service, etc.

This is a valid option, but Red Hat provided with a different, more repeatable approach, **Source to Image**.

With **Source to Image**, `s2i` for short you don't need a Dockerfile. You can find more information about it [here](https://quarkus.io/guides/deploying-to-openshift-s2i#deploying-the-application-as-java-application-in-openshift).

There are two ways to use `s2i` for Quarkus: Java or Native. In this section, we are going to leverage the `s2i` build mechanism of OpenShift using the Java S2I Builder. 

> **NOTE:** You do not need to locally clone the Git repository, as it will be directly built inside OpenShift.

# Building the image on OpenShift

```execute-2
oc new-app registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/cvicens/atomic-fruit-service.git --context-dir=. --name=atomic-fruit-service
oc logs -f bc/atomic-fruit-service
```

# To create the route

```execute-2
oc expose svc/atomic-fruit-service
```

# Get the route URL

```execute-2
export URL="http://$(oc get route | grep atomic-fruit-service | awk '{print $2}')"
```

Your application is accessible at the printed URL.

```execute-2
curl $URL/fruit
```

> **NOTE:** Swagger UI is not available because by default is available only in `dev` mode.

