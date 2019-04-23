package com.example.fms_client;

import org.junit.Test;

import fms_server.requests.RegisterRequest;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class RegisterTest {
    ServerProxy proxy;

    public RegisterTest() {
        proxy = new ServerProxy("http://192.168.1.174:4201");
    }

    @Test
    public void testTrueRegister() {
        fms_server.results.RegisterResult result = proxy.register(new RegisterRequest("Register", "ix002225", "example@example.com", "Test", "Test", "f"));
        String auth = result.getAuthToken();
        assertTrue(result.isSuccess() && auth != null);
    }

    @Test
    public void testFalseRegister() {
        // Tests false input
        fms_server.results.RegisterResult result = proxy.register(new RegisterRequest(null, "ix002225", null, "Test", "Test", "f"));
        String auth = result.getAuthToken();
        assertTrue(!result.isSuccess() && auth == null);
    }

    @Test
    public void testFalseMultipleRegister() {
        // Makes sure we can't register the same person twice
        fms_server.results.RegisterResult result1 = proxy.register(new RegisterRequest("Register1", "ix002225", "example1@example.com", "Test", "Test", "f"));
        fms_server.results.RegisterResult result2 = proxy.register(new RegisterRequest("Register1", "ix002225", "example1@example.com", "Test", "Test", "f"));
        assertFalse(result2.isSuccess());
    }
}
