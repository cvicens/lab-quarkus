You can easily generate en OpenAPI compliant description of your API and at additionally add a Swagger UI to your app by adding the `openapi` extension as follows.

Let's Ctrl+C to stop the app in `prod` mode.

```execute-1
<ctrl+c>
```

Now add the `openapi` extension

```execute-2
./mvnw quarkus:add-extension -Dextensions="openapi"
```

Try opening this url http://localhost/swagger-ui with a browser you should see something like:

![Swagger UI](./docs/images/swagger-ui.png)

Let's go back to `dev` mode.

```execute-1
./mvnw compile quarkus:dev
```

#### Try creating another Fruit this time with the Swagger UI

Try to create a new fruit, get all and get by season.

Click on **POST /fruit** then click on **Try it out**

> **WARNING:** Don't forget to delete the `id` property when creating a new fruit because `id` is self-generated.

![Create Fruit 1](./docs/images/create-fruit-1.png)

Now click on **Execute** eventually you should get a result similar to this one.

> Pay attention to **Code**, it should be **201**.

![Create Fruit 1](./docs/images/create-fruit-2.png)

