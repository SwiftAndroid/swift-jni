import CJNI

public extension JNI {
	public func NewString(unicodeChars: UnsafePointer<jchar>, _ len: jsize) -> jstring {
	    let env = self._env
	    return env.memory.memory.NewString(env, unicodeChars, len)
	}

	public func GetStringLength(string: jstring) -> jsize {
	    let env = self._env
	    return env.memory.memory.GetStringLength(env, string)
	}

	public func GetStringChars(string: jstring, _ isCopy: UnsafeMutablePointer<jboolean>) -> UnsafePointer<jchar> {
	    let env = self._env
	    return env.memory.memory.GetStringChars(env, string, isCopy)
	}

	public func ReleaseStringChars(string: jstring, _ chars: UnsafePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.ReleaseStringChars(env, string, chars)
	}

	public func NewStringUTF(bytes: String) -> jstring {
	    let env = self._env
	    return env.memory.memory.NewStringUTF(env, bytes)
	}

	public func GetStringUTFLength(string: jstring) -> jsize {
	    let env = self._env
	    return env.memory.memory.GetStringUTFLength(env, string)
	}

	public func GetStringUTFChars(string: jstring, _ isCopy: UnsafeMutablePointer<jboolean>) -> String {
	    let env = self._env
	    return String(env.memory.memory.GetStringUTFChars(env, string, isCopy))
	}

	public func ReleaseStringUTFChars(string: jstring, _ utf: String) {
	    let env = self._env
	    env.memory.memory.ReleaseStringUTFChars(env, string, utf)
	}

	public func GetStringRegion(str: jstring, _ start: jsize, _ len: jsize, _ buf: UnsafeMutablePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.GetStringRegion(env, str, start, len, buf)
	}

	public func GetStringUTFRegion(str: jstring, _ start: jsize, _ len: jsize, _ buf: UnsafeMutablePointer<CChar>) {
	    let env = self._env
	    env.memory.memory.GetStringUTFRegion(env, str, start, len, buf)
	}

	public func GetStringCritical(string: jstring, _ isCopy: UnsafeMutablePointer<jboolean>) -> UnsafePointer<jchar> {
	    let env = self._env
	    return env.memory.memory.GetStringCritical(env, string, isCopy)
	}

	public func ReleaseStringCritical(string: jstring, _ carray: UnsafePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.ReleaseStringCritical(env, string, carray)
	}
}
