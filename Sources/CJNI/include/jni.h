/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * JNI specification, as defined by Sun:
 * http://java.sun.com/javase/6/docs/technotes/guides/jni/spec/jniTOC.html
 *
 * Everything here is expected to be VM-neutral.
 */

#define SWIFT_UNAVAILABLE(reason) __attribute__((unavailable(#reason)))
#define CF_SWIFT_NAME(x) __attribute__((swift_name(#x)))

#ifndef JNI_H_
#define JNI_H_

#include <sys/cdefs.h>
#include <stdarg.h>

/*
 * Primitive types that match up with Java equivalents.
 */
#ifdef HAVE_INTTYPES_H
#include <inttypes.h>     /* C99 */
typedef uint8_t jboolean; /* unsigned 8 bits */
typedef int8_t jbyte;     /* signed 8 bits */
typedef uint16_t jchar;   /* unsigned 16 bits */
typedef int16_t jshort;   /* signed 16 bits */
typedef int32_t jint;     /* signed 32 bits */
typedef int64_t jlong;    /* signed 64 bits */
typedef float jfloat;     /* 32-bit IEEE 754 */
typedef double jdouble;   /* 64-bit IEEE 754 */
#else
typedef unsigned char jboolean CF_SWIFT_NAME(JavaBoolean); /* unsigned 8 bits */
typedef signed char jbyte CF_SWIFT_NAME(JavaByte);         /* signed 8 bits */
typedef unsigned short jchar CF_SWIFT_NAME(JavaChar);      /* unsigned 16 bits */
typedef short jshort CF_SWIFT_NAME(JavaShort);             /* signed 16 bits */
typedef int jint CF_SWIFT_NAME(JavaInt);                   /* signed 32 bits */
typedef long long jlong CF_SWIFT_NAME(JavaLong);           /* signed 64 bits */
typedef float jfloat CF_SWIFT_NAME(JavaFloat);             /* 32-bit IEEE 754 */
typedef double jdouble CF_SWIFT_NAME(JavaDouble);          /* 64-bit IEEE 754 */
#endif

/* "cardinal indices and sizes" */
typedef jint jsize;

#ifdef __cplusplus
/*
 * Reference types, in C++
 */
class _jobject
{
};
class _jclass : public _jobject
{
};
class _jstring : public _jobject
{
};
class _jarray : public _jobject
{
};
class _jobjectArray : public _jarray
{
};
class _jbooleanArray : public _jarray
{
};
class _jbyteArray : public _jarray
{
};
class _jcharArray : public _jarray
{
};
class _jshortArray : public _jarray
{
};
class _jintArray : public _jarray
{
};
class _jlongArray : public _jarray
{
};
class _jfloatArray : public _jarray
{
};
class _jdoubleArray : public _jarray
{
};
class _jthrowable : public _jobject
{
};

typedef _jobject *jobject;
typedef _jclass *jclass;
typedef _jstring *jstring;
typedef _jarray *jarray;
typedef _jobjectArray *jobjectArray;
typedef _jbooleanArray *jbooleanArray;
typedef _jbyteArray *jbyteArray;
typedef _jcharArray *jcharArray;
typedef _jshortArray *jshortArray;
typedef _jintArray *jintArray;
typedef _jlongArray *jlongArray;
typedef _jfloatArray *jfloatArray;
typedef _jdoubleArray *jdoubleArray;
typedef _jthrowable *jthrowable;
typedef _jobject *jweak;

#else /* not __cplusplus */

/*
 * Reference types, in C.
 */
typedef void * _Nullable jobject CF_SWIFT_NAME(JavaObject);
typedef jobject jclass CF_SWIFT_NAME(JavaClass);
typedef jobject jstring CF_SWIFT_NAME(JavaString);
typedef jobject jarray CF_SWIFT_NAME(JavaArray);
typedef jarray jobjectArray CF_SWIFT_NAME(JavaObjectArray);
typedef jarray jbooleanArray CF_SWIFT_NAME(JavaBooleanArray);
typedef jarray jbyteArray CF_SWIFT_NAME(JavaByteArray);
typedef jarray jcharArray CF_SWIFT_NAME(JavaCharArray);
typedef jarray jshortArray CF_SWIFT_NAME(JavaShortArray);
typedef jarray jintArray CF_SWIFT_NAME(JavaIntArray);
typedef jarray jlongArray CF_SWIFT_NAME(JavaLongArray);
typedef jarray jfloatArray CF_SWIFT_NAME(JavaFloatArray);
typedef jarray jdoubleArray CF_SWIFT_NAME(JavaDoubleArray);
typedef jobject jthrowable CF_SWIFT_NAME(JavaThrowable);
typedef jobject jweak CF_SWIFT_NAME(JavaWeakReference);

#endif /* not __cplusplus */

struct _jfieldID;                             /* opaque structure */
typedef struct _jfieldID * _Nullable jfieldID CF_SWIFT_NAME(JavaFieldID); /* field IDs */

struct _jmethodID;                                                          /* opaque structure */
typedef struct _jmethodID * _Nullable jmethodID CF_SWIFT_NAME(JavaMethodID); /* method IDs */

struct JNIInvokeInterface;

typedef union CF_SWIFT_NAME(JavaParameter) jvalue {
    jboolean z CF_SWIFT_NAME(bool);
    jbyte b CF_SWIFT_NAME(byte);
    jchar c CF_SWIFT_NAME(char);
    jshort s CF_SWIFT_NAME(short);
    jint i CF_SWIFT_NAME(int);
    jlong j CF_SWIFT_NAME(long);
    jfloat f CF_SWIFT_NAME(float);
    jdouble d CF_SWIFT_NAME(double);
    jobject l CF_SWIFT_NAME(object);
} jvalue;

typedef enum CF_SWIFT_NAME(JavaObjectRefType) jobjectRefType {
    JNIInvalidRefType = 0,
    JNILocalRefType = 1,
    JNIGlobalRefType = 2,
    JNIWeakGlobalRefType = 3
} jobjectRefType;

typedef struct
{
    const char * _Nonnull name;
    const char * _Nonnull signature;
    void * _Nonnull fnPtr;
} JNINativeMethod;

struct _JNIEnv;
struct _JavaVM;
typedef const struct JNINativeInterface * _Nonnull C_JNIEnv;

#if defined(__cplusplus)
typedef _JNIEnv JNIEnv;
typedef _JavaVM JavaVM;
#else
typedef const struct JNINativeInterface * _Nonnull JNIEnv;
typedef const struct JNIInvokeInterface * _Nonnull JavaVM;
#endif

/*
 * Table of interface function pointers.
 */
struct JNINativeInterface
{
    void *_Null_unspecified reserved0;
    void *_Null_unspecified reserved1;
    void *_Null_unspecified reserved2;
    void *_Null_unspecified reserved3;

    jint (* _Nonnull GetVersion)(JNIEnv * _Nonnull);

    jclass (* _Nonnull DefineClass)(JNIEnv * _Nonnull, const char * _Nonnull, jobject, const jbyte * _Nonnull, jsize) SWIFT_UNAVAILABLE(Not implemented on Android);
    jclass (* _Nonnull FindClass)(JNIEnv * _Nonnull, const char * _Nonnull);

    jmethodID (* _Nonnull FromReflectedMethod)(JNIEnv * _Nonnull, jobject);
    jfieldID (* _Nonnull FromReflectedField)(JNIEnv * _Nonnull, jobject);
    /* spec doesn't show jboolean parameter */
    jobject (* _Nonnull ToReflectedMethod)(JNIEnv * _Nonnull, jclass, jmethodID, jboolean);

    jclass (* _Nonnull GetSuperclass)(JNIEnv * _Nonnull, jclass);
    jboolean (* _Nonnull IsAssignableFrom)(JNIEnv * _Nonnull, jclass, jclass);

    /* spec doesn't show jboolean parameter */
    jobject (* _Nonnull ToReflectedField)(JNIEnv * _Nonnull, jclass, jfieldID, jboolean);

    jint (* _Nonnull Throw)(JNIEnv * _Nonnull, jthrowable);
    jint (* _Nonnull ThrowNew)(JNIEnv * _Nonnull, jclass, const char * _Nonnull);
    jthrowable (* _Nonnull ExceptionOccurred)(JNIEnv * _Nonnull);
    void (* _Nonnull ExceptionDescribe)(JNIEnv * _Nonnull);
    void (* _Nonnull ExceptionClear)(JNIEnv * _Nonnull);
    void (* _Nonnull FatalError)(JNIEnv * _Nonnull, const char * _Nonnull);

    jint (* _Nonnull PushLocalFrame)(JNIEnv * _Nonnull, jint);
    jobject (* _Nonnull PopLocalFrame)(JNIEnv * _Nonnull, jobject);

    jobject (* _Nonnull NewGlobalRef)(JNIEnv * _Nonnull, jobject);
    void (* _Nonnull DeleteGlobalRef)(JNIEnv * _Nonnull, jobject);
    void (* _Nonnull DeleteLocalRef)(JNIEnv * _Nonnull, jobject);
    jboolean (* _Nonnull IsSameObject)(JNIEnv * _Nonnull, jobject, jobject);

    jobject (* _Nonnull NewLocalRef)(JNIEnv * _Nonnull, jobject);
    jint (* _Nonnull EnsureLocalCapacity)(JNIEnv * _Nonnull, jint);

    jobject (* _Nonnull AllocObject)(JNIEnv * _Nonnull, jclass);
    jobject (* _Nonnull NewObject)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'newObject' instead);
    jobject (* _Nonnull NewObjectV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'newObject' instead);
    jobject (* _Nonnull NewObjectA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(NewObject);

    jclass (* _Nonnull GetObjectClass)(JNIEnv * _Nonnull, jobject);
    jboolean (* _Nonnull IsInstanceOf)(JNIEnv * _Nonnull, jobject, jclass);
    jmethodID (* _Nonnull GetMethodID)(JNIEnv * _Nonnull, jclass, const char * _Nonnull, const char * _Nonnull);

    jobject (* _Nonnull CallObjectMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jobject (* _Nonnull CallObjectMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jobject (* _Nonnull CallObjectMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallObjectMethod);
    jboolean (* _Nonnull CallBooleanMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jboolean (* _Nonnull CallBooleanMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jboolean (* _Nonnull CallBooleanMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallBooleanMethod);
    jbyte (* _Nonnull CallByteMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jbyte (* _Nonnull CallByteMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jbyte (* _Nonnull CallByteMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallByteMethod);
    jchar (* _Nonnull CallCharMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jchar (* _Nonnull CallCharMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jchar (* _Nonnull CallCharMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallCharMethod);
    jshort (* _Nonnull CallShortMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jshort (* _Nonnull CallShortMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jshort (* _Nonnull CallShortMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallShortMethod);
    jint (* _Nonnull CallIntMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jint (* _Nonnull CallIntMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jint (* _Nonnull CallIntMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallIntMethod);
    jlong (* _Nonnull CallLongMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jlong (* _Nonnull CallLongMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jlong (* _Nonnull CallLongMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallLongMethod);
    jfloat (* _Nonnull CallFloatMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jfloat (* _Nonnull CallFloatMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jfloat (* _Nonnull CallFloatMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallFloatMethod);
    jdouble (* _Nonnull CallDoubleMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    jdouble (* _Nonnull CallDoubleMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jdouble (* _Nonnull CallDoubleMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallDoubleMethod);
    void (* _Nonnull CallVoidMethod)(JNIEnv * _Nonnull, jobject, jmethodID, ...) SWIFT_UNAVAILABLE();
    void (* _Nonnull CallVoidMethodV)(JNIEnv * _Nonnull, jobject, jmethodID, va_list) SWIFT_UNAVAILABLE();
    void (* _Nonnull CallVoidMethodA)(JNIEnv * _Nonnull, jobject, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(CallVoidMethod);

    jobject (* _Nonnull CallNonvirtualObjectMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jobject (* _Nonnull CallNonvirtualObjectMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jobject (* _Nonnull CallNonvirtualObjectMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jboolean (* _Nonnull CallNonvirtualBooleanMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jboolean (* _Nonnull CallNonvirtualBooleanMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jboolean (* _Nonnull CallNonvirtualBooleanMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jbyte (* _Nonnull CallNonvirtualByteMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jbyte (* _Nonnull CallNonvirtualByteMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jbyte (* _Nonnull CallNonvirtualByteMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jchar (* _Nonnull CallNonvirtualCharMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jchar (* _Nonnull CallNonvirtualCharMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jchar (* _Nonnull CallNonvirtualCharMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jshort (* _Nonnull CallNonvirtualShortMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jshort (* _Nonnull CallNonvirtualShortMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jshort (* _Nonnull CallNonvirtualShortMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jint (* _Nonnull CallNonvirtualIntMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jint (* _Nonnull CallNonvirtualIntMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jint (* _Nonnull CallNonvirtualIntMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jlong (* _Nonnull CallNonvirtualLongMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jlong (* _Nonnull CallNonvirtualLongMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jlong (* _Nonnull CallNonvirtualLongMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jfloat (* _Nonnull CallNonvirtualFloatMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jfloat (* _Nonnull CallNonvirtualFloatMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jfloat (* _Nonnull CallNonvirtualFloatMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    jdouble (* _Nonnull CallNonvirtualDoubleMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jdouble (* _Nonnull CallNonvirtualDoubleMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    jdouble (* _Nonnull CallNonvirtualDoubleMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);
    void (* _Nonnull CallNonvirtualVoidMethod)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, ...) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    void (* _Nonnull CallNonvirtualVoidMethodV)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE(use 'callNonvirtual' instead);
    void (* _Nonnull CallNonvirtualVoidMethodA)(JNIEnv * _Nonnull, jobject, jclass, jmethodID, const jvalue * _Nonnull) CF_SWIFT_NAME(callNonvirtual);

    jfieldID (* _Nonnull GetFieldID)(JNIEnv * _Nonnull, jclass, const char * _Nonnull, const char * _Nonnull);

    jobject (* _Nonnull GetObjectField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jboolean (* _Nonnull GetBooleanField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jbyte (* _Nonnull GetByteField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jchar (* _Nonnull GetCharField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jshort (* _Nonnull GetShortField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jint (* _Nonnull GetIntField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jlong (* _Nonnull GetLongField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jfloat (* _Nonnull GetFloatField)(JNIEnv * _Nonnull, jobject, jfieldID);
    jdouble (* _Nonnull GetDoubleField)(JNIEnv * _Nonnull, jobject, jfieldID);

    void (* _Nonnull SetObjectField)(JNIEnv * _Nonnull, jobject, jfieldID, jobject);
    void (* _Nonnull SetBooleanField)(JNIEnv * _Nonnull, jobject, jfieldID, jboolean);
    void (* _Nonnull SetByteField)(JNIEnv * _Nonnull, jobject, jfieldID, jbyte);
    void (* _Nonnull SetCharField)(JNIEnv * _Nonnull, jobject, jfieldID, jchar);
    void (* _Nonnull SetShortField)(JNIEnv * _Nonnull, jobject, jfieldID, jshort);
    void (* _Nonnull SetIntField)(JNIEnv * _Nonnull, jobject, jfieldID, jint);
    void (* _Nonnull SetLongField)(JNIEnv * _Nonnull, jobject, jfieldID, jlong);
    void (* _Nonnull SetFloatField)(JNIEnv * _Nonnull, jobject, jfieldID, jfloat);
    void (* _Nonnull SetDoubleField)(JNIEnv * _Nonnull, jobject, jfieldID, jdouble);

    jmethodID (* _Nonnull GetStaticMethodID)(JNIEnv * _Nonnull, jclass, const char * _Nonnull, const char * _Nonnull);

    jobject (* _Nonnull CallStaticObjectMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jobject (* _Nonnull CallStaticObjectMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jobject (* _Nonnull CallStaticObjectMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jboolean (* _Nonnull CallStaticBooleanMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jboolean (* _Nonnull CallStaticBooleanMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jboolean (* _Nonnull CallStaticBooleanMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jbyte (* _Nonnull CallStaticByteMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jbyte (* _Nonnull CallStaticByteMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jbyte (* _Nonnull CallStaticByteMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jchar (* _Nonnull CallStaticCharMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jchar (* _Nonnull CallStaticCharMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jchar (* _Nonnull CallStaticCharMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jshort (* _Nonnull CallStaticShortMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jshort (* _Nonnull CallStaticShortMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jshort (* _Nonnull CallStaticShortMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jint (* _Nonnull CallStaticIntMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jint (* _Nonnull CallStaticIntMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jint (* _Nonnull CallStaticIntMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jlong (* _Nonnull CallStaticLongMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jlong (* _Nonnull CallStaticLongMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jlong (* _Nonnull CallStaticLongMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jfloat (* _Nonnull CallStaticFloatMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jfloat (* _Nonnull CallStaticFloatMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jfloat (* _Nonnull CallStaticFloatMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    jdouble (* _Nonnull CallStaticDoubleMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    jdouble (* _Nonnull CallStaticDoubleMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    jdouble (* _Nonnull CallStaticDoubleMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);
    void (* _Nonnull CallStaticVoidMethod)(JNIEnv * _Nonnull, jclass, jmethodID, ...) SWIFT_UNAVAILABLE();
    void (* _Nonnull CallStaticVoidMethodV)(JNIEnv * _Nonnull, jclass, jmethodID, va_list) SWIFT_UNAVAILABLE();
    void (* _Nonnull CallStaticVoidMethodA)(JNIEnv * _Nonnull, jclass, jmethodID, const jvalue * _Nonnull);

    jfieldID (* _Nonnull GetStaticFieldID)(JNIEnv * _Nonnull, jclass, const char * _Nonnull, const char * _Nonnull);

    jobject (* _Nonnull GetStaticObjectField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jboolean (* _Nonnull GetStaticBooleanField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jbyte (* _Nonnull GetStaticByteField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jchar (* _Nonnull GetStaticCharField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jshort (* _Nonnull GetStaticShortField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jint (* _Nonnull GetStaticIntField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jlong (* _Nonnull GetStaticLongField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jfloat (* _Nonnull GetStaticFloatField)(JNIEnv * _Nonnull, jclass, jfieldID);
    jdouble (* _Nonnull GetStaticDoubleField)(JNIEnv * _Nonnull, jclass, jfieldID);

    void (* _Nonnull SetStaticObjectField)(JNIEnv * _Nonnull, jclass, jfieldID, jobject);
    void (* _Nonnull SetStaticBooleanField)(JNIEnv * _Nonnull, jclass, jfieldID, jboolean);
    void (* _Nonnull SetStaticByteField)(JNIEnv * _Nonnull, jclass, jfieldID, jbyte);
    void (* _Nonnull SetStaticCharField)(JNIEnv * _Nonnull, jclass, jfieldID, jchar);
    void (* _Nonnull SetStaticShortField)(JNIEnv * _Nonnull, jclass, jfieldID, jshort);
    void (* _Nonnull SetStaticIntField)(JNIEnv * _Nonnull, jclass, jfieldID, jint);
    void (* _Nonnull SetStaticLongField)(JNIEnv * _Nonnull, jclass, jfieldID, jlong);
    void (* _Nonnull SetStaticFloatField)(JNIEnv * _Nonnull, jclass, jfieldID, jfloat);
    void (* _Nonnull SetStaticDoubleField)(JNIEnv * _Nonnull, jclass, jfieldID, jdouble);

    jstring (* _Nonnull NewString)(JNIEnv * _Nonnull, const jchar * _Nonnull, jsize);
    jsize (* _Nonnull GetStringLength)(JNIEnv * _Nonnull, jstring);
    const jchar * _Nullable(* _Nonnull GetStringChars)(JNIEnv * _Nonnull, jstring, jboolean * _Nullable);
    void (* _Nonnull ReleaseStringChars)(JNIEnv * _Nonnull, jstring, const jchar * _Nonnull);
    jstring (* _Nonnull NewStringUTF)(JNIEnv * _Nonnull, const char * _Nonnull);
    jsize (* _Nonnull GetStringUTFLength)(JNIEnv * _Nonnull, jstring);
    /* JNI spec says this returns const jbyte*, but that's inconsistent */
    const char * _Nonnull(* _Nonnull GetStringUTFChars)(JNIEnv * _Nonnull, jstring, jboolean * _Nullable);
    void (* _Nonnull ReleaseStringUTFChars)(JNIEnv * _Nonnull, jstring, const char * _Nullable);
    jsize (* _Nonnull GetArrayLength)(JNIEnv * _Nonnull, jarray);
    jobjectArray (* _Nonnull NewObjectArray)(JNIEnv * _Nonnull, jsize, jclass, jobject);
    jobject (* _Nonnull GetObjectArrayElement)(JNIEnv * _Nonnull, jobjectArray, jsize);
    void (* _Nonnull SetObjectArrayElement)(JNIEnv * _Nonnull, jobjectArray, jsize, jobject);

    jbooleanArray (* _Nonnull NewBooleanArray)(JNIEnv * _Nonnull, jsize);
    jbyteArray (* _Nonnull NewByteArray)(JNIEnv * _Nonnull, jsize);
    jcharArray (* _Nonnull NewCharArray)(JNIEnv * _Nonnull, jsize);
    jshortArray (* _Nonnull NewShortArray)(JNIEnv * _Nonnull, jsize);
    jintArray (* _Nonnull NewIntArray)(JNIEnv * _Nonnull, jsize);
    jlongArray (* _Nonnull NewLongArray)(JNIEnv * _Nonnull, jsize);
    jfloatArray (* _Nonnull NewFloatArray)(JNIEnv * _Nonnull, jsize);
    jdoubleArray (* _Nonnull NewDoubleArray)(JNIEnv * _Nonnull, jsize);

    jboolean * _Nullable (* _Nonnull GetBooleanArrayElements)(JNIEnv * _Nonnull, jbooleanArray, jboolean * _Nonnull);
    jbyte * _Nullable (* _Nonnull GetByteArrayElements)(JNIEnv * _Nonnull, jbyteArray, jboolean * _Nonnull);
    jchar * _Nullable (* _Nonnull GetCharArrayElements)(JNIEnv * _Nonnull, jcharArray, jboolean * _Nonnull);
    jshort * _Nullable (* _Nonnull GetShortArrayElements)(JNIEnv * _Nonnull, jshortArray, jboolean * _Nonnull);
    jint * _Nullable (* _Nonnull GetIntArrayElements)(JNIEnv * _Nonnull, jintArray, jboolean * _Nonnull);
    jlong * _Nullable (* _Nonnull GetLongArrayElements)(JNIEnv * _Nonnull, jlongArray, jboolean * _Nonnull);
    jfloat * _Nullable (* _Nonnull GetFloatArrayElements)(JNIEnv * _Nonnull, jfloatArray, jboolean * _Nonnull);
    jdouble * _Nullable (* _Nonnull GetDoubleArrayElements)(JNIEnv * _Nonnull, jdoubleArray, jboolean * _Nonnull);

    void (* _Nonnull ReleaseBooleanArrayElements)(JNIEnv * _Nonnull, jbooleanArray, jboolean * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseByteArrayElements)(JNIEnv * _Nonnull, jbyteArray, jbyte * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseCharArrayElements)(JNIEnv * _Nonnull, jcharArray, jchar * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseShortArrayElements)(JNIEnv * _Nonnull, jshortArray, jshort * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseIntArrayElements)(JNIEnv * _Nonnull, jintArray, jint * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseLongArrayElements)(JNIEnv * _Nonnull, jlongArray, jlong * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseFloatArrayElements)(JNIEnv * _Nonnull, jfloatArray, jfloat * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);
    void (* _Nonnull ReleaseDoubleArrayElements)(JNIEnv * _Nonnull, jdoubleArray, jdouble * _Nullable, jint) CF_SWIFT_NAME(ReleaseArrayElements);

    void (* _Nonnull GetBooleanArrayRegion)(JNIEnv * _Nonnull, jbooleanArray, jsize, jsize, jboolean * _Nonnull);
    void (* _Nonnull GetByteArrayRegion)(JNIEnv * _Nonnull, jbyteArray, jsize, jsize, jbyte * _Nonnull);
    void (* _Nonnull GetCharArrayRegion)(JNIEnv * _Nonnull, jcharArray, jsize, jsize, jchar * _Nonnull);
    void (* _Nonnull GetShortArrayRegion)(JNIEnv * _Nonnull, jshortArray, jsize, jsize, jshort * _Nonnull);
    void (* _Nonnull GetIntArrayRegion)(JNIEnv * _Nonnull, jintArray, jsize, jsize, jint * _Nonnull);
    void (* _Nonnull GetLongArrayRegion)(JNIEnv * _Nonnull, jlongArray, jsize, jsize, jlong * _Nonnull);
    void (* _Nonnull GetFloatArrayRegion)(JNIEnv * _Nonnull, jfloatArray, jsize, jsize, jfloat * _Nonnull);
    void (* _Nonnull GetDoubleArrayRegion)(JNIEnv * _Nonnull, jdoubleArray, jsize, jsize, jdouble * _Nonnull);

    /* spec shows these without const; some jni.h do, some don't */
    void (* _Nonnull SetBooleanArrayRegion)(JNIEnv * _Nonnull, jbooleanArray, jsize, jsize, const jboolean * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetByteArrayRegion)(JNIEnv * _Nonnull, jbyteArray, jsize, jsize, const jbyte * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetCharArrayRegion)(JNIEnv * _Nonnull, jcharArray, jsize, jsize, const jchar * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetShortArrayRegion)(JNIEnv * _Nonnull, jshortArray, jsize, jsize, const jshort * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetIntArrayRegion)(JNIEnv * _Nonnull, jintArray, jsize, jsize, const jint * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetLongArrayRegion)(JNIEnv * _Nonnull, jlongArray, jsize, jsize, const jlong * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetFloatArrayRegion)(JNIEnv * _Nonnull, jfloatArray, jsize, jsize, const jfloat * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);
    void (* _Nonnull SetDoubleArrayRegion)(JNIEnv * _Nonnull, jdoubleArray, jsize, jsize, const jdouble * _Nonnull) CF_SWIFT_NAME(SetArrayRegion);

    jint (* _Nonnull RegisterNatives)(JNIEnv * _Nonnull, jclass, const JNINativeMethod * _Nonnull, jint);
    jint (* _Nonnull UnregisterNatives)(JNIEnv * _Nonnull, jclass);
    jint (* _Nonnull MonitorEnter)(JNIEnv * _Nonnull, jobject);
    jint (* _Nonnull MonitorExit)(JNIEnv * _Nonnull, jobject);
    jint (* _Nonnull GetJavaVM)(JNIEnv * _Nonnull, JavaVM * _Nonnull* _Nonnull);

    void (* _Nonnull GetStringRegion)(JNIEnv * _Nonnull, jstring, jsize, jsize, jchar * _Nonnull);
    void (* _Nonnull GetStringUTFRegion)(JNIEnv * _Nonnull, jstring, jsize, jsize, char * _Nonnull);

    void * _Nullable(* _Nonnull GetPrimitiveArrayCritical)(JNIEnv * _Nonnull, jarray, jboolean * _Nonnull);
    void (* _Nonnull ReleasePrimitiveArrayCritical)(JNIEnv * _Nonnull, jarray, void * _Nullable, jint);

    const jchar * _Nullable(* _Nonnull GetStringCritical)(JNIEnv * _Nonnull, jstring, jboolean * _Nonnull);
    void (* _Nonnull ReleaseStringCritical)(JNIEnv * _Nonnull, jstring, const jchar * _Nullable);

    jweak (* _Nonnull NewWeakGlobalRef)(JNIEnv * _Nonnull, jobject);
    void (* _Nonnull DeleteWeakGlobalRef)(JNIEnv * _Nonnull, jweak);

    jboolean (* _Nonnull ExceptionCheck)(JNIEnv * _Nonnull);

    jobject (* _Nonnull NewDirectByteBuffer)(JNIEnv * _Nonnull, void * _Nonnull, jlong);
    void * _Nullable (* _Nonnull GetDirectBufferAddress)(JNIEnv * _Nonnull, jobject);
    jlong (* _Nonnull GetDirectBufferCapacity)(JNIEnv * _Nonnull, jobject);

    /* added in JNI 1.6 */
    jobjectRefType (* _Nonnull GetObjectRefType)(JNIEnv * _Nonnull, jobject);
};

/*
 * C++ object wrapper.
 *
 * This is usually overlaid on a C struct whose first element is a
 * JNINativeInterface*.  We rely somewhat on compiler behavior.
 */
struct _JNIEnv
{
    /* do not rename this; it does not seem to be entirely opaque */
    const struct JNINativeInterface * _Nonnull functions;

#if defined(__cplusplus)

    jint GetVersion()
    {
        return functions->GetVersion(this);
    }

    jclass DefineClass(const char * _Nonnullname, jobject loader, const jbyte *buf,
                       jsize bufLen)
    {
        return functions->DefineClass(this, name, loader, buf, bufLen);
    }

    jclass FindClass(const char *name)
    {
        return functions->FindClass(this, name);
    }

    jmethodID FromReflectedMethod(jobject method)
    {
        return functions->FromReflectedMethod(this, method);
    }

    jfieldID FromReflectedField(jobject field)
    {
        return functions->FromReflectedField(this, field);
    }

    jobject ToReflectedMethod(jclass cls, jmethodID methodID, jboolean isStatic)
    {
        return functions->ToReflectedMethod(this, cls, methodID, isStatic);
    }

    jclass GetSuperclass(jclass clazz)
    {
        return functions->GetSuperclass(this, clazz);
    }

    jboolean IsAssignableFrom(jclass clazz1, jclass clazz2)
    {
        return functions->IsAssignableFrom(this, clazz1, clazz2);
    }

    jobject ToReflectedField(jclass cls, jfieldID fieldID, jboolean isStatic)
    {
        return functions->ToReflectedField(this, cls, fieldID, isStatic);
    }

    jint Throw(jthrowable obj)
    {
        return functions->Throw(this, obj);
    }

    jint ThrowNew(jclass clazz, const char *message)
    {
        return functions->ThrowNew(this, clazz, message);
    }

    jthrowable ExceptionOccurred()
    {
        return functions->ExceptionOccurred(this);
    }

    void ExceptionDescribe()
    {
        functions->ExceptionDescribe(this);
    }

    void ExceptionClear()
    {
        functions->ExceptionClear(this);
    }

    void FatalError(const char *msg)
    {
        functions->FatalError(this, msg);
    }

    jint PushLocalFrame(jint capacity)
    {
        return functions->PushLocalFrame(this, capacity);
    }

    jobject PopLocalFrame(jobject result)
    {
        return functions->PopLocalFrame(this, result);
    }

    jobject NewGlobalRef(jobject obj)
    {
        return functions->NewGlobalRef(this, obj);
    }

    void DeleteGlobalRef(jobject globalRef)
    {
        functions->DeleteGlobalRef(this, globalRef);
    }

    void DeleteLocalRef(jobject localRef)
    {
        functions->DeleteLocalRef(this, localRef);
    }

    jboolean IsSameObject(jobject ref1, jobject ref2)
    {
        return functions->IsSameObject(this, ref1, ref2);
    }

    jobject NewLocalRef(jobject ref)
    {
        return functions->NewLocalRef(this, ref);
    }

    jint EnsureLocalCapacity(jint capacity)
    {
        return functions->EnsureLocalCapacity(this, capacity);
    }

    jobject AllocObject(jclass clazz)
    {
        return functions->AllocObject(this, clazz);
    }

    jobject NewObject(jclass clazz, jmethodID methodID, ...)
    {
        va_list args;
        va_start(args, methodID);
        jobject result = functions->NewObjectV(this, clazz, methodID, args);
        va_end(args);
        return result;
    }

    jobject NewObjectV(jclass clazz, jmethodID methodID, va_list args)
    {
        return functions->NewObjectV(this, clazz, methodID, args);
    }

    jobject NewObjectA(jclass clazz, jmethodID methodID, const jvalue * _Nonnull args)
    {
        return functions->NewObjectA(this, clazz, methodID, args);
    }

    jclass GetObjectClass(jobject obj)
    {
        return functions->GetObjectClass(this, obj);
    }

    jboolean IsInstanceOf(jobject obj, jclass clazz)
    {
        return functions->IsInstanceOf(this, obj, clazz);
    }

    jmethodID GetMethodID(jclass clazz, const char *name, const char *sig)
    {
        return functions->GetMethodID(this, clazz, name, sig);
    }

#define CALL_TYPE_METHOD(_jtype, _jname)                                \
    \ _jtype Call##_jname##Method(jobject obj, jmethodID methodID, ...) \
    {                                                                   \
        _jtype result;                                                  \
        va_list args;                                                   \
        va_start(args, methodID);                                       \
        result = functions->Call##_jname##MethodV(this, obj, methodID,  \
                                                  args);                \
        va_end(args);                                                   \
        return result;                                                  \
    }
#define CALL_TYPE_METHODV(_jtype, _jname)                                   \
    \ _jtype Call##_jname##MethodV(jobject obj, jmethodID methodID,         \
                                   va_list args)                            \
    {                                                                       \
        return functions->Call##_jname##MethodV(this, obj, methodID, args); \
    }
#define CALL_TYPE_METHODA(_jtype, _jname)                                   \
    \ _jtype Call##_jname##MethodA(jobject obj, jmethodID methodID,         \
                                   const jvalue * _Nonnull args)             \
    {                                                                       \
        return functions->Call##_jname##MethodA(this, obj, methodID, args); \
    }

#define CALL_TYPE(_jtype, _jname)     \
    CALL_TYPE_METHOD(_jtype, _jname)  \
    CALL_TYPE_METHODV(_jtype, _jname) \
    CALL_TYPE_METHODA(_jtype, _jname)

    CALL_TYPE(jobject, Object)
    CALL_TYPE(jboolean, Boolean)
    CALL_TYPE(jbyte, Byte)
    CALL_TYPE(jchar, Char)
    CALL_TYPE(jshort, Short)
    CALL_TYPE(jint, Int)
    CALL_TYPE(jlong, Long)
    CALL_TYPE(jfloat, Float)
    CALL_TYPE(jdouble, Double)

    void CallVoidMethod(jobject obj, jmethodID methodID, ...)
    {
        va_list args;
        va_start(args, methodID);
        functions->CallVoidMethodV(this, obj, methodID, args);
        va_end(args);
    }
    void CallVoidMethodV(jobject obj, jmethodID methodID, va_list args)
    {
        functions->CallVoidMethodV(this, obj, methodID, args);
    }
    void CallVoidMethodA(jobject obj, jmethodID methodID, const jvalue * _Nonnull args)
    {
        functions->CallVoidMethodA(this, obj, methodID, args);
    }

#define CALL_NONVIRT_TYPE_METHOD(_jtype, _jname)                                    \
    \ _jtype CallNonvirtual##_jname##Method(jobject obj, jclass clazz,              \
                                            jmethodID methodID, ...)                \
    {                                                                               \
        _jtype result;                                                              \
        va_list args;                                                               \
        va_start(args, methodID);                                                   \
        result = functions->CallNonvirtual##_jname##MethodV(this, obj,              \
                                                            clazz, methodID, args); \
        va_end(args);                                                               \
        return result;                                                              \
    }
#define CALL_NONVIRT_TYPE_METHODV(_jtype, _jname)                              \
    \ _jtype CallNonvirtual##_jname##MethodV(jobject obj, jclass clazz,        \
                                             jmethodID methodID, va_list args) \
    {                                                                          \
        return functions->CallNonvirtual##_jname##MethodV(this, obj, clazz,    \
                                                          methodID, args);     \
    }
#define CALL_NONVIRT_TYPE_METHODA(_jtype, _jname)                                             \
    \ _jtype CallNonvirtual##_jname##MethodA(jobject obj, jclass clazz,                       \
                                             jmethodID methodID, const jvalue * _Nonnull args) \
    {                                                                                         \
        return functions->CallNonvirtual##_jname##MethodA(this, obj, clazz,                   \
                                                          methodID, args);                    \
    }

#define CALL_NONVIRT_TYPE(_jtype, _jname)     \
    CALL_NONVIRT_TYPE_METHOD(_jtype, _jname)  \
    CALL_NONVIRT_TYPE_METHODV(_jtype, _jname) \
    CALL_NONVIRT_TYPE_METHODA(_jtype, _jname)

    CALL_NONVIRT_TYPE(jobject, Object)
    CALL_NONVIRT_TYPE(jboolean, Boolean)
    CALL_NONVIRT_TYPE(jbyte, Byte)
    CALL_NONVIRT_TYPE(jchar, Char)
    CALL_NONVIRT_TYPE(jshort, Short)
    CALL_NONVIRT_TYPE(jint, Int)
    CALL_NONVIRT_TYPE(jlong, Long)
    CALL_NONVIRT_TYPE(jfloat, Float)
    CALL_NONVIRT_TYPE(jdouble, Double)

    void CallNonvirtualVoidMethod(jobject obj, jclass clazz,
                                  jmethodID methodID, ...)
    {
        va_list args;
        va_start(args, methodID);
        functions->CallNonvirtualVoidMethodV(this, obj, clazz, methodID, args);
        va_end(args);
    }
    void CallNonvirtualVoidMethodV(jobject obj, jclass clazz,
                                   jmethodID methodID, va_list args)
    {
        functions->CallNonvirtualVoidMethodV(this, obj, clazz, methodID, args);
    }
    void CallNonvirtualVoidMethodA(jobject obj, jclass clazz,
                                   jmethodID methodID, const jvalue * _Nonnull args)
    {
        functions->CallNonvirtualVoidMethodA(this, obj, clazz, methodID, args);
    }

    jfieldID GetFieldID(jclass clazz, const char *name, const char *sig)
    {
        return functions->GetFieldID(this, clazz, name, sig);
    }

    jobject GetObjectField(jobject obj, jfieldID fieldID)
    {
        return functions->GetObjectField(this, obj, fieldID);
    }
    jboolean GetBooleanField(jobject obj, jfieldID fieldID)
    {
        return functions->GetBooleanField(this, obj, fieldID);
    }
    jbyte GetByteField(jobject obj, jfieldID fieldID)
    {
        return functions->GetByteField(this, obj, fieldID);
    }
    jchar GetCharField(jobject obj, jfieldID fieldID)
    {
        return functions->GetCharField(this, obj, fieldID);
    }
    jshort GetShortField(jobject obj, jfieldID fieldID)
    {
        return functions->GetShortField(this, obj, fieldID);
    }
    jint GetIntField(jobject obj, jfieldID fieldID)
    {
        return functions->GetIntField(this, obj, fieldID);
    }
    jlong GetLongField(jobject obj, jfieldID fieldID)
    {
        return functions->GetLongField(this, obj, fieldID);
    }

    jfloat GetFloatField(jobject obj, jfieldID fieldID)
    {
        return functions->GetFloatField(this, obj, fieldID);
    }

    jdouble GetDoubleField(jobject obj, jfieldID fieldID)
    {
        return functions->GetDoubleField(this, obj, fieldID);
    }

    void SetObjectField(jobject obj, jfieldID fieldID, jobject value)
    {
        functions->SetObjectField(this, obj, fieldID, value);
    }
    void SetBooleanField(jobject obj, jfieldID fieldID, jboolean value)
    {
        functions->SetBooleanField(this, obj, fieldID, value);
    }
    void SetByteField(jobject obj, jfieldID fieldID, jbyte value)
    {
        functions->SetByteField(this, obj, fieldID, value);
    }
    void SetCharField(jobject obj, jfieldID fieldID, jchar value)
    {
        functions->SetCharField(this, obj, fieldID, value);
    }
    void SetShortField(jobject obj, jfieldID fieldID, jshort value)
    {
        functions->SetShortField(this, obj, fieldID, value);
    }
    void SetIntField(jobject obj, jfieldID fieldID, jint value)
    {
        functions->SetIntField(this, obj, fieldID, value);
    }
    void SetLongField(jobject obj, jfieldID fieldID, jlong value)
    {
        functions->SetLongField(this, obj, fieldID, value);
    }

    void SetFloatField(jobject obj, jfieldID fieldID, jfloat value)
    {
        functions->SetFloatField(this, obj, fieldID, value);
    }

    void SetDoubleField(jobject obj, jfieldID fieldID, jdouble value)
    {
        functions->SetDoubleField(this, obj, fieldID, value);
    }

    jmethodID GetStaticMethodID(jclass clazz, const char *name, const char *sig)
    {
        return functions->GetStaticMethodID(this, clazz, name, sig);
    }

#define CALL_STATIC_TYPE_METHOD(_jtype, _jname)                           \
    \ _jtype CallStatic##_jname##Method(jclass clazz, jmethodID methodID, \
                                        ...)                              \
    {                                                                     \
        _jtype result;                                                    \
        va_list args;                                                     \
        va_start(args, methodID);                                         \
        result = functions->CallStatic##_jname##MethodV(this, clazz,      \
                                                        methodID, args);  \
        va_end(args);                                                     \
        return result;                                                    \
    }
#define CALL_STATIC_TYPE_METHODV(_jtype, _jname)                             \
    \ _jtype CallStatic##_jname##MethodV(jclass clazz, jmethodID methodID,   \
                                         va_list args)                       \
    {                                                                        \
        return functions->CallStatic##_jname##MethodV(this, clazz, methodID, \
                                                      args);                 \
    }
#define CALL_STATIC_TYPE_METHODA(_jtype, _jname)                             \
    \ _jtype CallStatic##_jname##MethodA(jclass clazz, jmethodID methodID,   \
                                         const jvalue * _Nonnull args)        \
    {                                                                        \
        return functions->CallStatic##_jname##MethodA(this, clazz, methodID, \
                                                      args);                 \
    }

#define CALL_STATIC_TYPE(_jtype, _jname)     \
    CALL_STATIC_TYPE_METHOD(_jtype, _jname)  \
    CALL_STATIC_TYPE_METHODV(_jtype, _jname) \
    CALL_STATIC_TYPE_METHODA(_jtype, _jname)

    CALL_STATIC_TYPE(jobject, Object)
    CALL_STATIC_TYPE(jboolean, Boolean)
    CALL_STATIC_TYPE(jbyte, Byte)
    CALL_STATIC_TYPE(jchar, Char)
    CALL_STATIC_TYPE(jshort, Short)
    CALL_STATIC_TYPE(jint, Int)
    CALL_STATIC_TYPE(jlong, Long)
    CALL_STATIC_TYPE(jfloat, Float)
    CALL_STATIC_TYPE(jdouble, Double)

    void CallStaticVoidMethod(jclass clazz, jmethodID methodID, ...)
    {
        va_list args;
        va_start(args, methodID);
        functions->CallStaticVoidMethodV(this, clazz, methodID, args);
        va_end(args);
    }
    void CallStaticVoidMethodV(jclass clazz, jmethodID methodID, va_list args)
    {
        functions->CallStaticVoidMethodV(this, clazz, methodID, args);
    }
    void CallStaticVoidMethodA(jclass clazz, jmethodID methodID, const jvalue * _Nonnull args)
    {
        functions->CallStaticVoidMethodA(this, clazz, methodID, args);
    }

    jfieldID GetStaticFieldID(jclass clazz, const char *name, const char *sig)
    {
        return functions->GetStaticFieldID(this, clazz, name, sig);
    }

    jobject GetStaticObjectField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticObjectField(this, clazz, fieldID);
    }
    jboolean GetStaticBooleanField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticBooleanField(this, clazz, fieldID);
    }
    jbyte GetStaticByteField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticByteField(this, clazz, fieldID);
    }
    jchar GetStaticCharField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticCharField(this, clazz, fieldID);
    }
    jshort GetStaticShortField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticShortField(this, clazz, fieldID);
    }
    jint GetStaticIntField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticIntField(this, clazz, fieldID);
    }
    jlong GetStaticLongField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticLongField(this, clazz, fieldID);
    }

    jfloat GetStaticFloatField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticFloatField(this, clazz, fieldID);
    }

    jdouble GetStaticDoubleField(jclass clazz, jfieldID fieldID)
    {
        return functions->GetStaticDoubleField(this, clazz, fieldID);
    }

    void SetStaticObjectField(jclass clazz, jfieldID fieldID, jobject value)
    {
        functions->SetStaticObjectField(this, clazz, fieldID, value);
    }
    void SetStaticBooleanField(jclass clazz, jfieldID fieldID, jboolean value)
    {
        functions->SetStaticBooleanField(this, clazz, fieldID, value);
    }
    void SetStaticByteField(jclass clazz, jfieldID fieldID, jbyte value)
    {
        functions->SetStaticByteField(this, clazz, fieldID, value);
    }
    void SetStaticCharField(jclass clazz, jfieldID fieldID, jchar value)
    {
        functions->SetStaticCharField(this, clazz, fieldID, value);
    }
    void SetStaticShortField(jclass clazz, jfieldID fieldID, jshort value)
    {
        functions->SetStaticShortField(this, clazz, fieldID, value);
    }
    void SetStaticIntField(jclass clazz, jfieldID fieldID, jint value)
    {
        functions->SetStaticIntField(this, clazz, fieldID, value);
    }
    void SetStaticLongField(jclass clazz, jfieldID fieldID, jlong value)
    {
        functions->SetStaticLongField(this, clazz, fieldID, value);
    }

    void SetStaticFloatField(jclass clazz, jfieldID fieldID, jfloat value)
    {
        functions->SetStaticFloatField(this, clazz, fieldID, value);
    }

    void SetStaticDoubleField(jclass clazz, jfieldID fieldID, jdouble value)
    {
        functions->SetStaticDoubleField(this, clazz, fieldID, value);
    }

    jstring NewString(const jchar *unicodeChars, jsize len)
    {
        return functions->NewString(this, unicodeChars, len);
    }

    jsize GetStringLength(jstring string)
    {
        return functions->GetStringLength(this, string);
    }

    const jchar *GetStringChars(jstring string, jboolean *isCopy)
    {
        return functions->GetStringChars(this, string, isCopy);
    }

    void ReleaseStringChars(jstring string, const jchar *chars)
    {
        functions->ReleaseStringChars(this, string, chars);
    }

    jstring NewStringUTF(const char *bytes)
    {
        return functions->NewStringUTF(this, bytes);
    }

    jsize GetStringUTFLength(jstring string)
    {
        return functions->GetStringUTFLength(this, string);
    }

    const char *GetStringUTFChars(jstring string, jboolean *isCopy)
    {
        return functions->GetStringUTFChars(this, string, isCopy);
    }

    void ReleaseStringUTFChars(jstring string, const char *utf)
    {
        functions->ReleaseStringUTFChars(this, string, utf);
    }

    jsize GetArrayLength(jarray array)
    {
        return functions->GetArrayLength(this, array);
    }

    jobjectArray NewObjectArray(jsize length, jclass elementClass,
                                jobject initialElement)
    {
        return functions->NewObjectArray(this, length, elementClass,
                                         initialElement);
    }

    jobject GetObjectArrayElement(jobjectArray array, jsize index)
    {
        return functions->GetObjectArrayElement(this, array, index);
    }

    void SetObjectArrayElement(jobjectArray array, jsize index, jobject value)
    {
        functions->SetObjectArrayElement(this, array, index, value);
    }

    jbooleanArray NewBooleanArray(jsize length)
    {
        return functions->NewBooleanArray(this, length);
    }
    jbyteArray NewByteArray(jsize length)
    {
        return functions->NewByteArray(this, length);
    }
    jcharArray NewCharArray(jsize length)
    {
        return functions->NewCharArray(this, length);
    }
    jshortArray NewShortArray(jsize length)
    {
        return functions->NewShortArray(this, length);
    }
    jintArray NewIntArray(jsize length)
    {
        return functions->NewIntArray(this, length);
    }
    jlongArray NewLongArray(jsize length)
    {
        return functions->NewLongArray(this, length);
    }
    jfloatArray NewFloatArray(jsize length)
    {
        return functions->NewFloatArray(this, length);
    }
    jdoubleArray NewDoubleArray(jsize length)
    {
        return functions->NewDoubleArray(this, length);
    }

    jboolean *GetBooleanArrayElements(jbooleanArray array, jboolean *isCopy)
    {
        return functions->GetBooleanArrayElements(this, array, isCopy);
    }
    jbyte *GetByteArrayElements(jbyteArray array, jboolean *isCopy)
    {
        return functions->GetByteArrayElements(this, array, isCopy);
    }
    jchar *GetCharArrayElements(jcharArray array, jboolean *isCopy)
    {
        return functions->GetCharArrayElements(this, array, isCopy);
    }
    jshort *GetShortArrayElements(jshortArray array, jboolean *isCopy)
    {
        return functions->GetShortArrayElements(this, array, isCopy);
    }
    jint *GetIntArrayElements(jintArray array, jboolean *isCopy)
    {
        return functions->GetIntArrayElements(this, array, isCopy);
    }
    jlong *GetLongArrayElements(jlongArray array, jboolean *isCopy)
    {
        return functions->GetLongArrayElements(this, array, isCopy);
    }
    jfloat *GetFloatArrayElements(jfloatArray array, jboolean *isCopy)
    {
        return functions->GetFloatArrayElements(this, array, isCopy);
    }
    jdouble *GetDoubleArrayElements(jdoubleArray array, jboolean *isCopy)
    {
        return functions->GetDoubleArrayElements(this, array, isCopy);
    }

    void ReleaseBooleanArrayElements(jbooleanArray array, jboolean *elems,
                                     jint mode)
    {
        functions->ReleaseBooleanArrayElements(this, array, elems, mode);
    }
    void ReleaseByteArrayElements(jbyteArray array, jbyte *elems,
                                  jint mode)
    {
        functions->ReleaseByteArrayElements(this, array, elems, mode);
    }
    void ReleaseCharArrayElements(jcharArray array, jchar *elems,
                                  jint mode)
    {
        functions->ReleaseCharArrayElements(this, array, elems, mode);
    }
    void ReleaseShortArrayElements(jshortArray array, jshort *elems,
                                   jint mode)
    {
        functions->ReleaseShortArrayElements(this, array, elems, mode);
    }
    void ReleaseIntArrayElements(jintArray array, jint *elems,
                                 jint mode)
    {
        functions->ReleaseIntArrayElements(this, array, elems, mode);
    }
    void ReleaseLongArrayElements(jlongArray array, jlong *elems,
                                  jint mode)
    {
        functions->ReleaseLongArrayElements(this, array, elems, mode);
    }
    void ReleaseFloatArrayElements(jfloatArray array, jfloat *elems,
                                   jint mode)
    {
        functions->ReleaseFloatArrayElements(this, array, elems, mode);
    }
    void ReleaseDoubleArrayElements(jdoubleArray array, jdouble *elems,
                                    jint mode)
    {
        functions->ReleaseDoubleArrayElements(this, array, elems, mode);
    }

    void GetBooleanArrayRegion(jbooleanArray array, jsize start, jsize len,
                               jboolean *buf)
    {
        functions->GetBooleanArrayRegion(this, array, start, len, buf);
    }
    void GetByteArrayRegion(jbyteArray array, jsize start, jsize len,
                            jbyte *buf)
    {
        functions->GetByteArrayRegion(this, array, start, len, buf);
    }
    void GetCharArrayRegion(jcharArray array, jsize start, jsize len,
                            jchar *buf)
    {
        functions->GetCharArrayRegion(this, array, start, len, buf);
    }
    void GetShortArrayRegion(jshortArray array, jsize start, jsize len,
                             jshort *buf)
    {
        functions->GetShortArrayRegion(this, array, start, len, buf);
    }
    void GetIntArrayRegion(jintArray array, jsize start, jsize len,
                           jint *buf)
    {
        functions->GetIntArrayRegion(this, array, start, len, buf);
    }
    void GetLongArrayRegion(jlongArray array, jsize start, jsize len,
                            jlong *buf)
    {
        functions->GetLongArrayRegion(this, array, start, len, buf);
    }
    void GetFloatArrayRegion(jfloatArray array, jsize start, jsize len,
                             jfloat *buf)
    {
        functions->GetFloatArrayRegion(this, array, start, len, buf);
    }
    void GetDoubleArrayRegion(jdoubleArray array, jsize start, jsize len,
                              jdouble *buf)
    {
        functions->GetDoubleArrayRegion(this, array, start, len, buf);
    }

    void SetBooleanArrayRegion(jbooleanArray array, jsize start, jsize len,
                               const jboolean *buf)
    {
        functions->SetBooleanArrayRegion(this, array, start, len, buf);
    }
    void SetByteArrayRegion(jbyteArray array, jsize start, jsize len,
                            const jbyte *buf)
    {
        functions->SetByteArrayRegion(this, array, start, len, buf);
    }
    void SetCharArrayRegion(jcharArray array, jsize start, jsize len,
                            const jchar *buf)
    {
        functions->SetCharArrayRegion(this, array, start, len, buf);
    }
    void SetShortArrayRegion(jshortArray array, jsize start, jsize len,
                             const jshort *buf)
    {
        functions->SetShortArrayRegion(this, array, start, len, buf);
    }
    void SetIntArrayRegion(jintArray array, jsize start, jsize len,
                           const jint *buf)
    {
        functions->SetIntArrayRegion(this, array, start, len, buf);
    }
    void SetLongArrayRegion(jlongArray array, jsize start, jsize len,
                            const jlong *buf)
    {
        functions->SetLongArrayRegion(this, array, start, len, buf);
    }
    void SetFloatArrayRegion(jfloatArray array, jsize start, jsize len,
                             const jfloat *buf)
    {
        functions->SetFloatArrayRegion(this, array, start, len, buf);
    }
    void SetDoubleArrayRegion(jdoubleArray array, jsize start, jsize len,
                              const jdouble *buf)
    {
        functions->SetDoubleArrayRegion(this, array, start, len, buf);
    }

    jint RegisterNatives(jclass clazz, const JNINativeMethod *methods,
                         jint nMethods)
    {
        return functions->RegisterNatives(this, clazz, methods, nMethods);
    }

    jint UnregisterNatives(jclass clazz)
    {
        return functions->UnregisterNatives(this, clazz);
    }

    jint MonitorEnter(jobject obj)
    {
        return functions->MonitorEnter(this, obj);
    }

    jint MonitorExit(jobject obj)
    {
        return functions->MonitorExit(this, obj);
    }

    jint GetJavaVM(JavaVM **vm)
    {
        return functions->GetJavaVM(this, vm);
    }

    void GetStringRegion(jstring str, jsize start, jsize len, jchar *buf)
    {
        functions->GetStringRegion(this, str, start, len, buf);
    }

    void GetStringUTFRegion(jstring str, jsize start, jsize len, char *buf)
    {
        return functions->GetStringUTFRegion(this, str, start, len, buf);
    }

    void *GetPrimitiveArrayCritical(jarray array, jboolean *isCopy)
    {
        return functions->GetPrimitiveArrayCritical(this, array, isCopy);
    }

    void ReleasePrimitiveArrayCritical(jarray array, void *carray, jint mode)
    {
        functions->ReleasePrimitiveArrayCritical(this, array, carray, mode);
    }

    const jchar *GetStringCritical(jstring string, jboolean *isCopy)
    {
        return functions->GetStringCritical(this, string, isCopy);
    }

    void ReleaseStringCritical(jstring string, const jchar *carray)
    {
        functions->ReleaseStringCritical(this, string, carray);
    }

    jweak NewWeakGlobalRef(jobject obj)
    {
        return functions->NewWeakGlobalRef(this, obj);
    }

    void DeleteWeakGlobalRef(jweak obj)
    {
        functions->DeleteWeakGlobalRef(this, obj);
    }

    jboolean ExceptionCheck()
    {
        return functions->ExceptionCheck(this);
    }

    jobject NewDirectByteBuffer(void *address, jlong capacity)
    {
        return functions->NewDirectByteBuffer(this, address, capacity);
    }

    void *GetDirectBufferAddress(jobject buf)
    {
        return functions->GetDirectBufferAddress(this, buf);
    }

    jlong GetDirectBufferCapacity(jobject buf)
    {
        return functions->GetDirectBufferCapacity(this, buf);
    }

    /* added in JNI 1.6 */
    jobjectRefType GetObjectRefType(jobject obj)
    {
        return functions->GetObjectRefType(this, obj);
    }
#endif /*__cplusplus*/
};

/*
 * JNI invocation interface.
 */
struct JNIInvokeInterface
{
    void * _Null_unspecified reserved0;
    void * _Null_unspecified reserved1;
    void * _Null_unspecified reserved2;

    jint (* _Nonnull DestroyJavaVM)(JavaVM * _Nonnull);
    jint (* _Nonnull AttachCurrentThread)(JavaVM * _Nonnull, JNIEnv * _Nullable * _Nullable, void * _Nullable);
    jint (* _Nonnull DetachCurrentThread)(JavaVM * _Nonnull);
    jint (* _Nonnull GetEnv)(JavaVM * _Nonnull, void * _Nullable * _Nullable, jint);
    jint (* _Nonnull AttachCurrentThreadAsDaemon)(JavaVM * _Nonnull, JNIEnv * _Nullable * _Nullable, void * _Nullable);
};

/*
 * C++ version.
 */
struct _JavaVM
{
    const struct JNIInvokeInterface * _Nonnull functions;

#if defined(__cplusplus)
    jint DestroyJavaVM()
    {
        return functions->DestroyJavaVM(this);
    }
    jint AttachCurrentThread(JNIEnv **p_env, void *thr_args)
    {
        return functions->AttachCurrentThread(this, p_env, thr_args);
    }
    jint DetachCurrentThread()
    {
        return functions->DetachCurrentThread(this);
    }
    jint GetEnv(void **env, jint version)
    {
        return functions->GetEnv(this, env, version);
    }
    jint AttachCurrentThreadAsDaemon(JNIEnv **p_env, void *thr_args)
    {
        return functions->AttachCurrentThreadAsDaemon(this, p_env, thr_args);
    }
#endif /*__cplusplus*/
};

struct JavaVMAttachArgs
{
    jint version;     /** must be >= JNI_VERSION_1_2 */
    const char * _Nullable name; /** NULL or name of thread as modified UTF-8 str */
    jobject group;    /** global ref of a ThreadGroup object, or NULL */
};
typedef struct JavaVMAttachArgs JavaVMAttachArgs;

/*
 * JNI 1.2+ initialization.  (As of 1.6, the pre-1.2 structures are no
 * longer supported.)
 */
typedef struct JavaVMOption
{
    const char * _Nullable optionString;
    void * _Nullable extraInfo;
} JavaVMOption;

typedef struct JavaVMInitArgs
{
    jint version; /* use JNI_VERSION_1_2 or later */

    jint nOptions;
    JavaVMOption * _Nonnull options;
    jboolean ignoreUnrecognized;
} JavaVMInitArgs;

#ifdef __cplusplus
extern "C" {
#endif
/*
 * VM initialization functions.
 *
 * Note these are the only symbols exported for JNI by the VM.
 */
#if 0 /* In practice, these are not exported by the NDK so don't declare them */
jint JNI_GetDefaultJavaVMInitArgs(void* _Nonnull);
jint JNI_CreateJavaVM(JavaVM**, JNIEnv**, void* _Nonnull);
jint JNI_GetCreatedJavaVMs(JavaVM**, jsize, jsize* _Nonnull);
#endif

#define JNIIMPORT
#define JNIEXPORT __attribute__((visibility("default")))
#define JNICALL

/*
 * Prototypes for functions exported by loadable shared libs.  These are
 * called by JNI, not provided by JNI.
 */
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM * _Nonnull vm, void * _Null_unspecified reserved);
JNIEXPORT void JNICALL JNI_OnUnload(JavaVM * _Nonnull vm, void * _Null_unspecified reserved);

#ifdef __cplusplus
}
#endif

/*
 * Manifest constants.
 */
#define JNI_FALSE 0
#define JNI_TRUE 1

#define JNI_VERSION_1_1 0x00010001
#define JNI_VERSION_1_2 0x00010002
#define JNI_VERSION_1_4 0x00010004
#define JNI_VERSION_1_6 0x00010006

#define JNI_OK (0)         /* no error */
#define JNI_ERR (-1)       /* generic error */
#define JNI_EDETACHED (-2) /* thread detached from the VM */
#define JNI_EVERSION (-3)  /* JNI version error */

#define JNI_COMMIT 1 /* copy content, do not free buffer */
#define JNI_ABORT 2  /* free buffer w/o copying back */

#endif /* JNI_H_ */
