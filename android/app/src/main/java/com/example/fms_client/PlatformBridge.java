package com.example.fms_client;

import fms_server.requests.LoginRequest;
import fms_server.requests.RegisterRequest;
import fms_server.results.EventsResult;
import fms_server.results.LoginResult;
import fms_server.results.PersonsResult;
import fms_server.results.RegisterResult;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

class PlatformBridge {
    private static final String CHANNEL_NAME = "fms_client/";
    private static final String CHANNEL_SERVER = "fms_client/serverProxy";
    private static final String CHANNEL_CALLBACKS = "fms_client/callbacks";
    private MethodChannel _platform;
    private MethodChannel _callbacks;
    private ServerProxy proxy;

    PlatformBridge(FlutterView flutterView) {
        _callbacks = new MethodChannel(flutterView, CHANNEL_CALLBACKS);
        new MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "syncData":
                            result.success(true);
                            break;
                        case "getEvents":
                            EventsResult result4 = proxy.getEvents();
                            triggerCallback("getEvents", result4);
                            result.success(2);
                            break;
                        case "getPeople":
                            PersonsResult result1 = proxy.getPeople();
                            triggerCallback("getPeople", result1);
                            result.success(true);
                            break;
                        case "register":
                            RegisterResult result2 = proxy.register(new RegisterRequest(call.argument("username"), call.argument("password"), call.argument("email"), call.argument("firstName"), call.argument("lastName"), call.argument("gender")));
                            triggerCallback("register", result2);
                            result.success(true);
                            break;
                        case "login":
                            LoginResult result3 = proxy.login(new LoginRequest(call.argument("username"), call.argument("password")));
                            triggerCallback("login", result3);
                            result.success(true);
                        case "setServerInfo":
                            proxy = new ServerProxy(call.argument("server") + ":" + call.argument("port"));
                            result.success(true);
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    // Triggers a callback
    public void triggerCallback(String method, Object...args) {
        _callbacks.invokeMethod(method, args);
    }

    public ServerProxy getProxy() {
        return proxy;
    }
}
