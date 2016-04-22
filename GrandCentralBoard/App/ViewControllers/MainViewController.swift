//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


final class MainViewController: UIViewController {

    private let autoStack = AutoStack()
    private let scheduler = Scheduler()
    private let dataDownloader = DataDownloader()
    private lazy var configurationRefresher: ConfigurationRefresher = { ConfigurationRefresher(interval: 30, fetcher: self.configurationFetching) }()

    private lazy var board: GrandCentralBoard = { GrandCentralBoard(scheduler: self.scheduler, stack: self.autoStack) }()

    private lazy var availableBuilders: [WidgetBuilding] = [
        WatchWidgetBuilder(dataDownloader: self.dataDownloader),
        BonusWidgetBuilder(dataDownloader: self.dataDownloader),
        GoogleCalendarWatchWidgetBuilder(),
        HarvestWidgetBuilder(),
        ImageWidgetBuilder(dataDownloader: self.dataDownloader),
        BlogPostsPopularityWidgetBuilder()
    ]

    private lazy var configurationFetching: ConfigurationFetching = {

        let shouldLoadBundledConfig = NSBundle.alwaysUseLocalConfigurationFile || NSProcessInfo.loadBundledConfig

        if shouldLoadBundledConfig {
            return LocalConfigurationLoader(configFileName: NSBundle.localConfigurationFileName,
                                            availableBuilders: self.availableBuilders)
        }

        return ConfigurationDownloader(dataDownloader: self.dataDownloader,
                                       path: NSBundle.remoteConfigurationPath,
                                       builders: self.availableBuilders)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurationRefresher.start()
        //setUpBoardWithConfiguration(configuration)
    }

    private func setUpBoardWithConfiguration(configuration: Configuration) {
        view = autoStack
        do {
            try board.configure(configuration)
        } catch let error {
            showRetryDialogWithMessage(error.userMessage) { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
