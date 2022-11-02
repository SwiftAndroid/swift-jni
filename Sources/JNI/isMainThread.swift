#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

@_silgen_name("syscall")
public func syscallNonVariadic(_ number: Int) -> Int

public var isMainThread: Bool {
    syscallNonVariadic(Int(SYS_gettid)) == getpid()
}
