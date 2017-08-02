import CJNI

/// Designed to simplify calling a constructor and methods on a JavaClass
/// Subclass this and add the methods appropriate to the object you are constructing.
open class JNIObject {
    public let javaClass: JavaClass
    public let instance: JavaObject

    public init?(_ className: String, arguments: [JavaParameterConvertible] = []) {
        let className = className.replacingFullstopsWithSlashes()

        guard
            let javaClassLocalRef = jni.FindClass(name: className),
            let javaClass = jni.NewGlobalRef(javaClassLocalRef)
        else {
            assertionFailure("Couldn't find class named \(className)")
            return nil
        }

        self.javaClass = javaClass

        guard
            let instanceLocalRef = try? jni.callConstructor(on: javaClass, arguments: arguments),
            let instance = jni.NewGlobalRef(instanceLocalRef)
        else {
            assertionFailure("Couldn't call constructor of \(className)")
            return nil
        }

        self.instance = instance
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

extension JNI {
    func callConstructor(on targetClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> JavaObject {
        let methodID = try jni.GetMethodID(for: targetClass, methodName: "<init>", methodSignature: arguments.methodSignature(returnType: nil))

        // There's no reason for this to fail if the methodID was correct:
        return jni.NewObject(targetClass: targetClass, methodID, arguments.asJavaParameters())!
    }
}

public extension JNI {
	public func AllocObject(targetClass: JavaClass) -> JavaObject? {
	    let env = self._env
		return env.pointee.pointee.AllocObject(env, targetClass)
	}

	public func NewObject(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: [JavaParameter]) -> JavaObject? {
	    let env = self._env
        var mutableArgs = args
        return env.pointee.pointee.NewObject(env, targetClass, methodID, &mutableArgs)
	}

	public func GetObjectClass(obj: JavaObject) -> JavaClass? {
	    let env = self._env
        let result = env.pointee.pointee.GetObjectClass(env, obj)
        return (result != nil) ? result : .none
	}

}
