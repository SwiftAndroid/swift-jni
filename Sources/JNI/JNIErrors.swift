//
//  JNIErrors.swift
//  JNI
//
//  Created by Geordie Jay on 15.08.17.
//

func checkAndThrowOnJNIError() throws {
    if jni.ExceptionCheck() { throw JNIError() }
}

/// Prints information about the error to the console and clears the pending exception so we can continue making JNI calls
struct JNIError: Error {
    init() {
        jni.ExceptionDescribe()
        jni.ExceptionClear()
    }
}
