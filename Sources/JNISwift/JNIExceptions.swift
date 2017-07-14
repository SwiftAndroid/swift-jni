import CJNI

public extension JNI {
    public func ExceptionCheck() -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.ExceptionCheck(env)
    }

    public func ExceptionDescribe() {
        let env = self._env
        env.pointee.pointee.ExceptionDescribe(env)
    }

    public func ExceptionClear() {
        let env = self._env
        env.pointee.pointee.ExceptionClear(env)
    }

    public func ExceptionOccurred() -> JavaThrowable {
        let env = self._env
        return env.pointee.pointee.ExceptionOccurred(env)!
    }

    public func Throw(obj: JavaThrowable) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.Throw(env, obj)
    }

    public func ThrowNew(targetClass: JavaClass, _ message: String) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.ThrowNew(env, targetClass, message)
    }

    public func FatalError(msg: String) {
        let env = self._env
        env.pointee.pointee.FatalError(env, msg)
    }
}
