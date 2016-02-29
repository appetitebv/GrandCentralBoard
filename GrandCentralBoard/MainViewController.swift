//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var board: GrandCentralBoard!
    var configuration: Configuration!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            board = try GrandCentralBoard(configuration: configuration)
            view = board.view
        } catch let error as CustomStringConvertible {
            showError(error.description)
        } catch {
            showError("Unknown error")
        }
    }

    private func showError(message: String) {

        let title = "Error"
        let buttonTitle = "Retry"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let doneAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { [weak self] _ in
            self?.navigationController?.popViewControllerAnimated(true)
        }

        alert.addAction(doneAction)

        presentViewController(alert, animated: true, completion: nil)
    }
}
