# swift-jni

The start of a JNI wrapper for swift-android (later for other platforms too, presumably)

It uses a Swift-like API wherever possible. i.e., GetIntArrayRegion returns [Int], other params take Int as a param instead of jsize etc. Sometimes the API doesn't make a lot of sense to take or return anything but the raw JNI pointer (e.g. NewIntArray, NewGlobalRef etc.)

The naming should be kept as close to the C-functions as possible, documenting differences where not immediately obvious. That way the vast majority of documentation is done for us via the JNI docs.

# Usage

Internally the module uses JNI_OnLoad (which could be problematic if the user wants to use their own) to create an implicitly unwrapped global `jni`

This can be then used from swift code (from any thread) to run standard JNI functions like jni.GetIntArrayRegion(jarray), to return an array of swift Ints
