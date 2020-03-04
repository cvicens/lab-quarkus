The purpose of this section is generate a sample RESTFul service (Fruit Service). Because we're going to use Quarkus we're going to calle it `Atomic Fruit Service`.

This is sample Fruit service generated from a maven artifact that generates all the needed Java scaffold for a Quarkus Maven app.

> Don't worry although we're not covering Gradle, there's also a Gradle counterpart ;-)

Let's get starting

### Generate the Quarkus app scaffold using a maven archetype

```execute-1
mvn io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION:create \
  -DprojectGroupId="com.redhat.atomic.fruit" \
  -DprojectArtifactId="atomic-fruit-service" \
  -DprojectVersion="1.0-SNAPSHOT" \
  -DclassName="FruitResource" \
  -Dpath="fruit"
```

### Testing different ways of packaging the app

> You must be inside the project folder to run the following commands.

In the upper console...

```execute-1
cd atomic-fruit-service
```

And also in the lower one...

```execute-2
cd atomic-fruit-service
```

### Have a look to the main class

Source is here:

```execute-1
cat src/main/java/com/redhat/atomic/fruit/FruitResource.java
```

You can also have a look here:

```java
package com.redhat.atomic.fruit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/fruit")
public class FruitResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "hello";
    }
}
```
