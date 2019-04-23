package com.example.fms_client;

import com.google.gson.Gson;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.annotation.Nullable;

import fms_server.requests.LoginRequest;
import fms_server.requests.RegisterRequest;
import fms_server.requests.Request;
import fms_server.results.EventsResult;
import fms_server.results.LoginResult;
import fms_server.results.PersonsResult;
import fms_server.results.RegisterResult;
import fms_server.results.Result;

public class ServerProxy {
    private String server;
    private Gson gson;
    public String authToken;

    ServerProxy(String serverURL) {
        this.server = serverURL;

        gson = new Gson();
    }

    public LoginResult login(LoginRequest request) {
        LoginResult result = null;
        try {
            result = convertToRequest(doPost("/user/login", request, null), LoginResult.class);
            if (result.isSuccess())
                this.authToken = result.getAuthToken();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public RegisterResult register(RegisterRequest request) {
        RegisterResult result = null;
        try {
            result = convertToRequest(doPost("/user/register", request, null), RegisterResult.class);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public PersonsResult getPeople() {
        PersonsResult result = null;
        try {
            result = convertToRequest(doGet("/person", authToken), PersonsResult.class);
        } catch (IOException e) {
            e.printStackTrace();
            return new PersonsResult(false, "Not authorized", null);
        }
        return result;
    }

    public EventsResult getEvents() {
        EventsResult result = null;
        try {
            result = convertToRequest(doGet("/event", authToken), EventsResult.class);
        } catch (Exception e) {
//            e.printStackTrace();
            return new EventsResult(false, "Not authorized", null);
        }
        return result;
    }













    private <T extends Request> InputStream doPost(String url, T request, @Nullable String authToken) {
        System.out.println("Doing a POST " + url);
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(server + url).openConnection();
            connection.setReadTimeout(5000);
            connection.setRequestMethod("POST");

            if (authToken != null) {
                connection.setRequestProperty("auth_token", authToken);
            }

            connection.setDoOutput(true);
            connection.connect();

            try (OutputStream requestBody = connection.getOutputStream()) {
                requestBody.write(new Gson().toJson(request).getBytes());
            }
            return connection.getInputStream();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private <T extends Request> InputStream doGet(String url, @Nullable String authToken) {
        System.out.println("Doing a GET " + url);
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(server + url).openConnection();
            connection.setReadTimeout(5000);
            connection.setRequestMethod("GET");

            if (authToken != null) {
                connection.setRequestProperty("auth_token", authToken);
            }

            connection.setDoOutput(true);
            connection.connect();

            System.out.println(connection.getResponseCode());

            return connection.getInputStream();

        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }

    private <T extends Result> T convertToRequest(InputStream stream, Class<T> tClass) throws IOException {
        if (stream == null)
            return null;
        return gson.fromJson(byteArrayToJSONString(readAllBytes(stream)), tClass);
    }

    private String byteArrayToJSONString(byte[] data) {
        return new String(data);
    }

    private static byte[] readAllBytes(InputStream inputStream) throws IOException {
        final int bufLen = 4 * 0x400; // 4KB
        byte[] buf = new byte[bufLen];
        int readLen;
        IOException exception = null;

        try {
            try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                while ((readLen = inputStream.read(buf, 0, bufLen)) != -1)
                    outputStream.write(buf, 0, readLen);

                return outputStream.toByteArray();
            }
        } catch (IOException e) {
            exception = e;
            throw e;
        } finally {
            if (exception == null) inputStream.close();
            else try {
                inputStream.close();
            } catch (IOException e) {
                exception.addSuppressed(e);
            }
        }
    }
}
