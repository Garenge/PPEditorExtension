//
//  SourceEditorCommand.swift
//  PPXcodeEditorExtension
//
//  Created by ex_liuzp9 on 2025/9/9.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        switch invocation.commandIdentifier {
        case "\(bundleId).UppercasedCommand":
            uppercaseSelectedText(invocation)
            completionHandler(nil)
        case "\(bundleId).LowercasedCommand":
            lowercaseSelectedText(invocation)
            completionHandler(nil)
        default:
            completionHandler(nil)
        }
    }
    
    private func uppercaseSelectedText(_ invocation: XCSourceEditorCommandInvocation) {
        let selections = invocation.buffer.selections
        guard let firstSelection = selections.firstObject as? XCSourceTextRange else { return }
        
        if firstSelection.start.line == firstSelection.end.line {
            let line = invocation.buffer.lines[firstSelection.start.line] as! String
            let startIndex = line.index(line.startIndex, offsetBy: firstSelection.start.column)
            let endIndex = line.index(line.startIndex, offsetBy: firstSelection.end.column)
            let selectedText = String(line[startIndex..<endIndex])
            let uppercasedText = selectedText.uppercased()
            let newLine = line.replacingCharacters(in: startIndex..<endIndex, with: uppercasedText)
            invocation.buffer.lines[firstSelection.start.line] = newLine
        } else {
            var modifiedLines: [String] = []
            for i in firstSelection.start.line...firstSelection.end.line {
                var line = invocation.buffer.lines[i] as! String
                if i == firstSelection.start.line {
                    let startIndex = line.index(line.startIndex, offsetBy: firstSelection.start.column)
                    let selectedText = String(line[startIndex...])
                    let uppercasedText = selectedText.uppercased()
                    line = line.replacingCharacters(in: startIndex..., with: uppercasedText)
                } else if i == firstSelection.end.line {
                    let endIndex = line.index(line.startIndex, offsetBy: firstSelection.end.column)
                    let selectedText = String(line[..<endIndex])
                    let uppercasedText = selectedText.uppercased()
                    line = line.replacingCharacters(in: ..<endIndex, with: uppercasedText)
                } else {
                    line = line.uppercased()
                }
                modifiedLines.append(line)
            }
            for (index, modifiedLine) in modifiedLines.enumerated() {
                invocation.buffer.lines[firstSelection.start.line + index] = modifiedLine
            }
        }
    }
    
    private func lowercaseSelectedText(_ invocation: XCSourceEditorCommandInvocation) {
        let selections = invocation.buffer.selections
        guard let firstSelection = selections.firstObject as? XCSourceTextRange else { return }
        
        if firstSelection.start.line == firstSelection.end.line {
            let line = invocation.buffer.lines[firstSelection.start.line] as! String
            let startIndex = line.index(line.startIndex, offsetBy: firstSelection.start.column)
            let endIndex = line.index(line.startIndex, offsetBy: firstSelection.end.column)
            let selectedText = String(line[startIndex..<endIndex])
            let lowercasedText = selectedText.lowercased()
            let newLine = line.replacingCharacters(in: startIndex..<endIndex, with: lowercasedText)
            invocation.buffer.lines[firstSelection.start.line] = newLine
        } else {
            var modifiedLines: [String] = []
            for i in firstSelection.start.line...firstSelection.end.line {
                var line = invocation.buffer.lines[i] as! String
                if i == firstSelection.start.line {
                    let startIndex = line.index(line.startIndex, offsetBy: firstSelection.start.column)
                    let selectedText = String(line[startIndex...])
                    let lowercasedText = selectedText.lowercased()
                    line = line.replacingCharacters(in: startIndex..., with: lowercasedText)
                } else if i == firstSelection.end.line {
                    let endIndex = line.index(line.startIndex, offsetBy: firstSelection.end.column)
                    let selectedText = String(line[..<endIndex])
                    let lowercasedText = selectedText.lowercased()
                    line = line.replacingCharacters(in: ..<endIndex, with: lowercasedText)
                } else {
                    line = line.lowercased()
                }
                modifiedLines.append(line)
            }
            for (index, modifiedLine) in modifiedLines.enumerated() {
                invocation.buffer.lines[firstSelection.start.line + index] = modifiedLine
            }
        }
    }
    
}
