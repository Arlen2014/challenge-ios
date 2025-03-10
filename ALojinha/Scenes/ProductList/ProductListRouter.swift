//
//  ProductListRouter.swift
//  ALojinha
//
//  Created by Arlen on 05/05/19.
//  Copyright (c) 2019 Arlen Ricardo Pereira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ProductListRoutingLogic
{
  func routeToProductDetail(segue: UIStoryboardSegue?)
}

protocol ProductListDataPassing
{
  var dataStore: ProductListDataStore? { get }
}

class ProductListRouter: NSObject, ProductListRoutingLogic, ProductListDataPassing
{
  weak var viewController: ProductListViewController?
  var dataStore: ProductListDataStore?
  
  // MARK: - Routing
  func routeToProductDetail(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! ProductDetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToProductDetail(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToProductDetail(source: dataStore!, destination: &destinationDS)
      navigateToProductDetail(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: - Navigation
  func navigateToProductDetail(source: ProductListViewController, destination: ProductDetailViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: - Passing data
  func passDataToProductDetail(source: ProductListDataStore, destination: inout ProductDetailDataStore)
  {
    let selected = viewController?.tableViewFrame.indexPathForSelectedRow?.row
    let productSelected = source.product?[selected!]
    destination.productDetail = productSelected
  }
}
