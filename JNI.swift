@_exported import CJNI // Clang module

public class JNI {
    /// Our reference to the Java Virtual Machine, to be set on init
    let _jvm: UnsafeMutablePointer<JavaVM>

    /// Ensure the _env pointer we have is always attached to the JVM
    var _env: UnsafeMutablePointer<JNIEnv> {
        let jvm = _jvm.memory.memory

        // The type `JNIEnv` is defined as a non-mutable pointer,
        // so use this mutable _tmpPointer as an intermediate:
        var _tmpPointer = UnsafeMutablePointer<Void>()
        let threadStatus = jvm.GetEnv(_jvm, &_tmpPointer, jint(JNI_VERSION_1_6))
        var _env = UnsafeMutablePointer<JNIEnv>(_tmpPointer)

        switch threadStatus {
        case JNI_OK: break // if we're already attached, do nothing
        case JNI_EDETACHED:
            // We weren't attached to the Java UI thread
            jvm.AttachCurrentThread(_jvm, &_env, nil)
        case JNI_EVERSION:
            fatalError("This version of JNI is not supported")
        default: break
        }

        return _env
    }

    // Normally we init the jni global ourselves in JNI_OnLoad
    public init?(jvm: UnsafeMutablePointer<JavaVM>) {
        if jvm == nil { return nil }
        self._jvm = jvm
    }
}

public extension JNI {
    public func GetVersion() -> jint {
        let env = self._env
        return env.memory.memory.GetVersion(env)
    }

    public func GetJavaVM(vm: UnsafeMutablePointer<UnsafeMutablePointer<JavaVM>>) -> jint {
        let env = self._env
        return env.memory.memory.GetJavaVM(env, vm)
    }

    public func RegisterNatives(clazz: jclass, methods: UnsafePointer<JNINativeMethod>, nMethods: jint) -> jint {
        let env = self._env
        return env.memory.memory.RegisterNatives(env, clazz, methods, nMethods)
    }

    public func UnregisterNatives(clazz: jclass) -> jint {
        let env = self._env
        return env.memory.memory.UnregisterNatives(env, clazz)
    }

    public func MonitorEnter(obj: jobject) -> jint {
        let env = self._env
        return env.memory.memory.MonitorEnter(env, obj)
    }

    public func MonitorExit(obj: jobject) -> jint {
        let env = self._env
        return env.memory.memory.MonitorExit(env, obj)
    }
}
