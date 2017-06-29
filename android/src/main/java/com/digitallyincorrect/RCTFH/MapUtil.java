package com.digitallyincorrect.RCTFH;

/*
  By mfmendiola @
  MapUtil exposes a set of helper methods for working with
  ReadableMap (by React Native), Map<String, Object>, and JSONObject.
 */

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.JavaOnlyMap;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.feedhenry.sdk.FHResponse;

import org.json.fh.JSONException;

import java.util.Iterator;


public class MapUtil {

    public static org.json.fh.JSONObject toJSONObject(ReadableMap readableMap) throws JSONException {
        org.json.fh.JSONObject result = new org.json.fh.JSONObject();

        ReadableMapKeySetIterator iterator = readableMap.keySetIterator();

        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            ReadableType type = readableMap.getType(key);

            switch (type) {
                case Null:
                    result.put(key, "");
                    break;
                case Boolean:
                    result.put(key, readableMap.getBoolean(key));
                    break;
                case Number:
                    result.put(key, readableMap.getDouble(key));
                    break;
                case String:
                    result.put(key, readableMap.getString(key));
                    break;
                case Map:
                    result.put(key, MapUtil.toJSONObject(readableMap.getMap(key)));
                    break;
                case Array:
                    result.put(key, ArrayUtil.toJSONArray(readableMap.getArray(key)));
                    break;
            }
        }

        return result;
    }

    public static Object toWritableObject(FHResponse res) throws JSONException {
        Object result = null;
        if (res.getJson() != null) {
            return toWritableMap(res.getJson());
        } else if (res.getArray() != null) {
            return toWritableArray(res.getArray());
        }

        return null;
    }

    public static WritableMap toWritableMap(org.json.fh.JSONObject jsonObject) throws JSONException {
        WritableMap   result = Arguments.createMap();

        Iterator<String> iterator = jsonObject.keys();

        while (iterator.hasNext()) {
            String key = iterator.next();
            Object value = jsonObject.get(key);

            if (value != null) {
                if (value instanceof Boolean) {
                    result.putBoolean(key, (Boolean) value);
                } else if (value instanceof Integer) {
                    result.putInt(key, (Integer) value);
                } else if (value instanceof Double) {
                    result.putDouble(key, (Double) value);
                } else if (value instanceof Float) {
                    result.putDouble(key, (Double) value);
                } else if (value instanceof String) {
                    result.putString(key, (String) value);
                } else if (value instanceof org.json.fh.JSONObject) {
                    if (value instanceof org.json.fh.JSONArray) {
                        result.putArray(key, toWritableArray((org.json.fh.JSONArray) value));
                    } else {
                        result.putMap(key, toWritableMap((org.json.fh.JSONObject) value));
                    }
                } else {
                    result.putString(key, value.toString());
                }
            } else {
                result.putNull(key);
            }
        }

        return result;
    }

    public static WritableArray toWritableArray(org.json.fh.JSONArray jsonArray) throws JSONException {
        WritableArray result = Arguments.createArray();

        for (int i = 0; i < jsonArray.length(); i++) {
            Object value =  jsonArray.get(i);
            if (value != null) {
                if (value instanceof Boolean) {
                    result.pushBoolean((Boolean) value);
                } else if (value instanceof Integer) {
                    result.pushInt((Integer) value);
                } else if (value instanceof Double) {
                    result.pushDouble((Double) value);
                } else if (value instanceof Float) {
                    result.pushDouble((Double) value);
                } else if (value instanceof String) {
                    result.pushString((String) value);
                } else if (value instanceof org.json.fh.JSONObject) {
                    if (value instanceof org.json.fh.JSONArray) {
                        result.pushArray(toWritableArray((org.json.fh.JSONArray) value));
                    } else {
                        result.pushMap(toWritableMap((org.json.fh.JSONObject) value));
                    }
                }  else {
                    result.pushString(value.toString());
                }
            }
        }

        return result;
    }

    public static org.json.JSONObject toJSONObject(FHResponse response) throws org.json.JSONException {
        if (response == null || response.getJson() == null) {
            return null;
        }

        return new org.json.JSONObject(response.getRawResponse());
    }
}
