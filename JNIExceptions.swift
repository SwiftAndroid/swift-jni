import CJNI

public extension JNI {
    public func ExceptionCheck() -> jboolean {
        let env = self._env
        return env.memory.memory.ExceptionCheck(env)
    }

    public func ExceptionDescribe() {
        let env = self._env
        env.memory.memory.ExceptionDescribe(env)
    }

    public func ExceptionClear() {
        let env = self._env
        env.memory.memory.ExceptionClear(env)
    }

    public func ExceptionOccurred() -> jthrowable {
        let env = self._env
        return env.memory.memory.ExceptionOccurred(env)
    }

    public func Throw(obj: jthrowable) -> jint {
        let env = self._env
        return env.memory.memory.Throw(env, obj)
    }

    public func ThrowNew(targetClass: jclass, _ message: String) -> jint {
        let env = self._env
        return env.memory.memory.ThrowNew(env, targetClass, message)
    }

    public func FatalError(msg: String) {
        let env = self._env
        env.memory.memory.FatalError(env, msg)
    }
}
