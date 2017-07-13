import CJNI

public extension JNI {
    public func ExceptionCheck() -> jboolean {
        let env = self._env
        return env.pointee!.pointee.ExceptionCheck(env)
    }

    public func ExceptionDescribe() {
        let env = self._env
        env.pointee!.pointee.ExceptionDescribe(env)
    }

    public func ExceptionClear() {
        let env = self._env
        env.pointee!.pointee.ExceptionClear(env)
    }

    public func ExceptionOccurred() -> jthrowable {
        let env = self._env
        return env.pointee!.pointee.ExceptionOccurred(env)!
    }

    public func Throw(obj: jthrowable) -> jint {
        let env = self._env
        return env.pointee!.pointee.Throw(env, obj)
    }

    public func ThrowNew(targetClass: jclass, _ message: String) -> jint {
        let env = self._env
        return env.pointee!.pointee.ThrowNew(env, targetClass, message)
    }

    public func FatalError(msg: String) {
        let env = self._env
        env.pointee!.pointee.FatalError(env, msg)
    }
}
