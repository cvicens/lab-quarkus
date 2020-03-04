Now we're going to test the sample service in two different ways: JVM and Native

#### JVM mode

This mode generates a Quarkus Java jar file.

```execute-1
./mvnw -DskipTests clean package
```

Run the application in JVM mode.

```execute-1
java -jar ./target/atomic-fruit-service-1.0-SNAPSHOT-runner.jar
```

Test from another terminal or a browser, you should receive a `hello` string.

```execute-2
curl http://localhost:8080/fruit
```

Ctrl+C to stop.

```execute-1
<ctrl+c>
```

#### Native Mode [NOT READY, JUMP TO THE NEXT LAB]

This mode generates a Quarkus native binary file.

> **NOTE:** This is huge... now you have a native binary file, no JVM involved.

```execute-1
./mvnw -DskipTests clean package -Pnative
```

Run the application in native mode.

```execute-1
./target/atomic-fruit-service-1.0-SNAPSHOT-runner
```

Test from another terminal or a browser, you should receive a `hello` string.

```execute-2
curl http://localhost:8080/fruit
```

Ctrl+C to stop.

```execute-1
<ctrl+c>
```

