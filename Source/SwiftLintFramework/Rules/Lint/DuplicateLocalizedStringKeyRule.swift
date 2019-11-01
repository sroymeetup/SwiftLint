//
//  DuplicateLocalizedStringKeyRule.swift
//  swiftlint
//
//  Created by Steve Roy on 2019-11-01.
//  Copyright © 2019 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct DuplicateLocalizedStringKeyRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    private static var knownKeys = [String]()
    
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "duplicate_localized_string_key",
        name: "Duplicate Localized String Key",
        description: "Keys used in NSLocalizedString should be unique.",
        kind: .lint,
        nonTriggeringExamples: [
            "NSLocalizedString(\"key 1\", comment: \"Text 1\")",
            "NSLocalizedString(\"key 2\", comment: \"Text 2\")"
        ],
        triggeringExamples: [
            "NSLocalizedString(\"key\", comment: \"Text 1\")",
            "NSLocalizedString(↓\"key\", comment: \"Text 2\")"
        ]
    )

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation] {
        guard kind == .call,
            dictionary.name == "NSLocalizedString",
            let firstArgument = dictionary.enclosedArguments.first,
            firstArgument.name == nil,
            let offset = firstArgument.offset,
            let length = firstArgument.length,
            let key = file.contents.bridge().substringWithByteRange(start: offset, length: length) else {
                return []
        }
        
        if !DuplicateLocalizedStringKeyRule.knownKeys.contains(key) {
            DuplicateLocalizedStringKeyRule.knownKeys.append(key)
            return []
        }
        
        return [
            StyleViolation(ruleDescription: type(of: self).description,
                severity: configuration.severity,
                location: Location(file: file, byteOffset: offset))
        ]
    }
}
