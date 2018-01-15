import CJNI

public struct CreateNewObjectForConstructorError: Error {}
public struct ConstructorError: Error {}

/// Designed to simplify calling a constructor and methods on a JavaClass
/// Subclass this and add the methods appropriate to the object you are constructing.
open class JNIObject {
    public let javaClass: JavaClass
    public let instance: JavaObject

    public init(_ className: String, arguments: [JavaParameterConvertible] = []) throws {
        let className = className.replacingFullstopsWithSlashes()

        let javaClassLocalRef = try jni.FindClass(name: className)

        let javaClass = jni.NewGlobalRef(javaClassLocalRef)
        try checkAndThrowOnJNIError()
        self.javaClass = javaClass!

        guard
            let instanceLocalRef = try jni.callConstructor(on: self.javaClass, arguments: arguments),
            let instance = jni.NewGlobalRef(instanceLocalRef)
        else {
            throw ConstructorError()
        }

        self.instance = instance
    }

    deinit {
        jni.DeleteGlobalRef(instance)
        jni.DeleteGlobalRef(javaClass)
    }

    public func call(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.call(methodName, on: self.instance, arguments: arguments)
    }

    public func call<T: JavaParameterConvertible>(methodName: String, arguments: [JavaParameterConvertible] = []) throws -> T {
        return try jni.call(methodName, on: self.instance, arguments: arguments)
    }

    public func callStatic(methodName: String, arguments: [JavaParameterConvertible] = []) throws {
        try jni.callStatic(methodName, on: self.javaClass, arguments: arguments)
    }
}

extension JNIObject {
    enum Error: Swift.Error {
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
	public func NewObject(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: [JavaParameter]) throws -> JavaObject? {
	    let env = self._env
        var mutableArgs = args
        let newObject = env.pointee.pointee.NewObject(env, targetClass, methodID, &mutableArgs)
        try checkAndThrowOnJNIError()

        return newObject
	}

	public func GetObjectClass(obj: JavaObject) throws -> JavaClass {
	    let env = self._env
        let result = env.pointee.pointee.GetObjectClass(env, obj)
        try checkAndThrowOnJNIError()
        return result!
	}
}
