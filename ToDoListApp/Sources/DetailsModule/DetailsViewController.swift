//
//  DetailsViewController.swift
//  ToDoListApp
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cохранить", style: .done, target: self, action: #selector(saveButtonPressed))
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    

    @objc
    private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonPressed() {
        print("saved")
    }

}
