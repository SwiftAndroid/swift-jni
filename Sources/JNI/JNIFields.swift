//
//  JNIFields.swift
//  JNI
//
//  Created by flowing erik on 01.08.17.
//

import CJNI

public extension JNI {
     public func GetStaticField<T: JavaInitializableFromField & JavaParameterConvertible>(_ fieldName: String, on javaClass: JavaClass) throws -> T {
        let env = self._env
        let fieldID = env.pointee.pointee.GetStaticFieldID(env, javaClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromStaticField(fieldID!, of: javaClass)
    }

    public func GetField<T: JavaInitializableFromField & JavaParameterConvertible>(_ fieldName: String, from javaObject: JavaObject) throws -> T {
        let env = self._env
        let javaClass = try GetObjectClass(obj: javaObject)
        let fieldID = env.pointee.pointee.GetFieldID(env, javaClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromField(fieldID!, on: javaObject)
    }
}


public extension JNI {
    // MARK: Fields

    public func GetBooleanField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaBoolean {
        let _env = self._env
        let result = _env.pointee.pointee.GetBooleanField(_env, javaObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetIntField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaInt {
        let _env = self._env
        let result = _env.pointee.pointee.GetIntField(_env, javaObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetFloatField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaFloat {
        let _env = self._env
        let result = _env.pointee.pointee.GetFloatField(_env, javaObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetDoubleField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaDouble {
        let _env = self._env
        let result = _env.pointee.pointee.GetDoubleField(_env, javaObject, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetObjectField(of javaObject: JavaObject, id: JavaFieldID) throws -> JavaObject {
        let _env = self._env
        let result = _env.pointee.pointee.GetObjectField(_env, javaObject, id)
        try checkAndThrowOnJNIError()
        return result!
    }

    // MARK: Static Fields

    public func GetStaticBooleanField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaBoolean {
        let _env = self._env
        let result =  _env.pointee.pointee.GetStaticBooleanField(_env, javaClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetStaticIntField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaInt {
        let _env = self._env
        let result = _env.pointee.pointee.GetStaticIntField(_env, javaClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetStaticFloatField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaFloat {
        let _env = self._env
        let result = _env.pointee.pointee.GetStaticFloatField(_env, javaClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetStaticDoubleField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaDouble {
        let _env = self._env
        let result = _env.pointee.pointee.GetStaticDoubleField(_env, javaClass, id)
        try checkAndThrowOnJNIError()
        return result
    }

    public func GetStaticObjectField(of javaClass: JavaClass, id: JavaFieldID) throws -> JavaObject {
        let _env = self._env
        guard let result = _env.pointee.pointee.GetStaticObjectField(_env, javaClass, id) else { throw JNIError() }
        try checkAndThrowOnJNIError()
        return result
    }
}
