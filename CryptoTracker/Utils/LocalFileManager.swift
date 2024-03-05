//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 28/02/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }

    func saveImage (image : UIImage , imageName : String , folderName : String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData() ,
                let url  = getURLImageName(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        }catch let error {
            print("Error while saving image. \(error)")
        }
    }
    
    func getImage (imageName  : String , folderName : String) -> UIImage? {
        guard let url = getURLImageName(imageName: imageName, folderName: folderName) ,
              FileManager.default.fileExists(atPath: url.path)
        else { return nil}
        
        return UIImage(contentsOfFile: url.path)
    }
    private func createFolderIfNeeded (folderName : String) {
        guard let url = getURLFolderName(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error while creating a directory. \(error) ")
            }
        }
    }
    
    private func getURLFolderName (folderName : String ) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    private func getURLImageName (imageName: String , folderName : String) -> URL? {
        guard let folderURL = getURLFolderName(folderName: folderName ) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
 
}
