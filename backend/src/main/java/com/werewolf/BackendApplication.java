package com.werewolf;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.nio.file.Files;
import java.nio.file.Path;

@SpringBootApplication
public class BackendApplication {

	public static void main(String[] args) {
		String dotenvDirectory = Files.exists(Path.of(".env")) ? "./" : "./backend";

		Dotenv dotenv = Dotenv.configure()
				.directory(dotenvDirectory)
				.ignoreIfMissing()
				.load();

		dotenv.entries().forEach(entry ->
				System.setProperty(entry.getKey(), entry.getValue())
		);

		SpringApplication.run(BackendApplication.class, args);
	}
}
