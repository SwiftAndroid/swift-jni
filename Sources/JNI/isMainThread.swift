#if canImport(Android)
import Android

@_silgen_name("syscall")
public func syscallNonVariadic(_ number: Int) -> Int

public var isMainThread: Bool {
    return syscallNonVariadic(Int(SYS_gettid)) == getpid()
}
#endif
