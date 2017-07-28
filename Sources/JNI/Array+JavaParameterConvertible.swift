//
//  Array+JavaParameterConvertible.swift
//  JNI
//
//  Created by flowing erik on 19.07.17.
//

import CJNI

typealias JavaObjectClassName = String

private extension String {
    func replacingFullstopsWithSlashes() -> String {
        let replacedCharacters = self.characters.map { ($0 == ".") ? "/" : $0 }
        return String(String.CharacterView(replacedCharacters))
    }
}

extension Array where Element == JavaParameterConvertible {
    func asJavaParameters() -> [JavaParameter] {
        return self.map { $0.toJavaParameter() }
    }

    /// Returns the String of ordererd arguments for use in JNI method signatures.
    /// For example, the `"II"` in `(II)V`
    private func argumentSignature() -> String {
        return self.reduce("", { $0 + type(of: $1).asJNIParameterString })
    }

    /// Returns the String of ordered arguments enclosed in brackets, followed by the `returnType`'s type string, or 'V'
    /// (Void) if nil is provided. e.g. Returns "(II)V" for `[JavaInt(1), JavaInt(99)].methodSignature(returnType: nil)`
    func methodSignature(returnType: JavaParameterConvertible.Type?) -> String {
        let returnTypeString = returnType?.asJNIParameterString ?? "V"
        return "(" + self.argumentSignature() + ")" + returnTypeString
    }

    func methodSignature(customReturnType: String) -> String {
        let returnTypeString = customReturnType.replacingFullstopsWithSlashes()
        return "(" + self.argumentSignature() + ")" + returnTypeString
    }
}