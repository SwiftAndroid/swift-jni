import CJNI
import Dispatch

/// Designed to simplify calling a constructor and methods on a JavaClass
/// Subclass this and add the methods appropriate to the object you are constructing.
open class JNIObject {
    open class var className: String {
        return "java.lang.object"
    }

    public class var javaClass: JavaClass {
        return DispatchQueue.main.sync {
            let javaClassLocalRef = try! jni.FindClass(name: className.replacingFullstopsWithSlashes())
            try! checkAndThrowOnJNIError()
            return jni.NewGlobalRef(javaClassLocalRef)!
        }
    }

    public let instance: JavaObject

    required public init(_ instance: JavaObject) throws {
        guard let globalInstanceRef = jni.NewGlobalRef(instance) else {
            throw Error.couldntCreateGlobalRef
        }

        try checkAndThrowOnJNIError()
        self.instance = globalInstanceRef
    }

    convenience public init(_ className: String, arguments: [JavaParameterConvertible] = []) throws {
        let className = className.replacingFullstopsWithSlashes()
        let javaClassLocalRef = try jni.FindClass(name: className)

        guard let instanceLocalRef = try jni.callConstructor(on: javaClassLocalRef, arguments: arguments) else {
            throw Error.couldntCallConstructor
        }

        try self.init(instanceLocalRef)
    }

    deinit {
        jni.DeleteGlobalRef(instance)
    }

    public func call(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.call(methodName, on: self.instance, arguments: arguments)
    }

    public func call<T: JavaInitializableFromMethod & JavaParameterConvertible>(
        methodName: String,
        arguments: [JavaParameterConvertible] = []
    ) throws -> T {
        return try jni.call(methodName, on: self.instance, arguments: arguments)
    }

    public static func callStatic(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.callStatic(methodName, on: self.javaClass, arguments: arguments)
    }

    public static func callStatic<T: JavaInitializableFromMethod & JavaParameterConvertible>(
        methodName: String,
        arguments: [JavaParameterConvertible] = []
    ) throws -> T {
        return try jni.callStatic(methodName, on: self.javaClass, arguments: arguments)
    }
}

extension JNIObject {
    enum Error: Swift.Error {
        case couldntCreateGlobalRef
        case couldntCallConstructor
    }
}

extension JNI {
    func callConstructor(on targetClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> JavaObject? {
        let methodID = _env.pointee.pointee.GetMethodID(_env, targetClass, "<init>", arguments.methodSignature(returnType: nil))
        try checkAndThrowOnJNIError()

        return try jni.NewObject(targetClass: targetClass, methodID!, arguments.asJavaParameters())
    }
}

public extension JNI {
    func NewObject(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: [JavaParameter]) throws -> JavaObject? {
        let env = self._env
        var mutableArgs = args
        let newObject = env.pointee.pointee.NewObject(env, targetClass, methodID, &mutableArgs)
        try checkAndThrowOnJNIError()

        return newObject
    }

    func GetObjectClass(obj: JavaObject) throws -> JavaClass {
        let env = self._env
        let result = env.pointee.pointee.GetObjectClass(env, obj)
        try checkAndThrowOnJNIError()
        return result!
    }
}
