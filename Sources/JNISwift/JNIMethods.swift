import CJNI

struct InvalidParameters: Error {}

public extension JNI {
    public func callStaticJavaMethod<T: JavaParameterConvertible>
        (_ method: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible]) throws -> T {

        guard let methodID = jni.GetStaticMethodID(
            javaClass: javaClass,
            methodName: method,
            methodSignature: arguments.methodSignature(returnType: T.self)
        ) else {
            throw InvalidParameters()
        }

        let javaParameters = arguments.map { $0.toJavaParameter() }

        return T.fromStaticMethod(calling: methodID, on: javaClass, args: javaParameters)
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

            return T.fromStaticMethod(calling: method, on: javaClass, args: javaParameters)
        }
    }
}

