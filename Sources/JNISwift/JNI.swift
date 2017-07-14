import CJNI

public class JNI {
    /// Our reference to the Java Virtual Machine, to be set on init
    let _jvm: UnsafeMutablePointer<JavaVM>

    /// Ensure the _env pointer we have is always attached to the JVM
    var _env: UnsafeMutablePointer<JNIEnv> {
        let jvm = _jvm.pointee.pointee

        // The type `JNIEnv` is defined as a non-mutable pointer,
        // so use this mutable _tmpPointer as an intermediate:
        var _tmpPointer: UnsafeMutableRawPointer?
        let threadStatus = jvm.GetEnv(_jvm, &_tmpPointer, JavaInt(JNI_VERSION_1_6))
        var _env = _tmpPointer?.bindMemory(to: JNIEnv.self, capacity: 1)

        switch threadStatus.bigEndian {
        case JNI_OK: break // if we're already attached, do nothing
        case JNI_EDETACHED:
            // We weren't attached to the Java UI thread
            _ = jvm.AttachCurrentThread(_jvm, &_env, nil)
        case JNI_EVERSION:
            fatalError("This version of JNI is not supported")
        default: break
        }

        return _env!
    }


    // Normally we init the jni global ourselves in JNI_OnLoad
    public init?(jvm: UnsafeMutablePointer<JavaVM>) {
        self._jvm = jvm
    }
}

public extension JNI {
    public func GetVersion() -> JavaInt {
        let env = self._env
        return env.pointee.pointee.GetVersion(env)
    }

    public func GetJavaVM(vm: UnsafeMutablePointer<UnsafeMutablePointer<JavaVM>>) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.GetJavaVM(env, vm)
    }

    public func RegisterNatives(targetClass: JavaClass, _ methods: UnsafePointer<JNINativeMethod>, _ nMethods: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.RegisterNatives(env, targetClass, methods, nMethods)
    }

    public func UnregisterNatives(targetClass: JavaClass) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.UnregisterNatives(env, targetClass)
    }

    public func MonitorEnter(obj: JavaObject) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.MonitorEnter(env, obj)
    }

    public func MonitorExit(obj: JavaObject) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.MonitorExit(env, obj)
    }
}
