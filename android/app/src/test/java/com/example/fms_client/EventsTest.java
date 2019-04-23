package com.example.fms_client;

import org.junit.Test;

import fms_server.requests.LoginRequest;
import fms_server.results.EventsResult;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class EventsTest {
    private ServerProxy proxy;

    public EventsTest() {
        proxy = new ServerProxy("http://192.168.1.174:4201");
    }

    @Test
    public void getEventsTrue() {
        proxy.login(new LoginRequest("sheila", "parker"));
        EventsResult result = proxy.getEvents();
        assertTrue(result.isSuccess());
    }

    @Test
    public void getEventsFalse() {
        proxy.authToken = "";
        EventsResult result = proxy.getEvents();
        assertNull(result);
    }
}
