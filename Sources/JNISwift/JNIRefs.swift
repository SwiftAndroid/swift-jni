import CJNI

public extension JNI {
    public func NewGlobalRef(obj: jobject) -> jobject {
        let env = self._env
        return env.pointee!.pointee.NewGlobalRef(env, obj)!
    }

    public func DeleteGlobalRef(globalRef: jobject) {
        let env = self._env
        env.pointee!.pointee.DeleteGlobalRef(env, globalRef)
    }

    public func NewLocalRef(ref: jobject) -> jobject {
        let env = self._env
        return env.pointee!.pointee.NewLocalRef(env, ref)!
    }
    
    public func DeleteLocalRef(localRef: jobject) {
        let env = self._env
        env.pointee!.pointee.DeleteLocalRef(env, localRef)
    }

    public func PushLocalFrame(capacity: jint) -> jint {
        let env = self._env
        return env.pointee!.pointee.PushLocalFrame(env, capacity)
    }

    public func PopLocalFrame(result: jobject) -> jobject {
        let env = self._env
        return env.pointee!.pointee.PopLocalFrame(env, result)!
    }

    public func EnsureLocalCapacity(capacity: jint) -> jint {
        let env = self._env
        return env.pointee!.pointee.EnsureLocalCapacity(env, capacity)
    }

    public func IsSameObject(ref1: jobject, _ ref2: jobject) -> jboolean {
        let env = self._env
        return env.pointee!.pointee.IsSameObject(env, ref1, ref2)
    }

    public func IsInstanceOf(obj: jobject, _ targetClass: jclass) -> jboolean {
        let env = self._env
        return env.pointee!.pointee.IsInstanceOf(env, obj, targetClass)
    }

    public func NewWeakGlobalRef(obj: jobject) -> jweak {
        let env = self._env
        return env.pointee!.pointee.NewWeakGlobalRef(env, obj)!
    }

    public func DeleteWeakGlobalRef(obj: jweak) {
        let env = self._env
        env.pointee!.pointee.DeleteWeakGlobalRef(env, obj)
    }

    /* added in 1: JNI.6 */
    public func GetObjectRefType(obj: jobject) -> jobjectRefType {
        let env = self._env
        return env.pointee!.pointee.GetObjectRefType(env, obj)
    }
}
