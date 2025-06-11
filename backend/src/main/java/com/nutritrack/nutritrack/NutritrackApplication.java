package com.nutritrack.nutritrack;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class NutritrackApplication {

    public static void main(String[] args) {
        System.out.println("Arrancando aplicación Nutritrack...");
        SpringApplication.run(NutritrackApplication.class, args);
        System.out.println("Aplicación arrancada correctamente.");
    }

}
