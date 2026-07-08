//
//  JNIFields.swift
//  JNI
//
//  Created by flowing erik on 01.08.17.
//

public extension JNI {
     func GetStaticField<T: JavaInitializableFromField & JavaParameterConvertible>(_ fieldName: String, on javaClass: JavaClass) throws -> T {
        let env = self._env
        let fieldID = env.pointee.GetStaticFieldID(javaClass.asJClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromStaticField(fieldID!, of: javaClass)
    }

    func GetField<T: JavaInitializableFromField & JavaParameterConvertible>(_ fieldName: String, from javaObject: JavaObject) throws -> T {
        let env = self._env
        let javaClass = try GetObjectClass(obj: javaObject)
        defer {
            jni.DeleteLocalRef(javaClass)
        }
        let fieldID = env.pointee.GetFieldID(javaClass.asJClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromField(fieldID!, on: javaObject)
    }

    func GetField(_ fieldName: String, fieldJavaClassName: String, from javaObject: JavaObject) throws -> JavaObject {
        let env = self._env
        let javaClass = try GetObjectClass(obj: javaObject)
        defer {
            jni.DeleteLocalRef(javaClass)
        }
        let fieldID = env.pointee.GetFieldID(javaClass.asJClass, fieldName, "L\(fieldJavaClassName);")
        try checkAndThrowOnJNIError()
        return try JavaObject.fromField(fieldID!, on: javaObject)
    }
}


public extension JNI {
    // MARK: Fields

    func GetBooleanField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaBoolean {
        let _env = self._env
        let result = _env.pointee.GetBooleanField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetIntField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaInt {
        let _env = self._env
        let result = _env.pointee.GetIntField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetFloatField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaFloat {
        let _env = self._env
        let result = _env.pointee.GetFloatField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetLongField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaLong {
        let _env = self._env
        let result = _env.pointee.GetLongField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetDoubleField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaDouble {
        let _env = self._env
        let result = _env.pointee.GetDoubleField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetObjectField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaObject {
        let _env = self._env
        let result = _env.pointee.GetObjectField(javaObject.asJObject, id)
        try checkAndThrowOnJNIError()
        return result!.asJavaObject
    }

    // MARK: Static Fields

    func GetStaticBooleanField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaBoolean {
        let _env = self._env
        let result =  _env.pointee.GetStaticBooleanField(javaClass.asJClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetStaticIntField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaInt {
        let _env = self._env
        let result = _env.pointee.GetStaticIntField(javaClass.asJClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetStaticFloatField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaFloat {
        let _env = self._env
        let result = _env.pointee.GetStaticFloatField(javaClass.asJClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetStaticLongField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaLong {
        let _env = self._env
        let result = _env.pointee.GetStaticLongField(javaClass.asJClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetStaticDoubleField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaDouble {
        let _env = self._env
        let result = _env.pointee.GetStaticDoubleField(javaClass.asJClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    func GetStaticObjectField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaObject {
        let _env = self._env
        guard let result = _env.pointee.GetStaticObjectField(javaClass.asJClass, id)?.asJavaObject else { throw JNIError() }
        try checkAndThrowOnJNIError()
        return result
    }
}
