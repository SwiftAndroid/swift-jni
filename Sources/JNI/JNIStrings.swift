import CJNI
import struct Foundation.Data

public extension Data {
	init?(javaString: JavaString) {
		let env = jni._env
	    guard let chars = env.pointee.pointee.GetStringUTFChars(env, javaString, nil) else { return nil }
	    defer { env.pointee.pointee.ReleaseStringUTFChars(env, javaString, chars) }

	    let stringLength = env.pointee.pointee.GetStringUTFLength(env, javaString)
	    self.init(bytes: chars, count: Int(stringLength))
	}

	/// We extend Data instead of making an initializer for JavaString because the latter is
	/// just a Void pointer, which would cause confusion.
	func toJavaString() -> JavaString? {
		let env = jni._env
		return withUnsafeBytes { env.pointee.pointee.NewStringUTF(env, $0) }
	}
}

public extension String {
	init(javaString: JavaString) throws {
	    let env = jni._env
	    let chars = env.pointee.pointee.GetStringUTFChars(env, javaString, nil)
	    defer { env.pointee.pointee.ReleaseStringUTFChars(env, javaString, chars) }
	    try checkAndThrowOnJNIError()

	    self.init(cString: chars!)
	}
}

public extension JNI {
	public func NewString(unicodeChars: UnsafePointer<JavaChar>, _ length: jsize) -> JavaString {
	    let env = self._env
        return env.pointee.pointee.NewString(env, unicodeChars, length)!
	}

	public func GetStringLength(_ jString: JavaString) -> jsize {
	    let env = self._env
	    return env.pointee.pointee.GetStringLength(env, jString)
	}

	public func GetStringChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
	    let env = self._env
        return env.pointee.pointee.GetStringChars(env, jString, isCopy)!
	}

	public func ReleaseStringChars(_ jString: JavaString, _ chars: UnsafePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringChars(env, jString, chars)
	}

	public func NewStringUTF(_ string: String) -> JavaString {
	    let env = self._env
        return env.pointee.pointee.NewStringUTF(env, string)!
	}

	public func GetStringUTFLength(_ jString: JavaString) -> jsize {
	    let env = self._env
	    return env.pointee.pointee.GetStringUTFLength(env, jString)
	}

	public func GetStringUTFChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> String {
	    let env = self._env
        return String(describing: env.pointee.pointee.GetStringUTFChars(env, jString, isCopy))
	}

	public func ReleaseStringUTFChars(_ jString: JavaString, _ utf: String) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringUTFChars(env, jString, utf)
	}

	public func GetStringRegion(_ jString: JavaString, _ start: jsize, _ length: jsize, _ buf: UnsafeMutablePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.GetStringRegion(env, jString, start, length, buf)
	}

	public func GetStringUTFRegion(_ jString: JavaString, _ start: jsize, _ length: jsize, _ buf: UnsafeMutablePointer<CChar>) {
	    let env = self._env
	    env.pointee.pointee.GetStringUTFRegion(env, jString, start, length, buf)
	}

	public func GetStringCritical(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
	    let env = self._env
        return env.pointee.pointee.GetStringCritical(env, jString, isCopy)!
	}

	public func ReleaseStringCritical(_ jString: JavaString, _ cArray: UnsafePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringCritical(env, jString, cArray)
	}
}
