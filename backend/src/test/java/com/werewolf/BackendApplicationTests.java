package com.werewolf;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
/**
 * disabled to avoid context startup failure.
 * requires running mysql or testcontainers config to pass.
 * enable only for full integration checks.
 */
@Disabled
@SpringBootTest
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

}
