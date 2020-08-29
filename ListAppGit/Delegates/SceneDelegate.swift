//
//  SceneDelegate.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coreList: [NSManagedObject] = []
    var currentNode = Node(value: "Home")
    var rootNode = Node(value: "root")
    var baseListView: ListTableView?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        loadFromDisk()
        parseLists()
        createViewController()

        guard let baseListView = baseListView else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController: UINavigationController = {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [baseListView]
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
            navigationController.navigationBar.tintColor = .black
            return navigationController
        }()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate {
    func loadFromDisk() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        do {
            coreList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func parseLists() {
        let list = parseToRootNode(list: coreList.last?.value(forKeyPath: "listString") as? String ?? "[Home]")
        currentNode = list
        rootNode = list
    }

    func createViewController() {
        let vm = ListTableViewModel(currentList: currentNode, rootNode: rootNode)
        baseListView = ListTableView(viewModel: vm)
    }
}

