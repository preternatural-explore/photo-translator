//
// Copyright (c) Vatsal Manot
//

import Combine
import FoundationX
import Swallow

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension AsyncPersistentStorage {
    public convenience init<Item: Codable, Coder: TopLevelDataCoder>(
        directory: URL,
        predicate: Set<AsyncFolderStorageConfiguration<Item>.Predicate>,
        coder: Coder
    ) where WrappedValue == [Item], ProjectedValue == [Item] {
        do {
            let configuration = AsyncFolderStorageConfiguration<Item>(
                directoryURL: directory,
                filter: { url in
                    !predicate.contains(where: { !$0.evaluate(url) })
                },
                coder: coder
            )
            
            try self.init(base: configuration._makeAsyncPersistentStorageBase())
        } catch {
            fatalError(error)
        }
    }
    
    public convenience init<Item: Codable, Coder: TopLevelDataCoder>(
        directory: CanonicalFileDirectory,
        predicate: Set<AsyncFolderStorageConfiguration<Item>.Predicate>,
        coder: Coder
    ) where WrappedValue == [Item], ProjectedValue == [Item] {
        self.init(
            directory: try! directory.toURL(),
            predicate: predicate,
            coder: coder
        )
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct AsyncFolderStorageConfiguration<Item: Codable> {
    public enum Predicate: Hashable {
        case fileExtension(String)
        
        func evaluate(_ url: URL) -> Bool {
            switch self {
                case .fileExtension(let ext):
                    return url.pathExtension == ext
            }
        }
    }
    
    let directoryURL: URL
    let filter: (URL) -> Bool // FIXME: !!!
    let coder: any TopLevelDataCoder
    
    func _makeAsyncPersistentStorageBase() throws -> _ConcreteFolderAsyncPersistentStorageBase<_AsyncFileResourceCoordinator<Item>> {
        try .init(
            directory: FileURL(directoryURL),
            resource: { file -> _AsyncFileResourceCoordinator<Item>? in
                if let url = (file as? FileURL)?.base {
                    if filter(url) {
                        return .init(
                            file: file,
                            coder: _AnyTopLevelFileDecoderEncoder(.topLevelDataCoder(coder, forType: Item.self))
                        )
                    } else {
                        return nil
                    }
                } else {
                    return .init(
                        file: file,
                        coder: _AnyTopLevelFileDecoderEncoder(.topLevelDataCoder(coder, forType: Item.self))
                    )
                }
            }
        )
    }
}
