//
//  ConfigurationsView.swift
//  ToDoListApp
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import UIKit

class ConfigurationsView: UIView {
    
    //MARK: - Properties
    var defaultDeadline: Date {
        return CalendarProvider.calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) ?? Date()
    }
    
    private lazy var calendarSelectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter
    }
    
    //MARK: - UIElements
    private lazy var mainVerticalStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .white
        s.layer.cornerRadius = 15
        s.axis = .vertical
        return s
    }()
    
    private lazy var importanceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var importanceSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["!","нет","!!"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.setImage(UIImage(systemName: "arrow.down"), forSegmentAt: 0)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(importanceSegmentControlPressed), for: .valueChanged)
        return sc
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deadlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var deadlineSwitch: UISwitch = {
        let deadSwitch = UISwitch()
        deadSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadSwitch.addTarget(self, action: #selector(deadlineSwitchPressed), for: .touchUpInside)
        return deadSwitch
    }()
    
    private lazy var deadlineLabelDate: UILabel = {
        let label = UILabel()
        label.text = "2 июня 2021"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .blue
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deadlineStackViewLabelButton: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var calendarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var calendarView: UICalendarView = {
        let view = UICalendarView()
        view.calendar = .current
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    

    func setup() {

        backgroundColor = .systemGray5
        addSubview(mainVerticalStack)
        
        mainVerticalStack.addArrangedSubview(importanceView)
        mainVerticalStack.addArrangedSubview(deadlineView)
        mainVerticalStack.addArrangedSubview(calendarContainer)
        
        importanceView.addSubview(importanceLabel)
        importanceView.addSubview(importanceSegmentControl)
        importanceView.addSubview(dividerView)
        
        deadlineView.addSubview(deadlineStackViewLabelButton)
//        deadlineView.addSubview(deadlineLabel)
//        deadlineView.addSubview(deadlineButton)
        deadlineView.addSubview(deadlineSwitch)
        deadlineView.addSubview(dividerView2)
        
        deadlineStackViewLabelButton.addArrangedSubview(deadlineLabel)
        deadlineStackViewLabelButton.addArrangedSubview(deadlineLabelDate)
        
        calendarContainer.addSubview(calendarView)
    
        NSLayoutConstraint.activate([
            
            mainVerticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainVerticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVerticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            importanceLabel.topAnchor.constraint(equalTo: importanceView.topAnchor, constant: 17),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: 16),
            
            importanceSegmentControl.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor),
            importanceSegmentControl.trailingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -12.25),
            
            dividerView.topAnchor.constraint(equalTo: importanceLabel.bottomAnchor, constant: 17),
            dividerView.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: importanceView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
//            deadlineLabel.topAnchor.constraint(equalTo: deadlineView.topAnchor, constant: 8),
//            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
//            deadlineButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor),
//            deadlineButton.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
//            deadlineButton.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor, constant: -8),
            deadlineStackViewLabelButton.topAnchor.constraint(equalTo: deadlineView.topAnchor, constant: 8),
            deadlineStackViewLabelButton.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
            deadlineStackViewLabelButton.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor, constant: -16),
            
            deadlineSwitch.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor),
            deadlineSwitch.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor, constant: -14.5),
            
            dividerView2.topAnchor.constraint(equalTo: deadlineStackViewLabelButton.bottomAnchor, constant: 17),
            dividerView2.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
            dividerView2.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor, constant: -16),
            dividerView2.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor),
            dividerView2.heightAnchor.constraint(equalToConstant: 0.5),
            
            calendarView.topAnchor.constraint(
                equalTo: calendarContainer.topAnchor,
                constant: 8
            ),
            calendarView.leadingAnchor.constraint(
                greaterThanOrEqualTo: calendarContainer.leadingAnchor,
                constant: 16
            ),
            calendarView.trailingAnchor.constraint(
                lessThanOrEqualTo: calendarContainer.trailingAnchor,
                constant: -16
            ),
            calendarView.bottomAnchor.constraint(
                equalTo: calendarContainer.bottomAnchor,
                constant: -8
            )
            
        ])
    }
    
    @objc
    func deadlineSwitchPressed() {
        
        deadlineLabelDate.text = dateFormatter.string(from: defaultDeadline)
        calendarSelectionBehavior.selectedDate = makeDefaultDateComponents()
        calendarView.selectionBehavior = calendarSelectionBehavior
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.deadlineLabelDate.isHidden.toggle()
            self?.calendarContainer.isHidden.toggle()
            self?.dividerView2.isHidden.toggle()
        }
    }
    
    @objc func importanceSegmentControlPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print(ToDoItem.Importance.notImportant.rawValue)
        } else if sender.selectedSegmentIndex == 1 {
            print(ToDoItem.Importance.usual.rawValue)
        } else {
            print(ToDoItem.Importance.important.rawValue)
        }
    }
    
    private func makeDefaultDateComponents() -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: defaultDeadline
        )
        return dateComponents
    }

}

extension ConfigurationsView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard
            let dateComponents,
            let date = dateComponents.date
        else {
            return
        }
        
        print(date)
    }
}
