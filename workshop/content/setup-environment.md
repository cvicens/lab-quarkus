Before anything le's log in our OpenShift cluster...

```execute
oc login --insecure-skip-tls-verify -u %ocp_username% -p %ocp_password% --server=https://%KUBERNETES_SERVICE_HOST%:%KUBERNETES_SERVICE_PORT%
```

Did you type the command in yourself? If you did, click on the command instead and you will find that it is executed for you. You can click on any command which has the <span class="fas fa-play-circle"></span> icon shown to the right of it, and it will be copied to the interactive terminal and run. If you would rather make a copy of the command so you can paste it to another window, hold down the shift key when you click on the command.

Now let's create a project to deploy our knative services (ksvc).

```execute
oc new-project atomic-fruit-%userid%
```

If you have already created the project you can always set it as default running this command:

```execute
oc project atomic-fruit-%userid%
```