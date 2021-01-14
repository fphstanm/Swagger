//
//  TableViewController.swift
//  Swagger
//
//  Created by Philip on 12.01.2021.
//

import Foundation
import UIKit

fileprivate final class CountedCharacter {
    var char: Character
    var number: Int
    
    init(char: Character, number: Int) {
        self.char = char
        self.number = number
    }
}

final class TableViewController: UIViewController {
    
    @IBOutlet private weak var charactersTableView: UITableView!
    
    private let tableViewCellID = "TableViewCell"
    private let provider = ServiceProvider<SwaggerAPIService>()
    
    private var chars: [CountedCharacter] = [] {
        didSet {
            charactersTableView.reloadData()
        }
    }
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: setup
    
    private func setupSubviews() {
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        charactersTableView.register(UINib(nibName: tableViewCellID, bundle: nil), forCellReuseIdentifier: tableViewCellID)
        charactersTableView.tableFooterView = UIView()
    }
    
    // MARK: data forming
    
    private func countCharacters(inText text: String) -> [CountedCharacter] {
        var result: [CountedCharacter] = []
        text.forEach { char in
            let isInArray = result.contains { $0.char == char }
            if isInArray {
                let existingChar = result.first { $0.char == char }
                existingChar?.number += 1
            } else {
                result.append(CountedCharacter(char: char, number: 1))
            }
        }
        
        return result
    }
    
    // MARK: API requests
    
    private func fetchText() {
        provider.load(service: .text(locale: "ru_RU"), decodeType: ResponseModel<String>.self) { result in
            switch result {
            case .success(let text):
                self.chars = self.countCharacters(inText: text)
            case .failure(let errors):
                let errors1 = errors as? [ResponseError]
                errors1?.forEach { print("Error \($0.status): \($0.name). \($0.message)") }
            case .empty:
                print("Empty")
            }
        }
    }
    
    // MARK: @IBActions
    
    @IBAction private func onButtonTapped(_ sender: Any) {
        fetchText()
    }
    
}


// MARK: - UITableView

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID) as? TableViewCell
        cell?.setup(withCharacter: chars[indexPath.row].char, number: chars[indexPath.row].number)
        
        return cell ?? UITableViewCell()
    }
    
}
