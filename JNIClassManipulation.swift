import CJNI

public extension JNI {
	public func DefineClass(name: String, loader: jobject, buf: UnsafePointer<jbyte>, bufLen: jsize) -> jclass {
	    let env = self._env
	    return env.memory.memory.DefineClass(env, name, loader, buf, bufLen)
	}

	public func FindClass(name: String) -> jclass {
	    let env = self._env
	    return env.memory.memory.FindClass(env, name)
	}

	public func FromReflectedMethod(method: jobject) -> jmethodID {
	    let env = self._env
	    return env.memory.memory.FromReflectedMethod(env, method)
	}

	public func FromReflectedField(field: jobject) -> jfieldID {
	    let env = self._env
	    return env.memory.memory.FromReflectedField(env, field)
	}

	public func ToReflectedMethod(cls: jclass, methodID: jmethodID, isStatic: jboolean) -> jobject {
	    let env = self._env
	    return env.memory.memory.ToReflectedMethod(env, cls, methodID, isStatic)
	}

	public func GetSuperclass(clazz: jclass) -> jclass {
	    let env = self._env
	    return env.memory.memory.GetSuperclass(env, clazz)
	}

	public func IsAssignableFrom(clazz1: jclass, clazz2: jclass) -> jboolean {
	    let env = self._env
	    return env.memory.memory.IsAssignableFrom(env, clazz1, clazz2)
	}

	public func ToReflectedField(cls: jclass, fieldID: jfieldID, isStatic: jboolean) -> jobject {
	    let env = self._env
	    return env.memory.memory.ToReflectedField(env, cls, fieldID, isStatic)
	}
}