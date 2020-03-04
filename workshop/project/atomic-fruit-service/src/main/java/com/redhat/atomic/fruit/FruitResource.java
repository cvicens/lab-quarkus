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
