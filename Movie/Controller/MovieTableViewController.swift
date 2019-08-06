//
//  MovieTableViewController.swift
//  Movie
//
//  Created by Soni Suman on 8/6/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {
  private var coreData = CoreDataStack()
  private var fetchRequestController : NSFetchedResultsController<Movie>?
  var movieService: MovieService?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      movieService = MovieService(managedObjectContext: coreData.persistentContainer.viewContext)
      loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      if let sections = fetchRequestController?.sections {
        return sections.count
      }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let sections = fetchRequestController?.sections {
        return sections[section].numberOfObjects
      }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
      if let movie = fetchRequestController?.object(at: indexPath) {
         cell.configureCell(movie: movie)
        cell.userRatingHandlers = {[weak self] (newRating) in
         self?.movieService?.updateMovieRating(for: movie, with: newRating)
        }
      }
        return cell
    }

  private func loadData() {
    fetchRequestController = movieService?.getMovies()
  }
}

extension MovieTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    guard let indexPath = indexPath else {
      return
    }
    switch type {
    case .update:
      tableView.reloadRows(at: [indexPath], with: .fade)
    default:
      break
    }
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}
