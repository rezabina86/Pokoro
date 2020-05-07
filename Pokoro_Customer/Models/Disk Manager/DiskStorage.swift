//
//  DiskStorage.swift
//  TESTTSET
//
//  Created by Reza Bina on 2020-05-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class DiskStorage {
    private let queue: DispatchQueue
    private let fileManager: FileManager
    private let path: URL
    
    init(
        path: URL,
        fileManager: FileManager = .default,
        queue: DispatchQueue = .init(label: "DiskCache.Queue")
    ) {
        self.queue = queue
        self.fileManager = fileManager
        self.path = path
    }
}

extension DiskStorage: Storage {
    
    func fetchValue(for key: String) throws -> Data {
        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }
    
    func fetchValue(for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            handler(Result { try self.fetchValue(for: key) })
        }
    }
    
    func save(value: Data, for key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try createFolders(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }
    
    func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                try self.save(value: value, for: key)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
    }
    
}

extension DiskStorage {
    
    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
}
