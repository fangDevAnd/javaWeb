package com.fang.asyncTask;

import javax.servlet.AsyncContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/loading"},
   asyncSupported = true
)
public class AsyncServlet extends HttpServlet {

    private List<AsyncContext> asyncContexts;

    @Override
    public void init() throws ServletException {
        super.init();

        asyncContexts= (List<AsyncContext>) getServletContext().getAttribute("asyncs");

    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
    AsyncContext ctx=req.startAsync();
        synchronized (asyncContexts){
        asyncContexts.add(ctx);
        }
    }
}
