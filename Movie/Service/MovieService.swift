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
  let sortDescripter = NSSortDescriptor(key: "title", ascending: true)
  request.sortDescriptors = [sortDescripter]
  fetchedContrller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
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
}
