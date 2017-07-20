//
//  Array+JavaParameterConvertible.swift
//  JNISwift
//
//  Created by flowing erik on 19.07.17.
//

extension Array where Element == JavaParameterConvertible {
    func methodSignature(returnType: JavaParameterConvertible.Type? = nil) -> String {
        return getMethodSignature(from: self, reducer: {
            return $0 + type(of: $1).asJNIParameterString
        }, returnType: returnType)
    }
}

extension Array where Element == JavaParameterConvertible.Type {
    func methodSignature(returnType: JavaParameterConvertible.Type? = nil) -> String {
        return getMethodSignature(from: self, reducer: {
            return $0 + $1.asJNIParameterString
        }, returnType: returnType)
    }
}

private func getMethodSignature<T>(from arr: [T], reducer: (String, T) -> String, returnType: JavaParameterConvertible.Type?) -> String {
    let argumentTypes = arr.reduce("", reducer)
    return argumentTypes.asJNIParameterString(with: returnType)
}

private extension String {
    func asJNIParameterString(with returnType: JavaParameterConvertible.Type?) -> String {
        let returnTypeString = returnType?.asJNIParameterString ?? "V"
        return "(" + self + ")" + returnTypeString
    }
}
