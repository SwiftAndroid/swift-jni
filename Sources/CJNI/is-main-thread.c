#include <unistd.h>
#if __has_include(<syscall.h>)
#include <syscall.h>
#else
#include <sys/syscall.h>
#endif // __has_include(<syscall.h>)

// Linux / Android only:
int __isMainThread(void) {
    return syscall(SYS_gettid) == getpid();
}
