import CJNI

struct InvalidMethodID: Error {}

extension JNI {
    // MARK: Static Methods

    public func callStatic(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws {
        let methodSignature = arguments.methodSignature(returnType: nil)
        let methodID = try jni.GetStaticMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)

        try jni.CallStaticVoidMethod(javaClass: javaClass, method: methodID, parameters: arguments.asJavaParameters())
    }

    public func callStatic<T: JavaInitializableFromMethod & JavaParameterConvertible>(_ methodName: String, on javaClass: JavaClass, arguments: [JavaParameterConvertible] = []) throws -> T {
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

    public func call<T: JavaInitializableFromMethod & JavaParameterConvertible>(_ methodName: String, on object: JavaObject, arguments: [JavaParameterConvertible] = []) throws -> T {
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

// --------------------------------------------------------------------------------------------------------------------
// Lower-level implementations
// --------------------------------------------------------------------------------------------------------------------


// MARK: Getting Method IDs

extension JNI {
    public func GetMethodID(for object: JavaObject, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let _env = self._env
        let objectClass = _env.pointee.pointee.GetObjectClass(_env, object)
        try checkAndThrowOnJNIError()

        let result = _env.pointee.pointee.GetMethodID(_env, objectClass!, methodName, methodSignature)
        _env.pointee.pointee.DeleteLocalRef(_env, objectClass)
        try checkAndThrowOnJNIError()

        return result!
    }

    public func GetStaticMethodID(for javaClass: JavaClass, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let _env = self._env
        guard let result = _env.pointee.pointee.GetStaticMethodID(_env, javaClass, methodName, methodSignature) else {
            throw InvalidMethodID()
        }

        try checkAndThrowOnJNIError()
        return result
    }
}

// MARK: Call instance methods

extension JNI {
    public func CallVoidMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws {
        let _env = self._env
        var methodArgs = parameters
        _env.pointee.pointee.CallVoidMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
    }

    public func CallBooleanMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaBoolean {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallBooleanMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallIntMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaInt {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallIntMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallFloatMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaFloat {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallFloatMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallInt64Method(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaLong {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallLongMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallDoubleMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaDouble {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallDoubleMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallObjectMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaObject {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallObjectMethod(_env, object, method, &methodArgs)!
        try checkAndThrowOnJNIError()
        return result
    }
}


// MARK: Static methods

extension JNI {
    public func CallStaticObjectMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaObject {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticObjectMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result! // we checked for error in the line above
    }

    public func CallStaticBooleanMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> Bool {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticBooleanMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result == true
    }

    public func CallStaticIntMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaInt {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticIntMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallStaticInt64Method(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaLong {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticLongMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallStaticFloatMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaFloat {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticFloatMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallStaticDoubleMethod(_ method: JavaMethodID, on javaClass: JavaClass, parameters: [JavaParameter]) throws -> JavaDouble {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticDoubleMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallStaticBooleanMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) throws -> JavaBoolean {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallStaticBooleanMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
        return result
    }

    public func CallStaticVoidMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) throws {
        let _env = self._env
        var methodArgs = parameters
        _env.pointee.pointee.CallStaticVoidMethodA(_env, javaClass, method, &methodArgs)
        try checkAndThrowOnJNIError()
    }
}
