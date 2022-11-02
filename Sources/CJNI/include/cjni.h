#include "jni.h"

// Syscall numbers; used in `isMainThread`
// FIXME: This exports syscall.h in its entirety, which isn't ideal.
#if __has_include(<syscall.h>)
#include <syscall.h>
#else
#include <sys/syscall.h>
#endif // __has_include(<syscall.h>)
