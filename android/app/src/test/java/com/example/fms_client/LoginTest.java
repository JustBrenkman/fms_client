package com.example.fms_client;

import org.junit.Test;

import fms_server.requests.LoginRequest;
import fms_server.requests.RegisterRequest;
import fms_server.results.LoginResult;
import fms_server.results.RegisterResult;

import static org.junit.Assert.*;

public class LoginTest {
    ServerProxy proxy;

    public LoginTest() {
        proxy = new ServerProxy("http://192.168.1.174:4201");
    }

    @Test
    public void testTrueLogin() {
        LoginResult result = proxy.login(new LoginRequest("sheila", "parker"));
        assertTrue(result.isSuccess());
    }

    @Test
    public void testFalseLogin() {
        LoginResult result = proxy.login(new LoginRequest("rando", "rando"));
        assertFalse(result.isSuccess());
    }
}
