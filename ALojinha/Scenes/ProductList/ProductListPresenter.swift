//
//  ProductListPresenter.swift
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

protocol ProductListPresentationLogic
{
  func presentProductList(response: ProductListModel.ProductsModel.Response)
    func presentCategory(response: ProductListModel.CategoryModel.Response)
}

class ProductListPresenter: ProductListPresentationLogic
{
  weak var viewController: ProductListDisplayLogic?
  
  // MARK: - Functions
  func presentProductList(response: ProductListModel.ProductsModel.Response)
  {
    var displayedProductList: [ProductListModel.ProductsModel.ViewModel.DisplayedProductList] = []
    for product in response.productsResponse {
        let displayedProducts = ProductListModel.ProductsModel.ViewModel.DisplayedProductList(
            categoryDesc: product.category.descriptionCategory,
            id: product.idProduct,
            name: product.nameProduct,
            urlImagem: product.urlImagemProduct,
            descriptionBS: product.descriptionProduct,
            price1: product.price1Product,
            price2: product.price2Product)
        
        displayedProductList.append(displayedProducts)
    }
    
    let viewModel = ProductListModel.ProductsModel.ViewModel(displayersProductList: displayedProductList)
    viewController?.displayProductList(viewModel: viewModel)
  }
    
    func presentCategory(response: ProductListModel.CategoryModel.Response) {
        var displayedCategory: [ProductListModel.CategoryModel.ViewModel.displayerCategories] = []
        for cat in response.categoryResponse {
            let displayedCategories = ProductListModel.CategoryModel.ViewModel.displayerCategories(
                idCategory: cat.idCategory,
                descriptionCategory: cat.descriptionCategory,
                urlImagemCategory: cat.urlImagemCategory)
            displayedCategory.append(displayedCategories)
        }
        let viewModel = ProductListModel.CategoryModel.ViewModel(displayerCategory: displayedCategory)
        viewController?.displayCategory(viewModel: viewModel)
    }
}
