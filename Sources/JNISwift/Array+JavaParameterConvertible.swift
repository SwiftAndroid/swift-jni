//
//  Array+JavaParameterConvertible.swift
//  JNISwift
//
//  Created by flowing erik on 19.07.17.
//

extension Array where Element == JavaParameterConvertible {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, parameter) -> String in
            return result + type(of: parameter).asJNIParameterString
        })
        return argumentTypes.asJNIParameterString(with: returnType)
    }
}

extension Array where Element == JavaParameterConvertible.Type {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = self.reduce("", { (result, type) -> String in
            return result + type.asJNIParameterString
        })
        return argumentTypes.asJNIParameterString(with: returnType)
    }
}

private extension String {
    func asJNIParameterString(with returnType: JavaParameterConvertible.Type) -> String {
        return "(" + self + ")" + returnType.asJNIParameterString
    }
}
