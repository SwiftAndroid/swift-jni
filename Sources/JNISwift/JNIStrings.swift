import CJNI

public extension JNI {
	public func NewString(unicodeChars: UnsafePointer<JavaChar>, _ len: jsize) -> JavaString {
	    let env = self._env
        return env.pointee.pointee.NewString(env, unicodeChars, len)!
	}

	public func GetStringLength(string: JavaString) -> jsize {
	    let env = self._env
	    return env.pointee.pointee.GetStringLength(env, string)
	}

	public func GetStringChars(string: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
	    let env = self._env
        return env.pointee.pointee.GetStringChars(env, string, isCopy)!
	}

	public func ReleaseStringChars(string: JavaString, _ chars: UnsafePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringChars(env, string, chars)
	}

	public func NewStringUTF(bytes: String) -> JavaString {
	    let env = self._env
        return env.pointee.pointee.NewStringUTF(env, bytes)!
	}

	public func GetStringUTFLength(string: JavaString) -> jsize {
	    let env = self._env
	    return env.pointee.pointee.GetStringUTFLength(env, string)
	}

	public func GetStringUTFChars(string: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> String {
	    let env = self._env
        return String(describing: env.pointee.pointee.GetStringUTFChars(env, string, isCopy))
	}

	public func ReleaseStringUTFChars(string: JavaString, _ utf: String) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringUTFChars(env, string, utf)
	}

	public func GetStringRegion(str: JavaString, _ start: jsize, _ len: jsize, _ buf: UnsafeMutablePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.GetStringRegion(env, str, start, len, buf)
	}

	public func GetStringUTFRegion(str: JavaString, _ start: jsize, _ len: jsize, _ buf: UnsafeMutablePointer<CChar>) {
	    let env = self._env
	    env.pointee.pointee.GetStringUTFRegion(env, str, start, len, buf)
	}

	public func GetStringCritical(string: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
	    let env = self._env
        return env.pointee.pointee.GetStringCritical(env, string, isCopy)!
	}

	public func ReleaseStringCritical(string: JavaString, _ carray: UnsafePointer<JavaChar>) {
	    let env = self._env
	    env.pointee.pointee.ReleaseStringCritical(env, string, carray)
	}
}
