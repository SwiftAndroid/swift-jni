@_exported import Android

public class JNI {
    /// Our reference to the Java Virtual Machine, to be set on init
    let _jvm: UnsafeMutablePointer<JavaVM>

    /// Ensure the _env pointer we have is always attached to the JVM
    var _env: UnsafeMutablePointer<JNIEnv> {
        var rawEnv: UnsafeMutableRawPointer?
        let threadStatus = _jvm.pointee.GetEnv(&rawEnv, JavaInt(JNI_VERSION_1_6))

        switch threadStatus {
        case JNI_OK:
            break
        case JNI_EDETACHED:
            // We weren't attached to the Java UI thread
            var attachedEnv: UnsafeMutablePointer<JNIEnv>?
            _ = _jvm.pointee.AttachCurrentThread(&attachedEnv, nil)
            return attachedEnv!
        case JNI_EVERSION:
            fatalError("This version of JNI is not supported")
        default:
            break
        }

        return rawEnv!.assumingMemoryBound(to: JNIEnv.self)
    }


    // Normally we init the jni global ourselves in JNI_OnLoad
    public init?(jvm: UnsafeMutablePointer<JavaVM>) {
        self._jvm = jvm
    }
}

public extension JNI {
    func GetVersion() -> JavaInt {
        return self._env.pointee.GetVersion()
    }

    func GetJavaVM(vm: UnsafeMutablePointer<UnsafeMutablePointer<JavaVM>?>) -> JavaInt {
        return self._env.pointee.GetJavaVM(vm)
    }

    func RegisterNatives(targetClass: JavaClass, _ methods: UnsafePointer<JNINativeMethod>, _ nMethods: JavaInt) -> JavaInt {
        return self._env.pointee.RegisterNatives(targetClass.asJClass, methods, nMethods)
    }

    func UnregisterNatives(targetClass: JavaClass) -> JavaInt {
        return self._env.pointee.UnregisterNatives(targetClass.asJClass)
    }

    func MonitorEnter(obj: JavaObject) -> JavaInt {
        return self._env.pointee.MonitorEnter(obj.asJObject)
    }

    func MonitorExit(obj: JavaObject) -> JavaInt {
        return self._env.pointee.MonitorExit(obj.asJObject)
    }

    func GetDirectBufferAddress(buffer: JavaObject) -> UnsafeMutableRawPointer? {
        return self._env.pointee.GetDirectBufferAddress(buffer.asJObject)
    }
}
