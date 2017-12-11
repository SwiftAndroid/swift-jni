//
//  JavaCallableClass.swift
//  JNI
//
//  Created by Geordie Jay on 15.08.17.
//

/// Designed to simplify calling a constructor and methods on a JavaClass
/// Subclass this and add the methods appropriate to the object you are constructing.
open class JavaCallableClass {
    public let instance: JavaObject

    public required init?(_ arguments: JavaParameterConvertible...) throws {
        instance = try type(of: self).newInstance(arguments)
    }

    public func call(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.call(methodName, on: instance, arguments: arguments)
    }

    public func call<T: JavaParameterConvertible>(methodName: String, arguments: [JavaParameterConvertible] = []) throws -> T {
        return try jni.call(methodName, on: instance, arguments: arguments)
    }

    deinit { jni.DeleteGlobalRef(globalRef: instance) }
}

// Static methods / variables:
extension JavaCallableClass {
    open static var javaClassName: String { return "" }
    open static var javaClass: JavaClass = try! findJavaClass()

    static func findJavaClass() throws -> JavaObject {
        let javaClassLocalRef = try jni.FindClass(name: javaClassName)
        return jni.NewGlobalRef(javaClassLocalRef)
    }

    static func newInstance(_ arguments: [JavaParameterConvertible]) throws -> JavaObject {
        let instanceLocalRef = try jni.callConstructor(on: javaClass, arguments: arguments)
        return jni.NewGlobalRef(instanceLocalRef)
    }

    public static func call(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.callStatic(methodName, on: javaClass, arguments: arguments)
    }
}

extension JNI {
    func callConstructor(on targetClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> JavaObject {
        // Note, we do NOT use `jni.GetMethodID` here, because that takes an _object_ and returns the method on its
        // class. Here we want to find the *instance* method on `targetClass` called "<init>", because Java Classes
        // are *instances* of the class `java.lang.class`!):
        let env = _env
        let methodID = env.pointee.pointee.GetMethodID(env, targetClass, "<init>", arguments.methodSignature(returnType: nil))
        try checkAndThrowOnJNIError()

        return try jni.NewObject(targetClass: targetClass, methodID!, arguments.asJavaParameters())
    }
}
