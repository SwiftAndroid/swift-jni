import CJNI

struct InvalidParameters: Error {}

extension String {
    func replacingFullstopsWithSlashes() -> String {
        let replacedCharacters = self.characters.map { ($0 == ".") ? "/" : $0 }
        return String(String.CharacterView(replacedCharacters))
    }
}

extension JNI {

    // MARK: Static Methods

    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible]) throws {
        let methodSignature = arguments.methodSignature()

        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
        else { throw InvalidParameters() }

        jni.CallStaticVoidMethod(javaClass: javaClass, method: methodID, parameters: arguments.map { $0.toJavaParameter() })
    }

    public func callStatic<T: JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible]) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)

        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
        else { throw InvalidParameters() }

        let javaParameters = arguments.map { $0.toJavaParameter() }
        return try T.fromStaticMethod(calling: methodID, on: javaClass, args: javaParameters)
    }


    public func callStatic(_ methodName: String, on javaClass: JavaClass, returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = "()L\(objectType.replacingFullstopsWithSlashes());"

        guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature) else {
            throw InvalidParameters()
        }

        return try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: [])
    }


    // MARK: Non-Static Methods

    public func call(_ methodName: String, on object: JavaObject, returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = "()L\(objectType.replacingFullstopsWithSlashes());"

        guard let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature) else {
            throw InvalidParameters()
        }

        return try jni.CallObjectMethod(methodID, on: object, parameters: [])
    }


    public func call(_ methodName: String, on object: JavaObject, with arguments: [JavaParameterConvertible]) throws -> [String] {
        let argumentsSignature = arguments.reduce("", { $0 + type(of: $1).asJNIParameterString })
        let methodSignature = "(" + argumentsSignature + ")" + "[" + String.asJNIParameterString

        guard let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature) else { throw InvalidParameters() }

        let javaParameters = arguments.map { $0.toJavaParameter() }
        let returnedArray = try jni.CallObjectMethod(methodID, on: object, parameters: javaParameters)

        return try jni.GetStrings(from: returnedArray)
    }

}
