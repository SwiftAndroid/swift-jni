import CJNI

public extension JNI {
	public func DefineClass(name: String, _ loader: jobject, _ buffer: UnsafePointer<jbyte>, _ bufferLength: jsize) -> jclass {
	    let env = self._env
	    return env.memory.memory.DefineClass(env, name, loader, buffer, bufferLength)
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

	public func ToReflectedMethod(targetClass: jclass, _ methodID: jmethodID, _ isStatic: jboolean) -> jobject {
	    let env = self._env
	    return env.memory.memory.ToReflectedMethod(env, cls, methodID, isStatic)
	}

	public func GetSuperclass(targetClass: jclass) -> jclass {
	    let env = self._env
	    return env.memory.memory.GetSuperclass(env, targetClass)
	}

	public func IsAssignableFrom(classA: jclass, _ classB: jclass) -> jboolean {
	    let env = self._env
	    return env.memory.memory.IsAssignableFrom(env, classA, classB)
	}

	public func ToReflectedField(targetClass: jclass, _ fieldID: jfieldID, _ isStatic: jboolean) -> jobject {
	    let env = self._env
	    return env.memory.memory.ToReflectedField(env, cls, fieldID, isStatic)
	}
}