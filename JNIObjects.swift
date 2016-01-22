import CJNI

public extension JNI {

	public func AllocObject(clazz: jclass) -> jobject {
	    let env = self._env
	    return env.memory.memory.AllocObject(env, clazz)
	}

	public func NewObject(clazz: jclass, methodID: jmethodID, ...) -> jobject {
	    let env = self._env
	    return self.env.memory.memory.NewObjectV(env, clazz, methodID, args)
	}

	public func NewObjectV(clazz: jclass, methodID: jmethodID, va_list args) -> jobject {
	    let env = self._env
	    return env.memory.memory.NewObjectV(env, clazz, methodID, args)
	}

	public func NewObjectA(clazz: jclass, methodID: jmethodID, args: UnsafeMutablePointer<jvalue>) -> jobject {
	    let env = self._env
	    return env.memory.memory.NewObjectA(env, clazz, methodID, args)
	}

	public func GetObjectClass(obj: jobject) -> jclass {
	    let env = self._env
	    return env.memory.memory.GetObjectClass(env, obj)
	}
	
}