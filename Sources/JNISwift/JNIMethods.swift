import CJNI

#if os(Android)
@discardableResult
@_silgen_name("__android_log_write")
public func androidPrint(_ prio: Int32, _ tag: UnsafePointer<CChar>, _ text: UnsafePointer<CChar>) -> Int32

func print(_ string: String) {
    androidPrint(5, "SwiftJNI", string)
}
#endif

struct InvalidParameters: Error {}

public protocol JavaParameterConvertible {
    typealias JavaMethod = ((JavaParameterConvertible...) throws -> Self)
    static var asJNIParameterString: String { get }
    func toJavaParameter() -> JavaParameter
    static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Self
}

extension Bool: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "z" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Bool {
        return try jni.CallStaticBooleanMethod(methodID, on: javaClass, parameters: args)
    }
}

extension String: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "Ljava/lang/String;" }

    public func toJavaParameter() -> JavaParameter {
        let stringAsObject = jni.NewStringUTF(self)
        return JavaParameter(object: stringAsObject)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> String {
        let jObject = try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: args)
        return jni.GetString(from: jObject)
    }
}

extension Array where Element == JavaParameterConvertible.Type {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, type) -> String in
            return result + type.asJNIParameterString
        })

        return "(" + argumentTypes + ")" + returnType.asJNIParameterString
    }
}

extension Array where Element == JavaParameterConvertible {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, argument) -> String in
            return result + type(of: argument).asJNIParameterString
        })

        return "(" + argumentTypes + ")" + returnType.asJNIParameterString
    }
}

extension String {
    func replacingFullstopsWithSlashes() -> String {
        let replacedCharacters = self.characters.map { ($0 == ".") ? "/" : $0 }
        return String(String.CharacterView(replacedCharacters))
    }
}

public func callStatic<T: JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: JavaParameterConvertible...) throws -> T {

    let methodSignature = arguments.methodSignature(returnType: T.self)
    guard let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature) else { throw InvalidParameters() }

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
