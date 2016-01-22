import CJNI

public extension JNI {
    public func NewGlobalRef(obj: jobject) -> jobject {
        let env = self._env
        return env.memory.memory.NewGlobalRef(env, obj)
    }

    public func DeleteGlobalRef(globalRef: jobject) {
        let env = self._env
        env.memory.memory.DeleteGlobalRef(env, globalRef)
    }

    public func NewLocalRef(ref: jobject) -> jobject {
        let env = self._env
        return env.memory.memory.NewLocalRef(env, ref)
    }
    
    public func DeleteLocalRef(localRef: jobject) {
        let env = self._env
        env.memory.memory.DeleteLocalRef(env, localRef)
    }

    public func PushLocalFrame(capacity: jint) -> jint {
        let env = self._env
        return env.memory.memory.PushLocalFrame(env, capacity)
    }

    public func PopLocalFrame(result: jobject) -> jobject {
        let env = self._env
        return env.memory.memory.PopLocalFrame(env, result)
    }

    public func EnsureLocalCapacity(capacity: jint) -> jint {
        let env = self._env
        return env.memory.memory.EnsureLocalCapacity(env, capacity)
    }

    public func IsSameObject(ref1: jobject, ref2: jobject) -> jboolean {
        let env = self._env
        return env.memory.memory.IsSameObject(env, ref1, ref2)
    }

    public func IsInstanceOf(obj: jobject, clazz: jclass) -> jboolean {
        let env = self._env
        return env.memory.memory.IsInstanceOf(env, obj, clazz)
    }

    public func NewWeakGlobalRef(obj: jobject) -> jweak {
        let env = self._env
        return env.memory.memory.NewWeakGlobalRef(env, obj)
    }

    public func DeleteWeakGlobalRef(obj: jweak) {
        let env = self._env
        env.memory.memory.DeleteWeakGlobalRef(env, obj)
    }

    /* added in 1: JNI.6 */
    public func GetObjectRefType(obj: jobject) -> jobjectRefType {
        let env = self._env
        return env.memory.memory.GetObjectRefType(env, obj)
    }
}