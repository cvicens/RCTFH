package com.digitallyincorrect.RCTFH;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;

import com.facebook.react.bridge.WritableMap;
import com.feedhenry.sdk.FH;
import com.feedhenry.sdk.FHActCallback;
import com.feedhenry.sdk.FHHttpClient;
import com.feedhenry.sdk.FHResponse;
import com.feedhenry.sdk.api.FHAuthRequest;
import com.feedhenry.sdk.api.FHCloudRequest;

import org.json.fh.JSONException;
import org.json.fh.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.message.BasicHeader;

public class RCTFHModule extends ReactContextBaseJavaModule {
    private final static String FH_INIT_TAG = "FHInit";
    private final static String FH_CLOUD_TAG = "FHCloud";
    private final static String FH_AUTH_TAG = "FHAuth";

    public RCTFHModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }


    @Override
    public String getName() {
        return "FH";
    }

    @ReactMethod
    public void init(final Promise promise){
        Log.d(FH_INIT_TAG, RCTFHModule.class.getCanonicalName());

        try {
            FH.init(this.getReactApplicationContext(), new FHActCallback() {
                public void success(FHResponse pRes) {
                    // Initialisation is now complete, you can now make FHActRequest's
                    Log.d(FH_INIT_TAG, "SDK initialised OK");
                    promise.resolve("SUCCESS");
                }

                public void fail(FHResponse pRes) {
                    // Init failed
                    Log.e(FH_INIT_TAG, pRes.getErrorMessage(), pRes.getError());
                    promise.reject("sdk_init_failed", pRes.getErrorMessage());
                }
            });
        } catch (Throwable e) {
            promise.reject("sdk_init_failed", e.getLocalizedMessage());
        }
    }

    @ReactMethod
    public void auth(final String authPolicy, final String username, final String password, final Promise promise){
        if (authPolicy == null || authPolicy.length() <= 0 ||
            username == null || username.length() <= 0 ||
            password == null && password.length() <= 0) {
            promise.reject(FH_AUTH_TAG, new Throwable("Wrong params"));
        }

        try{
            FHAuthRequest authRequest = FH.buildAuthRequest(authPolicy, username, password);
            authRequest.executeAsync(new FHActCallback() {

                @Override
                public void success(FHResponse res) {
                    Log.d(FH_AUTH_TAG, "auth call succeeded check status");
                    JSONObject resData = res.getJson();

                    Log.d(FH_AUTH_TAG, "raw response " + resData);
                    if (resData.getInt("responseStatusCode") != 200) {
                        String errorMessage = "Authentication failed.";
                        /*WritableMap userInfo = Arguments.createMap();
                        userInfo.putString("NSLocalizedDescriptionKey", "Operation was unsuccessful.");
                        userInfo.putString("NSLocalizedFailureReasonErrorKey", "Authentication failed.");
                        userInfo.putString("NSLocalizedRecoverySuggestionErrorKey", "Please verify credentials and try again.");*/

                        promise.reject("auth_call_failed", errorMessage);

                    } else {
                        Log.d(FH_AUTH_TAG, "auth call authentication succeeded");
                        promise.resolve(MapUtil.toWritableMap(resData));
                    }
                }

                @Override
                public void fail(FHResponse res) {
                    Log.d(FH_AUTH_TAG, "Login operation fail " + res.getRawResponse());
                }
            });
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    // TODO  final ReadableArray headers
    @ReactMethod
    public void cloud(final ReadableMap options, final Promise promise){
        Log.i(FH_CLOUD_TAG, RCTFHModule.class.getCanonicalName());
        Log.i(FH_CLOUD_TAG, "options: " + options);

        if (options == null) {
            promise.reject("ERROR", new Throwable("Wrong params, no options"));
            return;
        }

        String path = options.hasKey("path") ? options.getString("path") : null;
        String method = options.hasKey("method") ? options.getString("method") : null;
        String contentType = options.hasKey("contentType") ? options.getString("contentType") : "application/json";
        Integer timeout = null;
        try {
            timeout = options.hasKey("timeout") ? options.getInt("timeout") : null;
        } catch (Throwable t) {
            promise.reject("ERROR", new Throwable("Wrong params, timeout wrong type or invalid value"));
            return;
        }

        Header[] headers = null;
        ArrayList<Header> _headers = new ArrayList<>();
        if (options.hasKey("headers")) {
            for (ReadableMapKeySetIterator i = options.getMap("headers").keySetIterator(); i.hasNextKey();) {
                String key = i.nextKey();
                String value = options.getMap("headers").getString(key);
                _headers.add(new BasicHeader(key, value));
            }

        }
        _headers.add(new BasicHeader("contentType", contentType));
        headers = new BasicHeader[_headers.size()];
        for (int i = 0; i < _headers.size(); i++) {
            headers[i] = _headers.get(i);
        }

        JSONObject data = null;
        if (options.hasKey("data")) {
            try {
                data = MapUtil.toJSONObject(options.getMap("data"));
            } catch (JSONException e) {
                Log.e(FH_CLOUD_TAG, e.getLocalizedMessage());
                promise.reject("ERROR", "Wrong params, data");
                return;
            }
        }

        try {
            //build the request object with request path, method, headers and data
            FHCloudRequest request = FH.buildCloudRequest(path, method, headers, data);
            //the request will be executed asynchronously
            request.executeAsync(new FHActCallback() {
                @Override
                public void success(FHResponse res) {
                    //promise.resolve(res.getRawResponse());
                    promise.resolve(MapUtil.toWritableObject(res));
                }

                @Override
                public void fail(FHResponse res) {
                    //the function to execute if the request is failed
                    Log.e(FH_CLOUD_TAG, res.getErrorMessage(), res.getError());
                    promise.reject("cloud_call_failed", res.getErrorMessage());
                }
            });
        } catch (Throwable e) {
            Log.e(FH_CLOUD_TAG, e.getLocalizedMessage());
            promise.reject("cloud_call_failed", e.getLocalizedMessage());
        }

    }

}
