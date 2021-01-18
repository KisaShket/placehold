//
//  DataCacher.swift
//  TestExcApp
//
//  Created by Kisa Shket on 17.01.2021.
//
import Foundation
import UIKit
class DataCacher {
    let defaults = UserDefaults.standard
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        if let pathURL = URL.init(string: documentsDirectory.path) {
            let dataURL = pathURL.appendingPathComponent("Images")
            
            if !FileManager.default.fileExists(atPath: dataURL.path){
                do {
                    try FileManager.default.createDirectory(atPath: dataURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        }
        else {
            print("Error in URL path");
        }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent("Images").appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let lastUpdate = defaults.object(forKey: "lastUpdate") as? Date
            if lastUpdate != nil{
                let date = Date()
                let timeintervalInSecs = date.timeIntervalSince(lastUpdate!)
                if timeintervalInSecs >= 60{
                    FileManager.removeAllFilesDirectory()
                }
            }
        }
        do {
            try data.write(to: fileURL, options: .atomic)
            self.defaults.set(Date(), forKey: "lastUpdate")
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        
        if let pathURL = URL.init(string: documentsDirectory.path) {
            let dataURL = pathURL.appendingPathComponent("Images")
            
            let imageUrl = URL(fileURLWithPath: dataURL.path).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
            
        }
        return nil
    }
    
    func loadImageFromDiskWith(index: Int) ->UIImage?{
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        
        let fileName = Constants.kQueryPath + String(index+1)
        if let pathURL = URL.init(string: documentsDirectory.path) {
            let dataURL = pathURL.appendingPathComponent("Images")
            
            let imageUrl = URL(fileURLWithPath: dataURL.path).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func isImgExist(index: Int) -> Bool{
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return false}
        let fileName = Constants.kQueryPath + String(index+1)
        let fileURL = documentsDirectory.appendingPathComponent("Images")
            .appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: fileURL.path)
        
    }
    
}



extension FileManager {
    public static func removeAllFilesDirectory() {
        let fileManager = FileManager()
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let imagesPath = path.appendingPathComponent("Images")
        
        do {
            let content = try fileManager.contentsOfDirectory(atPath: imagesPath.path)
            content.forEach { file in
                do {
                    try fileManager.removeItem(atPath: URL(fileURLWithPath: imagesPath.path).appendingPathComponent(file).path)
                } catch let error{
                    print(error.localizedDescription)
                }
            }
        } catch let err{
            print(err.localizedDescription)
        }
    }
}
