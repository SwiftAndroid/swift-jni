#if canImport(Glibc)
import Glibc

@_silgen_name("syscall")
public func syscallNonVariadic(_ number: Int) -> Int

public var isMainThread: Bool {
    return syscallNonVariadic(Int(SYS_gettid)) == getpid()
}
#elseif canImport(Darwin)
import Darwin
import Foundation // free on Darwin, expensive elsewhere

public var isMainThread: Bool {
    return Thread.isMainThread
}
#endif
