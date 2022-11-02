import CJNI
import Dispatch

public var jni: JNI! // this gets set "OnLoad" so should always exist

@_cdecl("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM>, reserved: UnsafeMutableRawPointer) -> JavaInt {
    guard let localJNI = JNI(jvm: jvm) else {
         fatalError("Couldn't initialise JNI")
    }

    jni = localJNI // set the global for use elsewhere

    #if os(Android)
    // DispatchQueue.drainingMainQueue = true
    // DispatchQueue.setThreadDetachCallback(JNI_DetachCurrentThread)
    #endif

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
public extension JNI {
    func RegisterNatives(javaClass: JavaClass, methods: [JNINativeMethod]) -> Bool {
        let _env = self._env
		let env = _env.pointee.pointee
        let result = env.RegisterNatives(_env, javaClass, methods, JavaInt(methods.count))
        return (result == 0)
    }

    func ThrowNew(message: String) {
        let _env = self._env
        let env = _env.pointee.pointee
        _ = env.ThrowNew(_env, env.FindClass(_env, "java/lang/Exception"), message)
    }

    // MARK: Arrays

    func GetLength(_ array: JavaArray) -> Int {
        let _env = self._env
        let result = _env.pointee.pointee.GetArrayLength(_env, array)
        return Int(result)
    }

    func NewIntArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewIntArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func NewByteArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewByteArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func GetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, numElements: Int = -1) -> [UInt8] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaByte](repeating: 0, count: count)
        _env.pointee.pointee.GetByteArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)

        // Conversion from Int8 (JavaByte) to UInt8: bitPattern-constructor ensures
        // that negative Int8 values do not cause a crash when trying convert them to UInt8
        return result.map { UInt8(bitPattern: $0) }
    }

    func SetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, from sourceElements: UnsafeBufferPointer<UInt8>) {
        let _env = self._env
        var newElements = sourceElements.map { JavaByte($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, numElements: Int = -1) -> [JavaInt] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaInt](repeating: 0, count: count)
        _env.pointee.pointee.GetIntArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result
    }

    func SetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, from sourceElements: [Int]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaInt($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func NewFloatArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewFloatArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func GetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, numElements: Int = -1) -> [Float] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaFloat](repeating: 0, count: count)
        _env.pointee.pointee.GetFloatArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Float($0) }
    }

    func SetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, from sourceElements: [Float]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaFloat($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetStrings(from array: JavaObjectArray) throws -> [String] {
        let _env = self._env
        let count = jni.GetLength(array)

        let strings: [String] = try (0 ..< count).map { i in
            let jString: JavaString? = _env.pointee.pointee.GetObjectArrayElement(_env, array, jsize(i))
            let chars = _env.pointee.pointee.GetStringUTFChars(_env, jString, nil)
            try checkAndThrowOnJNIError()
            defer { _env.pointee.pointee.ReleaseStringUTFChars(_env, jString, chars) }

            return String(cString: chars!)
        }

        return strings
    }

    func GetObjectArrayElement(in array: JavaObjectArray, at index: Int) throws -> JavaObject {
        let _env = self._env
        let count = jni.GetLength(array)
        if (index >= count) {
            throw JNIError()
        }
        let jObj = _env.pointee.pointee.GetObjectArrayElement(_env, array, jsize(index))
        try checkAndThrowOnJNIError()
        return jObj!
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

// /**
//  Allows a (Void) Java method to be called from Swift. Takes a global jobj (a class instance), a method name and its signature. The resulting callback can be called via javaCallback.call(param1, param2...), or javaCallback.apply([params]). Each param must be a JavaParameter.

//  Needs more error checking and handling. The basis is there, but from memory I had issues with either the optional or the throwing on Android.
// */
// public struct JavaCallback {
//     private let jobj: JavaObject // must be a JNI Global Reference
//     private let methodID: JavaMethodID

//     // Eventually we should check how many parameters are required by the method signature
//     // And also which return type is expected (to allow calling non-Void methods)
//     // For now this implementation remains unsafe
//     //let expectedParameterCount: Int

//     /// Errors describing the various things that can go wrong when calling a Java method via JNI.
//     /// - __InvalidParameters__: One character per method parameter is required. For example, with a methodSignature of "(FF)V", you need to pass two floats as parameters.
//     /// - __InvalidMethod__: Couldn't get the requested method from the JavaObject provided (are you calling with the right JavaObject instance / calling on the correct class?)
//     /// - __IncorrectMethodSignature__: The JNI is separated into Java method calls to functions with various return types. So if you perform `callJavaMethod`, you need to accept the return value with the corresponding type. *XXX: currently only Void methods are implemented*.

//     enum JavaError: Error {
//         case JNINotReady
//         case InvalidParameters
//         case IncorrectMethodSignature
//         case InvalidClass
//         case InvalidMethod
//     }

//     *
//     - Parameters:
//     - globalJobj: The class instance you want to perform the method on. Note this must be a jni GlobalRef, otherwise your callback will either crash or just silently not work.
//     - methodName: A `String` with the name of the Java method to call
//     - methodSignature: A `String` containing the method's exact signature. Although it is possible to call non-Void Java methods via the JNI, that is not yet implemented in the the current Swift binding. This means that, for now, `methodSignature` must end with `"V"` i.e., return `Void`
//     - **`"(F)V"`** would reference a method that accepts one Float and returns Void.
//     - **Z** boolean
//     - **B** byte
//     - **C** char
//     - **S** short
//     - **I** int
//     - **J** long
//     - **F** float
//     - **D** double
//     - **Lfully-qualified-class;** fully-qualified-class
//     - **[type** type[]
//     - **(arg-types)ret-type** method type
//     - e.g. **`"([I)V"`** would accept one array of Ints and return Void.
//     - parameters: Any number of JavaParameters (*must have the same number and type as the* `methodSignature` *you're trying to call*)
//     - Throws: `JavaCallback.Error`
    
//     public init (_ globalJobj: JavaObject, methodName: String, methodSignature: String) throws {
//         // At the moment we can only call Void methods, fail if user tries to return something else
//         guard let returnType = methodSignature.last, returnType == "V"/*oid*/ else {
//             // LOG JavaMethodCallError.IncorrectMethodSignature
//             fatalError("JavaMethodCallError.IncorrectMethodSignature")
//         }

//         // With signature "(FF)V", parameters count should be 2, ignoring the two brackets and the V
//         // XXX: This test isn't robust, but it will prevent simple user errors
//         // Doesn't work with more complex object types, arrays etc. we should determine the signature based on parameters.

//         // TODO: Check methodSignature here and determine expectedParameterCount
//         let javaClass = try jni.GetObjectClass(obj: globalJobj)
//         guard let methodID = try? jni.GetMethodID(for: javaClass, methodName: methodName, methodSignature: methodSignature)
//             else {
//                 // XXX: We should throw here and keep throwing til it gets back to Java
//                 fatalError("Failed to make JavaCallback")
//         }

//         self.jobj = globalJobj
//         self.methodID = methodID
//     }

//     public func apply(args: [JavaParameter]) {
//         try? jni.CallVoidMethod(methodID, on: jobj, parameters: args)
//     }

//     /// Send variadic parameters to the func that takes an array
//     public func call(args: JavaParameter...) {
//         self.apply(args: args)
//     }
// }

@discardableResult
@_silgen_name("__android_log_write")
public func androidPrint(_ prio: Int32, _ tag: UnsafePointer<CChar>, _ text: UnsafePointer<CChar>) -> Int32

func print(_ string: String) {
    androidPrint(5, "SwiftJNI", string)
}
