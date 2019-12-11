package com.fang.mvp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/logcat")
public class LogcatPrint extends HttpServlet {
		
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String exceptionString =req.getParameter("exception");
		
		System.out.println("客户端出现错误"+exceptionString);
		
	
	}
	
}
