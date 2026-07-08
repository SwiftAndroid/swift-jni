# swift-jni

The start of a JNI wrapper for swift-android (later for other platforms too, presumably)

It uses a Swift-like API wherever possible. i.e., GetIntArrayRegion returns [Int], and other JNI methods may take Int as a param instead of jsize etc. Oftentimes however it wouldn't make sense to take or return anything but the raw JNI pointer (e.g. NewIntArray, NewGlobalRef etc.)

The naming has been kept as close to the C-functions as possible, including omiting parameter names, and documenting differences where not immediately obvious. That way the vast majority of documentation is done for us via the JNI docs.

# Usage

Internally the module uses JNI_OnLoad (which could be problematic if the user wants to use their own) to initialise an implicitly unwrapped global, `jni`. 

This global can be then used from Swift code (from any thread) to run standard JNI functions like jni.GetIntArrayRegion(JavaArray), to return an array of Swift `Int`s

See the article here for why (and a bit of how) this project came to be: https://medium.com/@ephemer/using-jni-in-swift-to-put-an-app-into-the-android-play-store-732e542a99dd#.rtviqfdlu
