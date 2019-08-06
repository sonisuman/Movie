//
//  MovieService.swift
//  Movie
//
//  Created by Soni Suman on 8/6/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import Foundation
import CoreData

class MovieService {
  
  private var moc: NSManagedObjectContext?
  init(managedObjectContext: NSManagedObjectContext) {
    self.moc = managedObjectContext
  }
  
  func getMovies() -> NSFetchedResultsController<Movie> {
    let fetchedContrller: NSFetchedResultsController<Movie>
    let request: NSFetchRequest<Movie> = Movie.fetchRequest()
    let formatSortDescripter = NSSortDescriptor(key: "format", ascending: true)
    let nameSortDescripter = NSSortDescriptor(key: "title", ascending: true)
    request.sortDescriptors = [formatSortDescripter,nameSortDescripter]
    fetchedContrller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: "format", cacheName: "cacheLibrary")
    do {
      try fetchedContrller.performFetch()
    } catch {
      fatalError("error on fetch data")
    }
    return fetchedContrller
  }
  func updateMovieRating(for movie: Movie, with newRating: Int) {
    movie.userRating = Int16(newRating)
    do {
      try moc?.save()
    } catch {
      print("error is=== \(error.localizedDescription)")
    }
  }
  
  func resetAllRating(completion: (Bool) -> Void ) {
    let batchUpdate =  NSBatchUpdateRequest(entityName: "Movie")
    batchUpdate.propertiesToUpdate = ["userRating" : 0]
    batchUpdate.resultType = .updatedObjectIDsResultType
    do {
      let result = try moc?.execute(batchUpdate) as? NSBatchUpdateResult
      guard let objectIDArray = result?.result as? [NSManagedObjectID] else { return}
      for object in objectIDArray {
        let managedObject = moc?.object(with: object)
        if !managedObject!.isFault {
          moc?.stalenessInterval = 0
          moc?.refresh(managedObject!, mergeChanges: true)
        }
    }
      completion(true)
    }
  catch {
      completion(false)
      fatalError("Failed to perform batch update: \(error)")
  
    }
  }
}
