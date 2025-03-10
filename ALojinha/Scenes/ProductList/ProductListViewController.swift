//
//  ProductListViewController.swift
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
import IHProgressHUD

protocol ProductListDisplayLogic: class
{
  func displayProductList(viewModel: ProductListModel.ProductsModel.ViewModel)
    func displayCategory(viewModel: ProductListModel.CategoryModel.ViewModel)
}

class ProductListViewController: UIViewController, ProductListDisplayLogic, UITableViewDelegate, UITableViewDataSource
{
  // MARK: - Variables
  var interactor: ProductListBusinessLogic?
  var router: (NSObjectProtocol & ProductListRoutingLogic & ProductListDataPassing)?
    
    let productListCellID = "productListCellID"
    let productDetailSegue = "ProductDetail"
    
    var displayedProducts: [ProductListModel.ProductsModel.ViewModel.DisplayedProductList] = [] {
        didSet {
            tableViewFrame.reloadData()
        }
    }

  // MARK: - Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ProductListInteractor()
    let presenter = ProductListPresenter()
    let router = ProductListRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: - Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad()
  {
    super.viewDidLoad()
    fetchCategory()
    fetchProductList()
  }
  
  // MARK: - Interfaces
    @IBOutlet weak var tableViewFrame: UITableView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
  // MARK: - Functions
    func fetchCategory() {
        let request = ProductListModel.CategoryModel.Request()
        interactor?.requestCategory(request: request)
    }
    
  func fetchProductList()
  {
    IHProgressHUD.show()
    let request = ProductListModel.ProductsModel.Request()
    interactor?.requestProductList(request: request)
  }
  
  func displayProductList(viewModel: ProductListModel.ProductsModel.ViewModel)
  {
    displayedProducts = viewModel.displayersProductList
    IHProgressHUD.dismiss()
    IHProgressHUD.showSuccesswithStatus("Status Sucess")
  }
    
    func displayCategory(viewModel: ProductListModel.CategoryModel.ViewModel)
    {
        let displayedCategory = viewModel.displayerCategory[0].descriptionCategory
        categoryTitleLabel.text = "Games" // displayedCategory
    }
    
    // MARK: - Table view Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFrame.dequeueReusableCell(withIdentifier: productListCellID, for: indexPath) as! ProductListViewCell
        let displayedProductListCell = self.displayedProducts[indexPath.row]
        cell.productsCell = displayedProductListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productSelected = self.displayedProducts[indexPath.row]
        performSegue(withIdentifier: productDetailSegue, sender: productSelected)
    }
    
    // MARK: - Button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

class ProductListViewCell: UITableViewCell {
    
    // MARK: - Interface Cell
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var price1LabelCell: UILabel!
    @IBOutlet weak var price2LabelCell: UILabel!
    
    // MARK: - Life Cycle Cell
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Variables Cell
    var productsCell: ProductListModel.ProductsModel.ViewModel.DisplayedProductList? {
        didSet {
            if let image = productsCell?.urlImagem {
                imageViewCell.sd_setImage(with: URL(string: image), placeholderImage: UIImage(imageLiteralResourceName: "logoSobre_1.png"), options: [.continueInBackground])
            }
            
            if let title = productsCell?.name {
                titleLabelCell.text = title
            }
            
            if let price1 = productsCell?.price1 {
                let labelPrice1 = "De: \(String(format:"%.2f", price1))"
                price1LabelCell.attributedText = labelPrice1.strikeThrough()
                price1LabelCell.text = labelPrice1
            }
            
            if let price2 = productsCell?.price2 {
                price2LabelCell.text = "Por: \(String(format:"%.2f", price2))"
            }
        }
    }
}
