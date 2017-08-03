import CJNI

struct InvalidMethodID: Error {}

extension JNI {
    // MARK: Static Methods

    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        try jni.CallStaticVoidMethod(javaClass: javaClass, method: methodID, parameters: arguments.asJavaParameters())
    }

    public func callStatic<T: JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        return try T.fromStaticMethod(calling: methodID, on: javaClass, args: arguments.asJavaParameters())
    }

    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = arguments.methodSignature(customReturnType: "L" + objectType + ";")
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: arguments.asJavaParameters())
    }

    // MARK: Instance/Object Methods

    public func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallVoidMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }

    public func call<T: JavaParameterConvertible>(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try T.fromMethod(calling: methodID, on: object, args: arguments.asJavaParameters())
    }

    public func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = arguments.methodSignature(customReturnType: "L" + objectType + ";")
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }

    public func call(_ methodName: String, on object: JavaObject, with arguments: [JavaParameterConvertible]) throws -> [String] {
        let methodSignature = arguments.methodSignature(customReturnType: "[" + String.asJNIParameterString)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)
        let returnedArray = try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())

        return try jni.GetStrings(from: returnedArray)
    }
}
