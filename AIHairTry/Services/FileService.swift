//
//  FileManager.swift
//  AIHairTry
//
//  Created by Hieu on 3/21/23.
//

import Foundation

extension URL {
    func appendingCompat(_ path: String) -> URL {
        if #available(iOS 16.0, *) {
            return self.appending(path: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
    
    var pathCompat: String {
        if #available(iOS 16.0, *) {
            return self.path()
        } else {
            return self.path
        }
    }

    
    func creatingDirectoryIfNotExist() -> URL {
        let fm = FileManager.default
        
        do {
            try fm.createDirectory(at: self, withIntermediateDirectories: true)
        } catch {
            print("Failed to create directory: \(error)")
        }
        return self
    }
}

extension FileManager {
    func clearTempDirectory() {
        let fileManager = FileManager.default
        let temporaryDirectory = fileManager.temporaryDirectory
        try? fileManager
            .contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            .forEach { file in
                try? fileManager.removeItem(atPath: file.path)
            }
    }
}

struct FileService {
    private static let fm = FileManager.default
    
    static var appDirectory: URL {
        return fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static var appTemporaryDirectory = fm.temporaryDirectory
    
    static var hairImageDirectory: URL {
        return appTemporaryDirectory.appendingCompat("captured-hair-images").creatingDirectoryIfNotExist()
    }
    
    static var hairModelDirectory: URL {
        return appTemporaryDirectory.appendingCompat("hair-models").creatingDirectoryIfNotExist()
    }
    
    static func listHairImageUrls() -> [URL] {
        do {
            let fileUrls = try fm.contentsOfDirectory(at: hairImageDirectory, includingPropertiesForKeys: nil)
            return fileUrls
        } catch {
            print("Error while listing hair images: \(error)")
        }
        return []
    }
}
