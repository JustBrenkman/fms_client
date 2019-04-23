package com.example.fms_client;

import org.junit.Test;

import fms_server.requests.LoginRequest;
import fms_server.results.PersonsResult;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class PersonsTest {
    private ServerProxy proxy;

    public PersonsTest() {
        proxy = new ServerProxy("http://192.168.1.174:4201");
    }

    @Test
    public void getPersonsTrue() {
        proxy.login(new LoginRequest("sheila", "parker"));
        PersonsResult result = proxy.getPeople();
        assertTrue(result.isSuccess());
    }

    @Test
    public void getPersonsFalse() {
        proxy.authToken = "";
        PersonsResult result = proxy.getPeople();
        assertNull(result);
    }}
