import CJNI
// import Dispatch

public var jni: JNI! // this gets set "OnLoad" so should always exist

@_silgen_name("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM>, reserved: UnsafeMutableRawPointer) -> JavaInt {
    guard let localJNI = JNI(jvm: jvm) else {
         fatalError("Couldn't initialise JNI")
    }

    jni = localJNI // set the global for use elsewhere

    //     DispatchQueue.setThreadDetachCallback(JNI_DetachCurrentThread)

    return JNI_VERSION_1_6
}

public func JNI_DetachCurrentThread() {
    _ = jni._jvm.pointee.pointee.DetachCurrentThread(jni._jvm)
}

extension JavaBoolean : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? JavaBoolean(JNI_TRUE) : JavaBoolean(JNI_FALSE)
    }
}

// SwiftJNI Public API
extension JNI {
    public func RegisterNatives(javaClass: JavaClass, methods: [JNINativeMethod]) -> Bool {
        let _env = self._env
		let env = _env.pointee.pointee
        let result = env.RegisterNatives(_env, javaClass, methods, JavaInt(methods.count))
        return (result == 0)
    }

    public func ThrowNew(message: String) {
        let _env = self._env
        let env = _env.pointee.pointee
        _ = env.ThrowNew(_env, env.FindClass(_env, "java/lang/Exception"), message)
    }

    public func GetString(from javaString: JavaString) -> String {
        let _env = self._env
        let chars = _env.pointee.pointee.GetStringUTFChars(_env, javaString, nil)
        let string = String(cString: chars)
        _env.pointee.pointee.ReleaseStringUTFChars(_env, javaString, chars)
        return string
    }

    // MARK: References

    public func NewGlobalRef(object: JavaObject) -> JavaObject? {
        let _env = self._env
        let result = _env.pointee.pointee.NewGlobalRef(_env, object)
        return result
    }

    // MARK: Classes and Methods

    public func FindClass(className: String) -> JavaClass? {
        let _env = self._env
        let result = _env.pointee.pointee.FindClass(_env, className)
        return result
    }

    public func GetMethodID(for object: JavaObject, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let _env = self._env
        let objectClass = _env.pointee.pointee.GetObjectClass(_env, object)
        try checkAndThrowOnJNIError()

        guard let result = _env.pointee.pointee.GetMethodID(_env, objectClass!, methodName, methodSignature) else {
            throw InvalidMethodID()
        }

        try checkAndThrowOnJNIError()
        return result
    }

    public func GetStaticMethodID(for javaClass: JavaClass, methodName: String, methodSignature: String) throws -> JavaMethodID {
        let _env = self._env
        guard let result = _env.pointee.pointee.GetStaticMethodID(_env, javaClass, methodName, methodSignature) else {
            throw InvalidMethodID()
        }

        try checkAndThrowOnJNIError()
        return result
    }

    public func CallVoidMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws {
        let _env = self._env
        var methodArgs = parameters
        _env.pointee.pointee.CallVoidMethod(_env, object, method, &methodArgs)
        try checkAndThrowOnJNIError()
    }

    public func CallObjectMethod(_ method: JavaMethodID, on object: JavaObject, parameters: [JavaParameter]) throws -> JavaObject {
        let _env = self._env
        var methodArgs = parameters
        let result = _env.pointee.pointee.CallObjectMethod(_env, object, method, &methodArgs)!
        try checkAndThrowOnJNIError()
        return result
    }

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

    public func CallStaticBooleanMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) -> JavaBoolean {
        let _env = self._env
        var methodArgs = parameters
        return _env.pointee.pointee.CallStaticBooleanMethodA(_env, javaClass, method, &methodArgs)
    }

    public func CallStaticVoidMethod(javaClass: JavaClass, method: JavaMethodID, parameters: [JavaParameter]) {
        let _env = self._env
        var methodArgs = parameters
        _env.pointee.pointee.CallStaticVoidMethodA(_env, javaClass, method, &methodArgs)
    }

    // MARK: Arrays

    public func GetLength(_ array: JavaArray) -> Int {
        let _env = self._env
        let result = _env.pointee.pointee.GetArrayLength(_env, array)
        return Int(result)
    }

    public func NewIntArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewIntArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, numElements: Int = -1) -> [Int] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaInt](repeating: 0, count: count)
        _env.pointee.pointee.GetIntArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Int($0) }
    }

    public func SetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, from sourceElements: [Int]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaInt($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    public func NewFloatArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewFloatArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, numElements: Int = -1) -> [Float] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaFloat](repeating: 0, count: count)
        _env.pointee.pointee.GetFloatArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Float($0) }
    }

    public func SetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, from sourceElements: [Float]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaFloat($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    public func GetStrings(from array: JavaObjectArray) throws -> [String] {
        let _env = self._env
        let count = jni.GetLength(array)

        let strings: [String] = try (0 ..< count).map { i in
            let jString: JavaString? = _env.pointee.pointee.GetObjectArrayElement(_env, array, jsize(i))
            let chars = _env.pointee.pointee.GetStringUTFChars(_env, jString, nil)
            try checkAndThrowOnJNIError()
            defer { _env.pointee.pointee.ReleaseStringUTFChars(_env, jString, chars) }

            return String(cString: chars)
        }

        return strings
    }
}

func checkAndThrowOnJNIError() throws {
    if jni.ExceptionCheck() { throw JNIError() }
}

/// Prints information about the error to the console and clears the pending exception so we can continue making JNI calls
struct JNIError: Error {
    init() {
        jni.ExceptionDescribe()
        jni.ExceptionClear()
    }
}

/**
 Allows a (Void) Java method to be called from Swift. Takes a global jobj (a class instance), a method name and its signature. The resulting callback can be called via javaCallback.call(param1, param2...), or javaCallback.apply([params]). Each param must be a JavaParameter.

 Needs more error checking and handling. The basis is there, but from memory I had issues with either the optional or the throwing on Android.
*/
public struct JavaCallback {
    private let jobj: JavaObject // must be a JNI Global Reference
    private let methodID: JavaMethodID

    // Eventually we should check how many parameters are required by the method signature
    // And also which return type is expected (to allow calling non-Void methods)
    // For now this implementation remains unsafe
    //let expectedParameterCount: Int

    /// Errors describing the various things that can go wrong when calling a Java method via JNI.
    /// - __InvalidParameters__: One character per method parameter is required. For example, with a methodSignature of "(FF)V", you need to pass two floats as parameters.
    /// - __InvalidMethod__: Couldn't get the requested method from the JavaObject provided (are you calling with the right JavaObject instance / calling on the correct class?)
    /// - __IncorrectMethodSignature__: The JNI is separated into Java method calls to functions with various return types. So if you perform `callJavaMethod`, you need to accept the return value with the corresponding type. *XXX: currently only Void methods are implemented*.

    enum JavaError: Error {
        case JNINotReady
        case InvalidParameters
        case IncorrectMethodSignature
        case InvalidClass
        case InvalidMethod
    }

    /**
    - Parameters:
    - globalJobj: The class instance you want to perform the method on. Note this must be a jni GlobalRef, otherwise your callback will either crash or just silently not work.
    - methodName: A `String` with the name of the Java method to call
    - methodSignature: A `String` containing the method's exact signature. Although it is possible to call non-Void Java methods via the JNI, that is not yet implemented in the the current Swift binding. This means that, for now, `methodSignature` must end with `"V"` i.e., return `Void`
    - **`"(F)V"`** would reference a method that accepts one Float and returns Void.
    - **Z** boolean
    - **B** byte
    - **C** char
    - **S** short
    - **I** int
    - **J** long
    - **F** float
    - **D** double
    - **Lfully-qualified-class;** fully-qualified-class
    - **[type** type[]
    - **(arg-types)ret-type** method type
    - e.g. **`"([I)V"`** would accept one array of Ints and return Void.
    - parameters: Any number of JavaParameters (*must have the same number and type as the* `methodSignature` *you're trying to call*)
    - Throws: `JavaCallback.Error`
    */
    public init (_ globalJobj: JavaObject, methodName: String, methodSignature: String) {
        // At the moment we can only call Void methods, fail if user tries to return something else
        guard let returnType = methodSignature.characters.last, returnType == "V"/*oid*/ else {
            // LOG JavaMethodCallError.IncorrectMethodSignature
            fatalError("JavaMethodCallError.IncorrectMethodSignature")
        }

        // With signature "(FF)V", parameters count should be 2, ignoring the two brackets and the V
        // XXX: This test isn't robust, but it will prevent simple user errors
        // Doesn't work with more complex object types, arrays etc. we should determine the signature based on parameters.

        // TODO: Check methodSignature here and determine expectedParameterCount

        guard
            let javaClass = jni.GetObjectClass(obj: globalJobj),
            let methodID = try? jni.GetMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
            else {
                // XXX: We should throw here and keep throwing til it gets back to Java
                fatalError("Failed to make JavaCallback")
        }

        self.jobj = globalJobj
        self.methodID = methodID
    }

    public func apply(args: [JavaParameter]) {
        try? jni.CallVoidMethod(methodID, on: jobj, parameters: args)
    }

    /// Send variadic parameters to the func that takes an array
    public func call(args: JavaParameter...) {
        self.apply(args: args)
    }
}