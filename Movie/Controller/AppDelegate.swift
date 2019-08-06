//
//  AppDelegate.swift
//  Movie
//
//  Created by Andi Setiyadi on 6/7/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private var coreData = CoreDataStack()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    checkData()
    return true
  }
  
  // MARK: - Private
  
  private func checkData() {
    let moc = coreData.persistentContainer.viewContext
    let request: NSFetchRequest<Movie> = Movie.fetchRequest()
    if let dataCount = try? moc.count(for: request), dataCount > 0  {
      return
    }
    uploadSampleData()
  }
  private func uploadSampleData() {
    let moc = coreData.persistentContainer.viewContext
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"), let data = try? Data(contentsOf: url), let jsonRequest = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary) as NSDictionary??), let jsonArray = jsonRequest?.value(forKey: "movie")as? NSArray else {
      return
    }
    
    for jsonElement in jsonArray {
      guard let movieObj = jsonElement as? [String: AnyObject],let title = movieObj["name"] as? String, let rating = movieObj["rating"],let format = movieObj["format"] as? String
        else{return}
      
      let movie = Movie(context: moc)
      movie.format = format
      movie.title = title
      movie.userRating = rating.int16Value
      if let imageName = movieObj["image"] as? String {
        let image = UIImage(named: imageName)
        if let imageCompressionData = image?.jpegData(compressionQuality: 1.0) {
           movie.image = NSData.init(data: imageCompressionData)
        }
      }
      coreData.saveContext()
    }
    
  }
}

