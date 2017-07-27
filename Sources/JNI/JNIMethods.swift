import CJNI

struct InvalidParameters: Error {}

extension JNI {

    // MARK: Static Methods

    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)

        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
        else { throw InvalidParameters() }

        jni.CallStaticVoidMethod(javaClass: javaClass, method: methodID, parameters: arguments.asJavaParameters())
    }

    public func callStatic<T: JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)

        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
        else { throw InvalidParameters() }

        return try T.fromStaticMethod(calling: methodID, on: javaClass, args: arguments.asJavaParameters())
    }


    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {

        let methodSignature = arguments.methodSignature(returnType: objectType)
        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature) else {
            throw InvalidParameters()
        }

        return try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: arguments.asJavaParameters())
    }


    // MARK: Instance/Object Methods

    public func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)

        guard let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature) else {
            throw InvalidParameters()
        }

        return try jni.CallVoidMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }


    public func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {

        let methodSignature = arguments.methodSignature(returnType: objectType)
        guard let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature) else {
            throw InvalidParameters()
        }

        return try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }


    public func call(_ methodName: String, on object: JavaObject, with arguments: [JavaParameterConvertible]) throws -> [String] {
        let argumentsSignature = arguments.reduce("", { $0 + type(of: $1).asJNIParameterString })
        let methodSignature = "(" + argumentsSignature + ")" + "[" + String.asJNIParameterString

        guard let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature) else { throw InvalidParameters() }
        let returnedArray = try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())

        return try jni.GetStrings(from: returnedArray)
    }

}
