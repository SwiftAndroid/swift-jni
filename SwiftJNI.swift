import CJNI

public var jni: JNI! // this gets set "OnLoad" so should always exist

@_silgen_name("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM>, reserved: UnsafeMutablePointer<Void>) -> jint {

    guard let localJNI = JNI(jvm: jvm) else {
         fatalError("Couldn't initialise JNI")
    }

    jni = localJNI // set the global for use elsewhere

    return JNI_VERSION_1_6
}

extension jboolean : BooleanLiteralConvertible {
    public init(booleanLiteral value: Bool) {
        self = value ? jboolean(JNI_TRUE) : jboolean(JNI_FALSE)
    }
}

// SwiftJNI Public API
public class SwiftJNI : JNI {
    public func RegisterNatives(jClass: jclass, methods: [JNINativeMethod]) -> Bool {
        let _env = self._env
		let env = _env.memory.memory
        let result = env.RegisterNatives(_env, jClass, methods, jint(methods.count))
        return (result == 0)
    }

    public func ThrowNew(message: String) {
        let _env = self._env
        let env = _env.memory.memory
        env.ThrowNew(_env, env.FindClass(_env, "java/lang/Exception"), message)
    }

    /// - Note: This shouldn't need to be cleaned up because we're not taking ownership of the reference
    public func GetStringUTFChars(string: jstring) -> UnsafePointer<CChar> {
        let _env = self._env
        var didCopyStringChars = jboolean() // XXX: this gets set below, check it!
        return _env.memory.memory.GetStringUTFChars(_env, string, &didCopyStringChars)
    }

    // MARK: References

    public func NewGlobalRef(object: jobject) -> jobject? {
        let _env = self._env
        let result = _env.memory.memory.NewGlobalRef(_env, object)
        return (result != nil) ? result : .None
    }

    public func DeleteLocalRef(object: jobject) {
        let _env = self._env
        _env.memory.memory.DeleteLocalRef(_env, object)
    }


    // MARK: Classes and Methods

    public func FindClass(className: String) -> jclass? {
        let _env = self._env
        let result = _env.memory.memory.FindClass(_env, className)
        return (result != nil) ? result : .None
    }

    public func GetObjectClass(object: jobject) -> jclass? {
        let _env = self._env
        let result = _env.memory.memory.GetObjectClass(_env, object)
        return (result != nil) ? result : .None
    }

    public func GetMethodID(javaClass: jclass, methodName: UnsafePointer<CChar>, methodSignature: UnsafePointer<CChar>) -> jmethodID? {
        let _env = self._env
        let result = _env.memory.memory.GetMethodID(_env, javaClass, methodName, methodSignature)
        return (result != nil) ? result : .None
    }

    // TODO: make parameters take [JValue], being a swifty version of [jvalue] with reference counting etc.
    public func CallVoidMethodA(object: jobject, methodID method: jmethodID, parameters: [jvalue]) {
        let _env = self._env
        var methodArgs = parameters
        _env.memory.memory.CallVoidMethodA(_env, object, method, &methodArgs)
    }

    // MARK: Arrays

    public func GetArrayLength(array: jarray) -> Int {
        let _env = self._env
        let result = _env.memory.memory.GetArrayLength(_env, array)
        return Int(result)
    }

    public func NewIntArray(count: Int) -> jarray? {
        let _env = self._env
        let result = _env.memory.memory.NewIntArray(_env, jsize(count))
        return (result != nil) ? result : .None
    }

    public func GetIntArrayRegion(array: jintArray, startIndex: Int = 0, numElements: Int = -1) -> [Int] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetArrayLength(array)
        }

        var result = [jint](count: count, repeatedValue: 0)
        _env.memory.memory.GetIntArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Int($0) }
    }

    public func SetIntArrayRegion(array: jintArray, startIndex: Int = 0, from sourceElements: [Int]) {
        let _env = self._env
        var newElements = sourceElements.map { jint($0) } // make mutable copy
        _env.memory.memory.SetIntArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    public func NewFloatArray(count: Int) -> jarray? {
        let _env = self._env
        let result = _env.memory.memory.NewFloatArray(_env, jsize(count))
        return (result != nil) ? result : .None
    }

    public func GetFloatArrayRegion(array: jfloatArray, startIndex: Int = 0, numElements: Int = -1) -> [Float] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetArrayLength(array)
        }

        var result = [jfloat](count: count, repeatedValue: 0)
        _env.memory.memory.GetFloatArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Float($0) }
    }

    public func SetFloatArrayRegion(array: jfloatArray, startIndex: Int = 0, from sourceElements: [Float]) {
        let _env = self._env
        var newElements = sourceElements.map { jfloat($0) } // make mutable copy
        _env.memory.memory.SetFloatArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }
}


/**
 Allows a (Void) Java method to be called from Swift. Takes a global jobj (a class instance), a method name and its signature. The resulting callback can be called via javaCallback.call(param1, param2...), or javaCallback.apply([params]). Each param must be a jvalue.
 
 Needs more error checking and handling. The basis is there, but from memory I had issues with either the optional or the throwing on Android.
*/
public struct JavaCallback {
    private let jobj: jobject // must be a JNI Global Reference
    private let methodID: jmethodID

    // Eventually we should check how many parameters are required by the method signature
    // And also which return type is expected (to allow calling non-Void methods)
    // For now this implementation remains unsafe
    //let expectedParameterCount: Int

    /// Errors describing the various things that can go wrong when calling a Java method via JNI.
    /// - __InvalidParameters__: One character per method parameter is required. For example, with a methodSignature of "(FF)V", you need to pass two floats as parameters.
    /// - __InvalidMethod__: Couldn't get the requested method from the jobject provided (are you calling with the right jobject instance / calling on the correct class?)
    /// - __IncorrectMethodSignature__: The JNI is separated into Java method calls to functions with various return types. So if you perform `callJavaMethod`, you need to accept the return value with the corresponding type. *XXX: currently only Void methods are implemented*.
    
    enum Error: ErrorType {
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
    - parameters: Any number of jvalues (*must have the same number and type as the* `methodSignature` *you're trying to call*)
    - Throws: `JavaCallback.Error`
    */
    public init (_ globalJobj: jobject, methodName: String, methodSignature: String) {
        // At the moment we can only call Void methods, fail if user tries to return something else
        guard let returnType = methodSignature.characters.last where returnType == "V"/*oid*/ else {
            // LOG JavaMethodCallError.IncorrectMethodSignature
            fatalError("JavaMethodCallError.IncorrectMethodSignature")
        }

        // With signature "(FF)V", parameters count should be 2, ignoring the two brackets and the V
        // XXX: This test isn't robust, but it will prevent simple user errors
        // Doesn't work with more complex object types, arrays etc. we should determine the signature based on parameters.

        // TODO: Check methodSignature here and determine expectedParameterCount

        guard
            let javaClass = jni.GetObjectClass(globalJobj),
            let methodID = jni.GetMethodID(javaClass, methodName: methodName, methodSignature: methodSignature)
            else {
                // XXX: We should throw here and keep throwing til it gets back to Java
                fatalError("Failed to make JavaCallback")
        }

        self.jobj = globalJobj
        self.methodID = methodID
    }

    public func apply(parameters: [jvalue]) {
        jni.CallVoidMethodA(jobj, methodID: methodID, parameters: parameters)
    }

    /// Send variadic parameters to the func that takes an array
    public func call(parameters: jvalue...) {
        self.apply(parameters)
    }
}

