//
// Copyright (c) Vatsal Manot
//

import FoundationX
import Swallow

// MARK: - Regular Files

extension FileStorage {
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        location: @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions
    ) where UnwrappedType: Codable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: FileURL(location()),
                coder: _AnyTopLevelFileDecoderEncoder(.topLevelDataCoder(coder, forType: UnwrappedType.self)),
                options: options
            )
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        location: @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions
    ) where UnwrappedType: Codable & Initiable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: .init(),
            location: location,
            coder: coder,
            options: options
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType = nil,
        url: @autoclosure @escaping () throws -> URL,
        coder: Coder
    ) where UnwrappedType: Codable & OptionalProtocol, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: nil,
            location: { try url() },
            coder: coder,
            options: nil
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        location: @autoclosure @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions
    ) where UnwrappedType: Codable, ValueType == MutableValueBox<UnwrappedType> {
        let directoryURL: URL = try! location().deletingLastPathComponent()._actuallyStandardizedFileURL
        let url = try! FileURL(location()._actuallyStandardizedFileURL)
        
        try! FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        
        assert(FileManager.default.directoryExists(at: directoryURL))
        
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: url,
                coder: _AnyTopLevelFileDecoderEncoder(.topLevelDataCoder(coder, forType: UnwrappedType.self)),
                options: options
            )
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        _ location: CanonicalFileDirectory,
        path: String,
        coder: Coder,
        options: FileStorageOptions
    ) where UnwrappedType: Codable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: wrappedValue,
            location: try location.toURL().appendingPathComponent(path, isDirectory: false),
            coder: coder,
            options: options
        )
    }
}

extension FileStorage {
    public convenience init(
        wrappedValue: UnwrappedType,
        location: @escaping () throws -> URL,
        options: FileStorageOptions = nil
    ) where UnwrappedType: _FileDocument, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: FileURL(location()),
                coder: _AnyTopLevelFileDecoderEncoder(documentType: UnwrappedType.self),
                options: options
            )
        )
    }
    
    public convenience init(
        wrappedValue: UnwrappedType,
        location: @escaping () throws -> CanonicalFileDirectory,
        options: FileStorageOptions = nil
    ) where UnwrappedType: _FileDocument, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: FileURL(location()),
                coder: _AnyTopLevelFileDecoderEncoder(documentType: UnwrappedType.self),
                options: options
            )
        )
    }
    
    public convenience init(
        wrappedValue: UnwrappedType,
        location: @autoclosure @escaping () -> CanonicalFileDirectory,
        options: FileStorageOptions = nil
    ) where UnwrappedType: _FileDocument, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: wrappedValue,
            location: location,
            options: options
        )
    }
    
    public convenience init(
        location: @autoclosure @escaping () -> CanonicalFileDirectory,
        options: FileStorageOptions = nil
    ) where UnwrappedType: _FileDocument & Initiable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: .init(),
            location: location,
            options: options
        )
    }
    
    public convenience init(
        wrappedValue: UnwrappedType,
        location: @escaping () throws -> URL,
        options: FileStorageOptions = nil
    ) where UnwrappedType: Codable & _FileDocument, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: FileURL(location()),
                coder: _AnyTopLevelFileDecoderEncoder(documentType: UnwrappedType.self),
                options: options
            )
        )
    }
    
    public convenience init(
        wrappedValue: UnwrappedType,
        _ location: CanonicalFileDirectory,
        path: String,
        options: FileStorageOptions = nil
    ) where UnwrappedType: DataCodableWithDefaultStrategies {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: try FileURL(location.toURL().appendingPathComponent(path, isDirectory: false)),
                coder: _AnyTopLevelFileDecoderEncoder(
                    .dataCodableType(
                        UnwrappedType.self,
                        strategy: (
                            decoding: UnwrappedType.defaultDataDecodingStrategy,
                            encoding: UnwrappedType.defaultDataEncodingStrategy
                        )
                    )
                ),
                options: options
            )
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        _ location: CanonicalFileDirectory,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where UnwrappedType: Codable & Initiable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: UnwrappedType(),
            location,
            path: path,
            coder: coder,
            options: options
        )
    }
    
    public convenience init<Coder: TopLevelDataCoder>(
        url: URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where UnwrappedType: Codable & Initiable, ValueType == MutableValueBox<UnwrappedType> {
        self.init(
            wrappedValue: UnwrappedType(),
            location: url,
            coder: coder,
            options: options
        )
    }
}

extension FileStorage {
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        location: @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType> {
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: FileURL(location()),
                coder: _AnyTopLevelFileDecoderEncoder(coder, forUnsafelySerialized: UnwrappedType.self),
                options: options
            )
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        location: @autoclosure @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType> {
        func getURL() -> FileURL {
            let directoryURL = try! location().deletingLastPathComponent()
            let url = try! FileURL(location())
            
            try! FileManager.default.withUserGrantedAccess(to: directoryURL, scope: .directory) {
                try FileManager.default.createDirectory(at: $0, withIntermediateDirectories: true)
                
                assert(FileManager.default.directoryExists(at: directoryURL))
            }
            
            return url
        }
        
        self.init(
            coordinator: try _FileStorageCoordinators.RegularFile(
                initialValue: wrappedValue,
                file: getURL(),
                coder: _AnyTopLevelFileDecoderEncoder(coder, forUnsafelySerialized: UnwrappedType.self),
                options: options
            )
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType,
        _ location: CanonicalFileDirectory,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType> {
        self.init(
            wrappedValue: wrappedValue,
            location: try location.toURL().appendingPathComponent(path, isDirectory: false),
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        location: @autoclosure @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType: Initiable {
        self.init(
            wrappedValue: UnwrappedType(),
            location: location,
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        location: @escaping () throws -> URL,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType: Initiable {
        self.init(
            wrappedValue: UnwrappedType(),
            location: { try location().appending(URL.PathComponent(path)) },
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        location: @autoclosure @escaping () throws -> URL,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType: Initiable {
        self.init(
            wrappedValue: UnwrappedType(),
            location: { try location().appending(URL.PathComponent(path)) },
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder>(
        _ location: CanonicalFileDirectory,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType: Initiable {
        self.init(
            wrappedValue: UnwrappedType(),
            location: try location.toURL().appendingPathComponent(path, isDirectory: false),
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder, Element>(
        location: @autoclosure @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Element, AnyHashable> {
        self.init(
            wrappedValue: IdentifierIndexingArray(id: { ($0 as! (any Identifiable)).id.erasedAsAnyHashable }),
            location: location,
            coder: coder,
            options: options
        )
    }
    
    @_disfavoredOverload
    public convenience init<Coder: TopLevelDataCoder, Element>(
        _ location: CanonicalFileDirectory,
        path: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where ValueType == _UnsafelySerialized<UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Element, AnyHashable> {
        self.init(
            wrappedValue: IdentifierIndexingArray(id: { ($0 as! (any Identifiable)).id.erasedAsAnyHashable }),
            location,
            path: path,
            coder: coder,
            options: options
        )
    }
}

// MARK: - Directories

extension FileStorage {
    public convenience init<Item, ID>(
        directory: @escaping () throws -> URL,
        file: @escaping (_ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>.Element) -> _RelativeFileConfiguration<Item>,
        id: KeyPath<Item, ID>,
        options: FileStorageOptions = nil
    ) where ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            coordinator: try _FileStorageCoordinators.Directory(
                base: _ObservableIdentifiedFolderContents(
                    folder: FileURL(try directory()),
                    fileConfiguration: file,
                    id: { $0[keyPath: id] }
                )
            )
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        directory: @escaping () throws -> URL,
        filename: @escaping (Item) -> URL.Filename,
        coder: Coder,
        id: KeyPath<Item, ID>,
        options: FileStorageOptions = nil
    ) where Item: Codable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            coordinator: try _FileStorageCoordinators.Directory(
                base: _ObservableIdentifiedFolderContents(
                    folder: FileURL(try directory()),
                    fileConfiguration: { element in
                        switch element {
                            case .url(let fileURL):
                                try _RelativeFileConfiguration(
                                    fileURL: fileURL,
                                    coder: _AnyTopLevelFileDecoderEncoder(coder, for: Item.self),
                                    readWriteOptions: options,
                                    initialValue: nil
                                )
                            case .inMemory(let element):
                                try _RelativeFileConfiguration(
                                    path: filename(element).filename(inDirectory: try directory()),
                                    coder: _AnyTopLevelFileDecoderEncoder(coder, for: Item.self),
                                    readWriteOptions: options,
                                    initialValue: nil
                                )
                        }
                    },
                    id: { $0[keyPath: id] }
                )
            )
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        directory: URL,
        filename: KeyPath<Item, URL.Filename>,
        coder: Coder,
        id: KeyPath<Item, ID>,
        options: FileStorageOptions = nil
    ) where Item: Codable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            directory: { directory },
            filename: { $0[keyPath: filename] },
            coder: coder,
            id: id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: URL,
        filename: Filename.Type,
        coder: Coder,
        id: KeyPath<Item, ID>,
        options: FileStorageOptions = nil
    ) where Item: Codable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            directory: { directory },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: URL,
        filename: Filename.Type,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, Item.ID == ID {
        self.init(
            directory: { directory },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: URL,
        path: String,
        filename: Filename.Type,
        id: KeyPath<Item, ID>,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, Item.ID == ID {
        self.init(
            directory: { directory.appendingPathComponent(path, conformingTo: .directory) },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: URL,
        path: String,
        filename: Filename.Type,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, Item.ID == ID {
        self.init(
            directory: { directory.appendingPathComponent(path, conformingTo: .directory) },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: CanonicalFileDirectory,
        path: String,
        filename: Filename.Type,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, Item.ID == ID {
        self.init(
            directory: { try directory.toURL().appendingPathComponent(path, conformingTo: .directory) },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: URL,
        filename: Filename.Type,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, ID == Item.ID {
        self.init(
            directory: { directory },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, Filename: CustomFilenameConvertible & Randomnable, Coder: TopLevelDataCoder>(
        directory: CanonicalFileDirectory,
        path: String?,
        filename: Filename.Type,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, ID == Item.ID {
        self.init(
            directory: { try directory.toURL().appendingDirectoryPathComponent(path) },
            filename: { _ in Filename.random().filenameProvider },
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        location: @escaping () throws -> URL,
        directory: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, Item.ID: CustomFilenameConvertible, ID == Item.ID, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, ID == Item.ID {
        self.init(
            directory: { try location().appendingPathComponent(directory) },
            filename: \.id.filenameProvider,
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        directory: @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & PersistentIdentifierConvertible, Item.PersistentID: CustomFilenameConvertible, ID == Item.PersistentID, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            directory: directory,
            filename: \.persistentID.filenameProvider,
            coder: coder,
            id: \.persistentID,
            options: options
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType = [],
        directory: @escaping () throws -> URL,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, Item.ID: CustomFilenameConvertible, ID == Item.ID, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, ID == Item.ID {
        assert(wrappedValue.isEmpty)
        
        self.init(
            directory: directory,
            filename: \.id.filenameProvider,
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID, Coder: TopLevelDataCoder>(
        wrappedValue: UnwrappedType = [],
        _ location: CanonicalFileDirectory,
        directory: String,
        coder: Coder,
        options: FileStorageOptions = nil
    ) where Item: Codable & Identifiable, Item.ID: CustomFilenameConvertible, ID == Item.ID, ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID>, ID == Item.ID {
        assert(wrappedValue.isEmpty)
        
        self.init(
            directory: { try location.toURL().appendingPathComponent(directory, isDirectory: true) },
            filename: \.id.filenameProvider,
            coder: coder,
            id: \.id,
            options: options
        )
    }
    
    public convenience init<Item, ID>(
        _ location: CanonicalFileDirectory,
        directory: String,
        file: @escaping (_ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>.Element) -> _RelativeFileConfiguration<Item>,
        id: KeyPath<Item, ID>
    ) where ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        self.init(
            directory: {
                try location.toURL().appendingPathComponent(directory, isDirectory: true)
            },
            file: file,
            id: id
        )
    }
    
    public convenience init<Item, ID>(
        wrappedValue: UnwrappedType,
        _ location: CanonicalFileDirectory,
        directory: String,
        file: @escaping (_ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>.Element) -> _RelativeFileConfiguration<Item>,
        id: KeyPath<Item, ID>
    ) where ValueType == _ObservableIdentifiedFolderContents<Item, ID, UnwrappedType>, UnwrappedType == IdentifierIndexingArray<Item, ID> {
        assert(wrappedValue.isEmpty)
        
        self.init(
            location,
            directory: directory,
            file: file,
            id: id
        )
    }
}
