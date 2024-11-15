package com.nomus.m2m.controller;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.nomus.m2m.main.TlsServer;

@WebListener
public class StarterServlet implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
    	TlsServer.startService();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    	TlsServer.stopService();
    }

}
