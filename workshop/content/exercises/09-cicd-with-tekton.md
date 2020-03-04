

### Creating a Tekton Pipeline to Build and Deploy our app

This part of the guide is explained in more detail in the [OpenShift Pipelines Tutorial](https://github.com/openshift/pipelines-tutorial)

#### Preprequisites

##### Install Knative CLI

```sh
curl -L https://github.com/knative/client/releases/download/v${KNATIVE_CLI_VERSION}/kn-${GRAALVM_OSTYPE}-amd64  -o ./bin/kn
chmod u+x ./bin/kn
kn version
```

##### Install Tekton CLI

```sh
curl -LO https://github.com/tektoncd/cli/releases/download/v${TEKTON_CLI_VERSION}/tkn_${TEKTON_CLI_VERSION}_${TEKTON_OSTYPE}_x86_64.tar.gz
tar xvzf tkn_${TEKTON_CLI_VERSION}_${TEKTON_OSTYPE}_x86_64.tar.gz -C $(pwd)/bin tkn
tkn version
```

##### Install OpenShift Pipelines

https://github.com/openshift/pipelines-tutorial/blob/master/install-operator.md

##### Adjusting security configuration

Building container images using build tools such as S2I, Buildah, Kaniko, etc require privileged access to the cluster. OpenShift default security settings do not allow privileged containers unless specifically configured. Create a service account for running pipelines and enable it to run privileged pods for building images:

```sh
oc create serviceaccount pipeline -n atomic-fruit-%userid%
oc adm policy add-scc-to-user privileged -z pipeline -n atomic-fruit-%userid%
oc adm policy add-role-to-user edit -z pipeline -n atomic-fruit-%userid%
```

#### Create tasks

```sh
oc apply -f https://raw.githubusercontent.com/cvicens/atomic-fruit-service/master/src/main/k8s/openshift-deploy-app-task.yaml -n atomic-fruit-%userid%
oc apply -f https://raw.githubusercontent.com/cvicens/atomic-fruit-service/master/src/main/k8s/s2i-quarkus-task.yaml -n atomic-fruit-%userid%
```

Check that our tasks are there.

```sh
tkn tasks list
NAME               AGE
openshift-client   35 minutes ago
s2i-quarkus        6 minutes ago
```

#### Create a pipeline with those tasks

Create a pipeline by running the next command.

```sh
oc apply -f https://raw.githubusercontent.com/cvicens/atomic-fruit-service/master/src/main/k8s/atomic-fruit-service-build-pipeline.yaml -n atomic-fruit-%userid%
oc apply -f https://raw.githubusercontent.com/cvicens/atomic-fruit-service/master/src/main/k8s/atomic-fruit-service-deploy-pipeline.yaml -n atomic-fruit-%userid%
```

Let's see if our pipeline is where it should be.

```sh
$ tkn pipeline list
NAME                                   AGE              LAST RUN                                         STARTED        DURATION     STATUS
atomic-fruit-service-build-pipeline    11 seconds ago   ---                                              ---            ---          ---
atomic-fruit-service-deploy-pipeline   1 day ago        atomic-fruit-service-deploy-pipeline-run-bd2hd   23 hours ago   9 minutes    Succeeded
```

#### Triggering a pipeline

Triggering pipelines is an area that is under development and in the next release it will be possible to be done via the OpenShift web console and Tekton CLI. In this tutorial, you will trigger the pipeline through creating the Kubernetes objects (the hard way!) in order to learn the mechanics of triggering.

First, you should create a number of PipelineResources that contain the specifics of the Git repository and image registry to be used in the pipeline during execution. Expectedly, these are also reusable across multiple pipelines.

```sh
oc apply -f https://raw.githubusercontent.com/cvicens/atomic-fruit-service/master/src/main/k8s/atomic-fruit-service-resources.yaml -n atomic-fruit-%userid%
```
List those resources we've just created.

```sh
$ tkn resources list
NAME                         TYPE    DETAILS
atomic-fruit-service-git     git     url: https://github.com/cvicens/atomic-fruit-service
atomic-fruit-service-image   image   url: image-registry.openshift-image-registry.svc:5000/atomic-fruit/atomic-fruit-service
```

Now it's time to actually trigger the pipeline.

> **NOTE 1:** you may need to delete or tune limit in your namespace as in `oc delete limitrange --all -n atomic-fruit-%userid%`
> **NOTE 2:** The `-r` flag specifies the PipelineResources that should be provided to the pipeline and the `-s` flag specifies the service account to be used for running the pipeline finally `-p` is for parameters.


Let's trigger a quarkus native build using a Tekton pipeline.

```sh
$ tkn pipeline start atomic-fruit-service-build-pipeline \
        -r app-git=atomic-fruit-service-git \
        -r app-image=atomic-fruit-service-image \
        -p APP_NAME=atomic-fruit-service \
        -p NAMESPACE=atomic-fruit-%userid% \
        -s pipeline

Pipelinerun started: atomic-fruit-service-build-pipeline-run-piu8y

In order to track the pipelinerun progress run:
tkn pipelinerun logs atomic-fruit-service-build-pipeline-run-piu8y -f -n atomic-fruit-%userid%
```

Now let's deploy our app as a normal DeployConfig using a S2I task in a Tekton pipeline.

```sh
$ tkn pipeline start atomic-fruit-service-deploy-pipeline \
        -r app-git=atomic-fruit-service-git \
        -r app-image=atomic-fruit-service-image \
        -p APP_NAME=atomic-fruit-service \
        -p NAMESPACE=atomic-fruit-%userid% \
        -s pipeline

Pipelinerun started: atomic-fruit-service-deploy-pipeline-run-xdtvs

In order to track the pipelinerun progress run:
tkn pipelinerun logs atomic-fruit-service-deploy-pipeline-run-xdtvs -f -n atomic-fruit-%userid%
```

After a success in the prevous pipeline run you should be able to test our app.

```sh
curl http://$(oc get route atomic-fruit-service | awk 'NR > 1 { print $2 }')/fruit
```

Again, the result should be the same.

### Going a step beyond, going serverless

#### Preprequisites

https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial-basics/0.7.x/01-setup.html

##### Install the Knative Serving

Go to `Catalog->Operatorhub` and look for `knative` you should get results similar to these ones. Click on Knative Serving Operator.

![Install Knative Serving 1](./docs/images/knative-serving-install-1.png)

Now click on `Install` to install the Serving part of Knative.

![Install Knative Serving 2](./docs/images/knative-serving-install-2.png)

As you see in the next picture this operator is installed cluster-wide. Click on `Subscribe` in order to install the operator. 

![Install Knative Serving 3](./docs/images/knative-serving-install-3.png)

After some minutes you'll see how the operator status moves from `1 Installing` to `1 Installed` as in the next pic.

![Install Knative Serving 4](./docs/images/knative-serving-install-4.png)

Check all is good.

```sh
$ oc get pod -n knative-serving
NAME                                         READY   STATUS    RESTARTS   AGE
activator-589784bc58-7c96f                   1/1     Running   0          48s
autoscaler-74bb8b4657-xpf24                  1/1     Running   0          47s
controller-7c9bfbd76-7txt6                   1/1     Running   0          42s
knative-openshift-ingress-57f5bb9ccd-q6grs   1/1     Running   0          38s
networking-certmanager-6fd9dd44bb-m57jt      1/1     Running   0          42s
networking-istio-784c7c97c-q969p             1/1     Running   0          41s
webhook-798f4bc969-92mvs                     1/1     Running   0          41s
```

##### Install Knative Eventing

In a similar fashion go to `Catalog->Operatorhub` and look for `knative` you should get results similar to these ones. Click on Knative Serving Operator.

![Install Knative Eventing 1](./docs/images/knative-eventing-install-1.png)

Now click on `Install` to install the Eventing part of Knative.

![Install Knative Eventing 2](./docs/images/knative-eventing-install-2.png)

As you see in the next picture this operator is installed cluster-wide. Click on `Subscribe` in order to install the operator. 

![Install Knative Eventing 3](./docs/images/knative-eventing-install-3.png)

After some minutes you'll see how the operator status moves from `1 Installing` to `1 Installed` as in the next pic.

![Install Knative Eventing 4](./docs/images/knative-eventing-install-4.png)

> **NOTE:** This could take 2 mins or so...

Check all is good.

```sh
$ oc get pod -n knative-eventing
NAME                                            READY   STATUS    RESTARTS   AGE
eventing-controller-5f84884d54-857f6            1/1     Running   0          48s
eventing-webhook-5798db889d-ss9jm               1/1     Running   0          47s
imc-controller-5dbf7dd77b-2w4ph                 1/1     Running   0          37s
imc-dispatcher-5d6c448bcb-q5km2                 1/1     Running   0          37s
in-memory-channel-controller-75c954fd67-qt2ql   1/1     Running   0          43s
in-memory-channel-dispatcher-8b7fcf4fd-l2rgm    1/1     Running   0          41s
sources-controller-578b47f948-rg7fq             1/1     Running   0          47s
```

##### Adding Security Constraints

```sh
oc adm policy add-scc-to-user privileged -z default -n atomic-fruit-%userid%
oc adm policy add-scc-to-user anyuid -z default -n atomic-fruit-%userid%
```

#### Deploy your app as Knative Service

Let's create a Knative service from the image we created previously.

```sh
oc apply -n atomic-fruit-%userid% -f ./src/main/k8s/atomic-fruit-knative-service-v1.yaml
```

```yaml
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: atomic-fruit-knative
spec:
  template:
    metadata:
      name: atomic-fruit-knative-v1
      annotations:
        # disable istio-proxy injection
        sidecar.istio.io/inject: "false"
        # Target 10 in-flight-requests per pod.
        autoscaling.knative.dev/target: "10"
    spec:
      containers:
      - #image: quay.io/cvicensa/atomic-fruit-service:1.0-SNAPSHOT
        image: image-registry.openshift-image-registry.svc:5000/atomic-fruit/atomic-fruit-service:latest
        livenessProbe:
          httpGet:
            path: /health
        readinessProbe:
          httpGet:
            path: /health

```

Get the list of revisions

```sh
$ kn revision list
NAME                      SERVICE                AGE    CONDITIONS   READY   REASON
atomic-fruit-knative-v1   atomic-fruit-knative   3d1h   3 OK / 4     True  
```

Now get the list of Knative services

```sh
$ kn service list
NAME                   URL                                                                                             GENERATION   AGE    CONDITIONS   READY   REASON
atomic-fruit-knative   http://atomic-fruit-knative.atomic-fruit.apps.cluster-kharon-688a.kharon-688a.open.redhat.com   1            3d1h   3 OK / 3     True 
```

You can also get the list of routes.

```ss
$ kn route list
NAME                   URL                                                                                             AGE    CONDITIONS   TRAFFIC
atomic-fruit-knative   http://atomic-fruit-knative.atomic-fruit.apps.cluster-kharon-688a.kharon-688a.open.redhat.com   3d1h   3 OK / 3     100% -> atomic-fruit-knative-v1
```

Finally you can see that behind Knative there are k8s native objects such as `Deployments`.

```sh
$ oc get deployments -n atomic-fruit-%userid%
NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
atomic-fruit-service-v1-deployment   0/1     1            0           22s
```

```sh
export SVC_URL=`oc get rt atomic-fruit-knative -o yaml | yq -r .status.url` && http "$SVC_URL/fruit/welcome"
```

Let's put our service under siege! c > 10 ==> scale up

```sh
siege -r 50 -c 25 "${SVC_URL}/fruit/Summer"
```

Let's generate a second revision of the knative service `atomic-fruit-service`

```sh
oc apply -n atomic-fruit-%userid% -f ./src/main/k8s/atomic-fruit-knative-service-v2.yaml
```

```yaml
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: atomic-fruit-knative
spec:
  template:
    metadata:
      name: atomic-fruit-knative-v2
      annotations:
        # disable istio-proxy injection
        sidecar.istio.io/inject: "false"
        # Target 10 in-flight-requests per pod.
        autoscaling.knative.dev/target: "10"
    spec:
      containers:
      - #image: quay.io/cvicensa/atomic-fruit-service:1.0-SNAPSHOT
        image: image-registry.openshift-image-registry.svc:5000/atomic-fruit/atomic-fruit-service:latest
        env:
        - name: WELCOME_MESSAGE
          value: Bienvenido
        livenessProbe:
          httpGet:
            path: /health
        readinessProbe:
          httpGet:
            path: /health

```


Let's test the customer service:

> Be patient, some times it takes a bit for the service mesh to be set up... so if you get an error like:
> ```
> **HTTP/1.0 503 Service Unavailable**, wait and try again later ;-)
> ```

```execute-1
curl -v http://customer.atomic-fruit-%userid%.%cluster_subdomain%
```

And have a look to the pods created automagically by knative.

```execute-2
watch oc get pod -n atomic-fruit-%userid%
```

Ctrl+C to stop the watch command.

```execute-2
<ctrl+c>
```