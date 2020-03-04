### Moving to Eclipse Che

#### Create a Workspace

Select Stack `Java 11 Maven`

Change app repo and name

Click on `Create and Open`

![Create Java 11 Maven Workspace](./docs/images/che-create-workspace-1.png)

You can also click [here](https://che-crw.apps.cluster-kharon-688a.kharon-688a.open.redhat.com/f?url=https://github.com/cvicens/atomic-fruit-service) to automatically create a workspace with all you need.

#### [OPTIONAL] Add `oc` CLI

Open a terminal to container `maven`

Create a `bin` dir in `${CHE_PROJECTS_ROOT}` (default dir).

```sh
mkdir ${CHE_PROJECTS_ROOT}/bin
export PATH=${CHE_PROJECTS_ROOT}/bin:$PATH
curl -OL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.1.14/openshift-client-linux-4.1.14.tar.gz
tar xvzf openshift-client-linux-4.1.14.tar.gz -C ${CHE_PROJECTS_ROOT}/bin oc
oc version
rm openshift-client-linux-4.1.14.tar.gz
```

#### Run our app in `dev` mode but using our custom profile `che`

Open a terminal to container `maven` if not already done. It's two step action, first go to `Terminal`->`Open Terminal in specific container`.

![Open Terminal in Che 1](./docs/images/open-terminal-che-1.png)

Then select the container, in our case `maven`.

![Open Terminal in Che 1](./docs/images/open-terminal-che-2.png)

Finally be sure you're inside our project folder, if you followed intructions to the letter `${CHE_PROJECTS_ROOT}/atomic-fruit-service`.

> **WARNING:** If you experience this error just use `mvn` instead of `./mvnw`
> 
> ```sh
> [ERROR] Unknown lifecycle phase "/home/user/.m2". ...
> ```
>

```sh
mvn compile quarkus:dev -Dquarkus.profile=che
```

If everything is fine you should get no errors and receive a couple of notifications as in the next pic.

![Open Terminal in Che 1](./docs/images/run-dev-mode-in-che-1.png)

One of the notifications is related to the debugging port `5005` the other to the port where our app is listening inside the container `8080`. Let's concentrate on the latter, if you click `yes` this port (internal so far) will be exposed so that we can send request from the internet, please do so.

![Open Terminal in Che 1](./docs/images/run-dev-mode-in-che-2.png)

Now we you should have received another notification related to the same port, this time announcing that the redirection is in place. Click on `Open Link` this will open an internal browser window to our app default web page.

![Open Terminal in Che 1](./docs/images/run-dev-mode-in-che-3.png)

Click on the upper right corner icon so that you can open the link in a new tab, then add `/swagger-ui`  to the url and as we did before test the API.

![Open Terminal in Che 1](./docs/images/run-dev-mode-in-che-4.png)

> ***Did you notice*** that you didn't need to use `port-forward` and everything worked properly. This is because the `che` profile points to the dabase using a the DNS name of the database including the namespace where it is running into.
>
> **WARNING:** Of course if you have deployed the database in a different namespace you should modify property `%che.quarkus.datasource.url` accordingly.

```properties
%che.quarkus.datasource.url = jdbc:postgresql://my-database.atomic-fruit:5432/my_data
```

