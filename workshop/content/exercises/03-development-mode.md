Let's get you developers confy by adding logging capabilities and showing you how to use hot realoading for local development.

### Running in development mode and enjoy hot reloading

We can run our app in development mode, to do so we have to do as follows:

> **NOTE:** In this case we're using the `dev` profile

```execute-1
./mvnw compile quarkus:dev
```

Now you can enjoy hot reloading, let's add some features.

### Adding log capabilities

You can configure Quarkus logging by setting the following parameters to `./src/main/resources/application.properties`:

```properties
# Enable logging
quarkus.log.console.enable=true
quarkus.log.console.level=DEBUG

# Log level settings
quarkus.log.category."com.redhat.atomic".level=DEBUG
```

```execute-2
cat <<EOF > ./src/main/resources/application.properties
# Enable logging
quarkus.log.console.enable=true
quarkus.log.console.level=DEBUG

# Log level settings
quarkus.log.category."com.redhat.atomic".level=DEBUG
EOF
```

Update `./src/main/java/com/redhat/atomic/fruit/FruitResource.java` with the relevant lines bellow.

```java
...
import org.jboss.logging.Logger; // logging

public class FruitResource {
  Logger logger = Logger.getLogger(FruitResource.class); // logging
  ...

  @GET
  @Produces(MediaType.TEXT_PLAIN)
  public String hello() {
      logger.debug("Hello method is called"); // logging
      return "hello";
  }
...
}
```

```execute-2
cat <<EOF > ./src/main/java/com/redhat/atomic/fruit/FruitResource.java
package com.redhat.atomic.fruit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.jboss.logging.Logger; // logging

@Path("/fruit")
public class FruitResource {
    Logger logger = Logger.getLogger(FruitResource.class); // logging

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
      logger.debug("Hello method is called"); // logging
      return "hello";
    }
}
EOF
```

Let's test again, this time with out restarting our app.

```execute-2
curl http://localhost:8080/fruit
```

This time you should see this log trace:

```sh
2020-03-02 16:58:28,872 DEBUG [com.red.ato.fru.FruitResource] (executor-thread-97) Hello method is called
```

### Adding custom properties

Add the following to the class you want to use your custom property.

```java
...
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/fruit")
public class FruitResource {

  @ConfigProperty(name = "greetings.message")
  String message;
  ...
  @GET
  @Produces(MediaType.TEXT_PLAIN)
  public String hello() {
      logger.debug("Hello method is called"); // logging
      return message;
  }
...
}
```

```execute-2
cat <<EOF > ./src/main/java/com/redhat/atomic/fruit/FruitResource.java
package com.redhat.atomic.fruit;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.jboss.logging.Logger; // logging

import org.eclipse.microprofile.config.inject.ConfigProperty; // properties

@Path("/fruit")
public class FruitResource {
    Logger logger = Logger.getLogger(FruitResource.class); // logging

    @ConfigProperty(name = "greetings.message") // properties
    String message; // properties

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
      logger.debug("Hello method is called with this message: " + message); // logging
      return message;
    }
}
EOF
```

Add the following property to your application.properties.

```properties
# custom properties
greetings.message = hello
```

Apply changes...

```execute-2
cat <<EOF > ./src/main/resources/application.properties
# Enable logging
quarkus.log.console.enable=true
quarkus.log.console.level=DEBUG

# Log level settings
quarkus.log.category."com.redhat.atomic".level=DEBUG

# custom properties
greetings.message = hello
EOF
```

As usual, let's test again with out restarting our app.

```execute-2
curl http://localhost:8080/fruit
```

### Updating the config property

Now, without stopping our application, change the value of `greetings.message` from hello to something different. Save the aplication.propertlies file and try again. This time the result should be different.

```execute-2
sed -i 's/hello/hola/g' ./src/main/resources/application.properties
```

As usual, let's test again with out restarting our app.

```execute-2
curl http://localhost:8080/fruit
```

Now the response should be `hola`.

Return the value of `greetings.message` back to `hello`.

```execute-2
sed -i 's/hola/hello/g' ./src/main/resources/application.properties
```

Finally check all is back to normal.

```execute-2
curl http://localhost:8080/fruit
```