////
////  ViewController.swift
////  hangman
////
////  Created by rafaeldelegate on 10/26/19.
////  Copyright © 2019 rafaeldelegate. All rights reserved.
////
//
//import UIKit
//
//class NachoCell1: UICollectionViewCell {
//    
//    var imageView: UIImageView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    func setupImage() {
//        backgroundColor = .white
//        imageView.image = UIImage(named: "dorito")
//        addSubview(imageView)
//        imageView.frame = self.frame
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class HangmanController1: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 55, height: 55)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return nachos.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NACHO", for: indexPath) as! NachoCell1
//        cell.setupImage()
//        cell.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
//        cell.backgroundColor = .lightGray
//        return cell
//    }
//    
//    
//    var date: Date!
//    var words = [String]()
//    var nachos = [UIImage]()
//    var therm:Int = 1
//    var options = [Int]()
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 23
//        layout.minimumInteritemSpacing = 23
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.delegate = self
//        cv.dataSource = self
//        return cv
//    }()
//    
//    lazy var button: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = .blue
//        btn.addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
//        btn.setTitle("Manda Ve", for: .normal)
//        btn.layer.cornerRadius = 12
//        return btn
//    }()
//    
//    @objc func handleTapped(_ sender: UIButton) {
//        print(therm)
//        let result = fibonnacci(therm)
//        print(result)
//        
//        if result == 0 {
//            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.collectionView.alpha = 1
//            }) { (_) in
//                return
//                
//            }
//            return
//        }
//        nachos = [UIImage]()
//        for _ in 0...result {
//            nachos.append(UIImage(named: "dorito")!)
//        }
//        collectionView.reloadData()
//        
//        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.collectionView.alpha = 1
//        }) { (_) in
//            //
//        }
//    }
//    
//    lazy var picker: UIPickerView = {
//        let pv = UIPickerView()
//        pv.translatesAutoresizingMaskIntoConstraints = false
//        pv.delegate = self
//        pv.dataSource = self
//        return pv
//    }()
//    
//    override func loadView() {
//        view = UIView()
//        view.backgroundColor = .white
//        
//        collectionView.register(NachoCell1.self, forCellWithReuseIdentifier: "NACHO")
//        
//        view.addSubview(picker)
//        picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        picker.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        
//        view.addSubview(button)
//        button.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 25).isActive = true
//        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        
//        view.addSubview(collectionView)
//        collectionView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
//        
//        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        
//        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        
//        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        collectionView.alpha = 0
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        for i in 0...300 {
//            options.append(i)
//        }
//        
//        picker.reloadAllComponents()
//        
//        //        guard let url = Bundle.main.url(forResource: "hangmans-words", withExtension: "txt") else {
//        //            print("o mano fudeo aqui na linha 25")
//        //            return }
//        //
//        //        do {
//        //            let data = try String(contentsOf: url)
//        //            let lines = data.components(separatedBy: "\n")
//        //
//        //            for line in lines {
//        //                print(line)
//        //                words.append(line)
//        //            }
//        //        } catch let error {
//        //            print(error.localizedDescription)
//        //        }
//        
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    // 1 = 1
//    // 2 = 1 + 0 = 1
//    // 3 = 1 + 2 = 2
//    // 4 = 3 + 2 = 3
//    // 5 = 4 + 3 = 5
//    
//    func fibonnacci (_ posicao:Int) -> Int {
//        print("oh maigod")
//        if posicao == 1 {
//            return 0
//        } else if ( posicao == 2) {
//            return 1
//        }else {
//            return fibonnacci(posicao - 1) + fibonnacci(posicao - 2)
//        }
//    }
//    
//    
//    
//}
//extension HangmanController1: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.options.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "The \(self.options[row] + 1) element of FibonnaNacho seqquence"
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        therm = options[row + 1]
//    }
//    
//    
//}
