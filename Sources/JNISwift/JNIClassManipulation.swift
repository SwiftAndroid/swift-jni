import CJNI

public extension JNI {
	public func DefineClass(name: String, _ loader: jobject, _ buffer: UnsafePointer<jbyte>, _ bufferLength: jsize) -> jclass {
	    let env = self._env
        return env.pointee!.pointee.DefineClass(env, name, loader, buffer, bufferLength)!
	}

	public func FindClass(name: String) -> jclass {
	    let env = self._env
        return env.pointee!.pointee.FindClass(env, name)!
	}

	public func FromReflectedMethod(method: jobject) -> jmethodID {
	    let env = self._env
        return env.pointee!.pointee.FromReflectedMethod(env, method)!
	}

	public func FromReflectedField(field: jobject) -> jfieldID {
	    let env = self._env
        return env.pointee!.pointee.FromReflectedField(env, field)!
	}

	public func ToReflectedMethod(targetClass: jclass, _ methodID: jmethodID, _ isStatic: jboolean) -> jobject {
	    let env = self._env
        return env.pointee!.pointee.ToReflectedMethod(env, targetClass, methodID, isStatic)!
	}

	public func GetSuperclass(targetClass: jclass) -> jclass {
	    let env = self._env
        return env.pointee!.pointee.GetSuperclass(env, targetClass)!
	}

	public func IsAssignableFrom(classA: jclass, _ classB: jclass) -> jboolean {
	    let env = self._env
	    return env.pointee!.pointee.IsAssignableFrom(env, classA, classB)
	}

	public func ToReflectedField(targetClass: jclass, _ fieldID: jfieldID, _ isStatic: jboolean) -> jobject {
	    let env = self._env
        return env.pointee!.pointee.ToReflectedField(env, targetClass, fieldID, isStatic)!
	}
}
