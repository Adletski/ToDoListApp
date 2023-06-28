//
//  DetailsViewController.swift
//  ToDoListApp
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    
    //MARK: - UIElements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.font = .systemFont(ofSize: 17)
        textView.layer.cornerRadius = 16
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.text = "Что надо сделать?"
        return textView
    }()
    
    lazy var configurationsView: ConfigurationsView = {
        let view = ConfigurationsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()

    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemGray5
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cохранить", style: .done, target: self, action: #selector(saveButtonPressed))
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(configurationsView)
        stackView.addArrangedSubview(deleteButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            deleteButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
            
        ])
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
