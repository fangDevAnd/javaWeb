package com.fang.day02.aop.jdk;

import org.junit.Test;

public class Snippet {

	@Test
	public void demo01() {
		UserService userService = MyBeanFactory.createServic();
		userService.addUser();
		userService.updateUser();
		userService.deleteUser();
	}
}
