//
//  ViewController.swift
//  ImgClassificationExampleApp
//
//  Created by Vanda S. on 27/02/2024.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "titleColor")
        label.text = "Jaguar or Leopard?"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    let descriptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "titleColor")
        label.text = "Upload an image of cat in question and find out yourself!"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.tintColor = .systemGray6
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let pickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pick new image", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapImage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(descriptLabel)
        view.addSubview(imageView)
        view.addSubview(resultLabel)
        view.addSubview(pickerButton)
        
        setTitleLabel()
        setDescriptionLabel()
        setImageView()
        setResultLabel()
        setPickerButton()

    }
    
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
    }
    
    func setDescriptionLabel() {
        descriptLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10).isActive = true
        descriptLabel.widthAnchor.constraint(equalToConstant: view.frame.width-60).isActive = true
        descriptLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        descriptLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
    }
    
    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: descriptLabel.bottomAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width-40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2-40).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
    }
    
    func setResultLabel() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        resultLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        resultLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40).isActive = true
        resultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resultLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
    }
    
    func setPickerButton() {
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        pickerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.frame.height/7)).isActive = true
        pickerButton.widthAnchor.constraint(equalToConstant: view.frame.width-60).isActive = true
        pickerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pickerButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
    }


    func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 224, height: 224))?.getCVPixelBuffer() else {
            return
        }
        do {
            let config = MLModelConfiguration()
            let model = try JaguarOrLeopard(configuration: config)
            let input = JaguarOrLeopardInput(image: buffer)
            
            let output = try model.prediction(input: input)
            let text = output.target
            resultLabel.text = "Found cat: \(text)"
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //cancel
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        analyzeImage(image: image)
    }
}

