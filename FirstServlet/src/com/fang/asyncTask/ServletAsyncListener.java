package com.fang.asyncTask;

import javax.servlet.AsyncContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.ArrayList;
import java.util.List;

@WebListener()
public class ServletAsyncListener implements ServletContextListener {

    private List<AsyncContext> asyncContexts=new ArrayList<>();


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        servletContextEvent.getServletContext().setAttribute("asyncs",asyncContexts);
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {

                    Thread.sleep(1000);

                    synchronized (asyncContexts){

                        double num=Math.random()*10;

                        for(AsyncContext ctx:asyncContexts){
                            ctx.getResponse().getWriter().print(num);
                            ctx.complete();
                        }
                        asyncContexts.clear();

                    }
                }catch (Exception e){
                    throw new RuntimeException(e);
                }
            }
        }).start();


    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
