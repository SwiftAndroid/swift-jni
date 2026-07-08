enum SwiftJNIError: Error {
    case invalidMethodID(_ methodSignature: String)
}

public extension JNI {
    // MARK: Static Methods

    func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        try jni.CallStaticVoidMethod(javaClass: javaClass, method: methodID, parameters: arguments.asJavaParameters())
    }

    func callStatic<T: JavaInitializableFromMethod & JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        return try T.fromStaticMethod(calling: methodID, on: javaClass, args: arguments.asJavaParameters())
    }

    func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = arguments.methodSignature(customReturnType: "L" + objectType + ";")
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: arguments.asJavaParameters())
    }

    // MARK: Instance/Object Methods

    func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallVoidMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }

    func call<T: JavaInitializableFromMethod & JavaParameterConvertible>(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws -> T {
        let methodSignature = arguments.methodSignature(returnType: T.self)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try T.fromMethod(calling: methodID, on: object, args: arguments.asJavaParameters())
    }

    func call(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = [], returningObjectType objectType: String) throws -> JavaObject {
        let methodSignature = arguments.methodSignature(customReturnType: "L" + objectType + ";")
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)

        return try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())
    }

    func call(_ methodName: String, on object: JavaObject, with arguments: [JavaParameterConvertible]) throws -> [String] {
        let methodSignature = arguments.methodSignature(customReturnType: "[" + String.asJNIParameterString)
        let methodID = try jni.GetMethodID(for: object, methodName: methodName, methodSignature: methodSignature)
        let returnedArray = try jni.CallObjectMethod(methodID, on: object, parameters: arguments.asJavaParameters())

        return try jni.GetStrings(from: returnedArray)
    }
}

// --------------------------------------------------------------------------------------------------------------------
// Lower-level implementations
// --------------------------------------------------------------------------------------------------------------------


// MARK: Getting Method IDs

public extension JNI {
    func GetMethodID(for object: JavaObject, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let env = self._env
        let objectClass = env.pointee.GetObjectClass(object.asJObject)
        try checkAndThrowOnJNIError()

        let result = env.pointee.GetMethodID(objectClass!, methodName, methodSignature)
        env.pointee.DeleteLocalRef(objectClass?.asJavaObject.asJObject)
        try checkAndThrowOnJNIError()

        return result!
    }

    func GetStaticMethodID(for javaClass: JavaClass, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let env = self._env
        guard let result = env.pointee.GetStaticMethodID(javaClass.asJClass, methodName, methodSignature) else {
            throw SwiftJNIError.invalidMethodID(methodSignature)
        }

        try checkAndThrowOnJNIError()
        return result
    }
}

// MARK: Call instance methods

public extension JNI {
    func CallVoidMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws {
        let env = self._env
        var methodArgs = parameters
        env.pointee.CallVoidMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
    }

    func CallBooleanMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaBoolean {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallBooleanMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallIntMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaInt {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallIntMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallFloatMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaFloat {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallFloatMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallLongMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaLong {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallLongMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallDoubleMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaDouble {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallDoubleMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallObjectMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaObject {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallObjectMethodA(object.asJObject, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result!.asJavaObject
    }
}


// MARK: Static methods

public extension JNI {
    func CallStaticObjectMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaObject {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticObjectMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result!.asJavaObject // we checked for error in the line above
    }

    func CallStaticBooleanMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> Bool {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticBooleanMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result == .true
    }

    func CallStaticIntMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaInt {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticIntMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallStaticLongMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaLong {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticLongMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallStaticFloatMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaFloat {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticFloatMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallStaticDoubleMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaDouble {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticDoubleMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallStaticBooleanMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) throws -> JavaBoolean {
        let env = self._env
        var methodArgs = parameters
        let result = env.pointee.CallStaticBooleanMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    func CallStaticVoidMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) throws {
        let env = self._env
        var methodArgs = parameters
        env.pointee.CallStaticVoidMethodA(javaClass.asJClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
    }
}
