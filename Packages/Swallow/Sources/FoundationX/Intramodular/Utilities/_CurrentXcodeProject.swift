//
// Copyright (c) Vatsal Manot
//

#if os(macOS)

import Foundation
import Swallow

public struct _CurrentXcodeProject {
    @usableFromInline
    static let fileManager = FileManager.default
    
    public static func buildLogsPath() -> URL? {
        let environment = ProcessInfo.processInfo.environment
        
        if let derivedDataPath = environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] {
            let logsDirectory = URL(fileURLWithPath: derivedDataPath)
                .appendingPathComponent("../../../Logs/Build")
                .resolvingSymlinksInPath()
            
            return logsDirectory
        }
        
        if _isDebugAssertConfiguration() {
            runtimeIssue("Failed to get build logs path.")
        }
        
        return nil
    }

    public static func findXcodeProjAndInfoPlistUsingDebugHints(
        initialPath: String
    ) -> (xcodeProj: URL?, infoPlist: URL?) {
        let projPath = findItem(ofType: XcodeProject(), around: initialPath)
        let plistPath = findItem(ofType: InfoPlist(), around: initialPath, selector: { plists in
            // Custom selection logic for multiple Info.plist files (if needed)
            return plists.first  // Placeholder for custom selection logic
        })
        
        return (projPath, plistPath)
    }
    
    public static func findItem<T: SearchableItem>(
        ofType type: T,
        around path: String,
        selector: (([URL]) -> URL?)? = nil
    ) -> URL? {
        var currentPath = URL(fileURLWithPath: path)
        
        while currentPath.path != "/" {
            if let contents = try? fileManager.contentsOfDirectory(at: currentPath, includingPropertiesForKeys: nil),
               let matches = contents.filter({ type.match(url: $0) }) as [URL]? {
                if let selector = selector, matches.count > 1 {
                    return selector(matches)
                } else if let match = matches.first {
                    return match
                }
            }
            currentPath.deleteLastPathComponent()
        }
        
        return nil
    }
}

extension _CurrentXcodeProject {
    /// Update the UTI declarations in the Info.plist file for the given Xcode project using a list of UTI objects.
    public static func updateUTTypes(
        _ utis: [_ApplicationInfoPlist.UTI],
        file: String = #file
    ) {
        guard let plistURL = findXcodeProjAndInfoPlistUsingDebugHints(initialPath: file).infoPlist else {
            fatalError("Error: Info.plist file not found.")
        }
        
        do {
            var plistData = try Data(contentsOf: plistURL)
            var plistFormat = PropertyListSerialization.PropertyListFormat.xml // Default format
            var plistDict = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as? [String: Any]
            
            let documentTypesEncoder = PropertyListEncoder()
            documentTypesEncoder.outputFormat = .xml
            let documentTypesData = try documentTypesEncoder.encode(utis.generateDocumentTypes())
            let documentTypesArray = try PropertyListSerialization.propertyList(from: documentTypesData, options: [], format: &plistFormat) as? [[String: Any]]
            
            let utiEncoder = PropertyListEncoder()
            utiEncoder.outputFormat = .xml
            let utiData = try utiEncoder.encode(utis)
            let utiArray = try PropertyListSerialization.propertyList(from: utiData, options: [], format: &plistFormat) as? [[String: Any]]
            
            plistDict?["CFBundleDocumentTypes"] = documentTypesArray
            plistDict?["UTImportedTypeDeclarations"] = utiArray ?? []
            plistDict?["UTExportedTypeDeclarations"] = utiArray ?? []
            
            plistData = try PropertyListSerialization.data(fromPropertyList: plistDict!, format: plistFormat, options: 0)
            try plistData.write(to: plistURL)
            
            print("UTI declarations updated successfully.")
        } catch {
            print("Error updating UTI declarations: \(error)")
        }
    }
}

extension _CurrentXcodeProject {
    public protocol SearchableItem {
        var fileExtension: String { get }
        var fileName: String? { get }
        func match(url: URL) -> Bool
    }
    
    struct XcodeProject: SearchableItem {
        @usableFromInline
        let fileExtension = "xcodeproj"
        @usableFromInline
        let fileName: String? = nil
    }
    
    struct InfoPlist: SearchableItem {
        @usableFromInline
        let fileExtension = "plist"
        @usableFromInline
        let fileName: String? = "Info"
    }
}

extension _CurrentXcodeProject.SearchableItem {
    internal func match(url: URL) -> Bool {
        return url.pathExtension == fileExtension && (fileName == nil || url.deletingPathExtension().lastPathComponent == fileName)
    }
}

#endif
