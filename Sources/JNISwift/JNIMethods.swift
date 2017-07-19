import CJNI

struct InvalidParameters: Error {}


#if os(Android)
@discardableResult
@_silgen_name("__android_log_write")
public func androidPrint(_ prio: Int32, _ tag: UnsafePointer<CChar>, _ text: UnsafePointer<CChar>) -> Int32

func print(_ string: String) {
    androidPrint(5, "SwiftJNI", string)
}
#endif


public extension JNI {
    public func callStaticJavaMethod<T: JavaParameterConvertible>
        (_ method: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible]) throws -> T {

        guard let methodID = try jni.GetStaticMethodID(
            for: javaClass,
            methodName: method,
            methodSignature: arguments.methodSignature(returnType: T.self)
        ) else {
            throw InvalidParameters()
        }

        let javaParameters = arguments.map { $0.toJavaParameter() }

        return try T.fromStaticMethod(calling: methodID, on: javaClass, args: javaParameters)
    }


    public func getStaticJavaMethod<T: JavaParameterConvertible>(_ method: JavaMethodID, on javaClass: JavaClass, parameterTypes: [JavaParameterConvertible.Type]) throws -> (T.JavaMethod) {

     // guard let methodID = jni.GetStaticMethodID() else { throw Error }

        return { (args: JavaParameterConvertible...) in
            if parameterTypes.count != args.count {
                throw InvalidParameters()
            }

            try args.enumerated().forEach({ arg in
                let (i, element) = arg
                if type(of: element) != parameterTypes[i] {
                    throw InvalidParameters()
                }
            })

            let javaParameters = args.map { $0.toJavaParameter() }

            return try T.fromStaticMethod(calling: method, on: javaClass, args: javaParameters)
        }
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

