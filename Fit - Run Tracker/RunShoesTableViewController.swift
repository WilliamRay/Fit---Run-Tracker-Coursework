//
//  RunShoesViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 11/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class RunShoesTableViewController: UITableViewController {

    // MARK: - Global Variables

    var run: Run? //A global optional variable to store the run being displayed as a Run object

    /**
    This method is called by the system when the view is first loaded. It configures the view to its initial state ready to display on the screen.
    1. Adds padding to the top of the table view so that it doesn't display under the navigation bar
    2. Declares and initialises the local constant pageControl as a UIPageControl
    3. Sets the number of pages to 3
    4. Sets the current page to 2 (that is the third page)
    5. Sets the page indicator tint colour (the colour of the circles of the not currently shown page)
    6. Sets the current page indicator tint colour (the colour of the circle of the currently shown page)
    7. Sets the position of the page control to the middle of the screen in the x direction and just at the bottom of the table view (-28 pixels for padding)
    8. Adds the page control as a subview of the current view
    
    Uses the following local variables:
        pageControl - A UIPageControl to add to the interface
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets.init(top: navigationController!.navigationBar.frame.size.height, left: 0, bottom: 0, right: 0)

        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 2
        pageControl.pageIndicatorTintColor = UIColor(red: 122/255, green: 195/255, blue: 252/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 142/255, blue: 185/255, alpha: 1)
        pageControl.center = CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height - self.tabBarController!.tabBar.frame.height - 28)

        self.view.addSubview(pageControl)
    }

    /**
    This method is called by the system when the view appears on screen. It loads the table view with the appropriate data in the static cells.
    1. IF there is a run
        a. Declares the local variable finishTimes and initialises it with the tuple returned from the function calculateRunFinishTimes called on the run
        b. Sets the detail text label of the first row in the second section of the table view to the fiveK string of the finishTimes tuple
        c. Sets the detail text label of the second row in the second section of the table view to the tenK string of the finishTimes tuple
        d. Sets the detail text label of the third row in the second section of the table view to the halfMarathon string of the finishTimes tuple
        e. Sets the detail text label of the fourth row in the second section of the table view to the fullMarathon string of the finishTimes tuple
        f. IF there is a shoe 
            i. Sets the text of the first cell in the first section of the table view to the shoe's name
        g. ELSE sets the text of the first cell in the first section of the table view to "None"
    
    Uses the following local variables:
        finishTimes - A tuple of type (string, string, string, string) that stores the 4 finish times
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {
        if let run = run { //1
            //(String - 5k, String - 10k, String - Half, String - Full)
            let finishTimes = run.calculateRunFinishTimes() //a

            tableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath)?.detailTextLabel?.text = finishTimes.fiveK //b
            tableView.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath)?.detailTextLabel?.text = finishTimes.tenK //c
            tableView.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath)?.detailTextLabel?.text = finishTimes.halfMarathon //d
            tableView.cellForRow(at: NSIndexPath(row: 3, section: 1) as IndexPath)?.detailTextLabel?.text = finishTimes.fullMarathon //e

            if let shoe = run.shoe { //f
                tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)?.detailTextLabel?.text = shoe.name //i
            } else { //g
                tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)?.detailTextLabel?.text = "None"
            }
        }
    }

    /**
    This method is called by the system whenever a user selects a row in the table view. It deselects the row and animates the process.
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.setSelected(false, animated: true)
    }

    /**
    This method is called by the system whenever a segue is about to be performed. It prepares the new view ready for display.
    1. IF the destination view controller is a RunShoeSelectorTableViewController
        a. Sets the run of the destinationVC to the current run
    
    :param: segue The UIStoryboardSegue containing the information about the view controllers involved in the segue.
    :param: sender The object that caused the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RunShoeSelectorTableViewController { //1
            destinationVC.run = run //a
        }
    }
}
