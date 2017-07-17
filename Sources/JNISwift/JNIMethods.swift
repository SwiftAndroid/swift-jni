import CJNI

protocol JavaParameterConvertible {
    typealias JavaMethod = ((JavaParameterConvertible...) throws -> Self)
    static var asJNIParameterString: String { get }
    func toJavaParameter() -> JavaParameter
    static func fromStaticMethod(calling: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) -> Self
}

extension Bool: JavaParameterConvertible {
    static var asJNIParameterString: String { return "z" }

    func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    static func fromStaticMethod(calling: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) -> Bool {
        return true // jni.CallStaticBooleanMethod(nil, nil, args) == 1
    }
}

struct InvalidParameters: Error {}

extension Array where Element == JavaParameterConvertible {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, argument) -> String in
            return result + type(of: argument).asJNIParameterString
        })

        return "(" + argumentTypes + ")" + returnType.asJNIParameterString
    }
}

func javaStaticMethod<T: JavaParameterConvertible>(_ method: String, on javaClass: JavaClass, arguments: JavaParameterConvertible...) throws -> T {

    let methodSignature = arguments.methodSignature(returnType: T.self)
    guard let methodID = jni.GetStaticMethodID(javaClass: javaClass, methodName: method, methodSignature: methodSignature) else { throw InvalidParameters() }

    let javaParameters = arguments.map { $0.toJavaParameter() }
    return T.fromStaticMethod(calling: methodID, on: javaClass, args: javaParameters)
}


func callMyJavaStaticMethod() throws -> Bool {
    let obj = JavaObject.allocate(bytes: 1, alignedTo: 1)
    return try javaStaticMethod("asd", on: obj, arguments: true)
}


extension Array where Element == JavaParameterConvertible.Type {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, type) -> String in
            return result + type.asJNIParameterString
        })

        return "(" + argumentTypes + ")" + returnType.asJNIParameterString
    }
}

func javaStaticMethod<T: JavaParameterConvertible>(_ method: JavaMethodID, on javaClass: JavaClass, parameterTypes: [JavaParameterConvertible.Type]) throws -> (T.JavaMethod) {

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

        return T.fromStaticMethod(calling: method, on: javaClass, args: javaParameters)
    }
}

 // func lol() throws -> Bool {
 //     let obj = JavaObject.allocate(bytes: 1, alignedTo: 1)
 //     let myFunc: Bool.JavaMethod = try javaStaticMethod("asd", on: obj, parameterTypes: [Bool.self])
 //     return try myFunc(true)
 // }
