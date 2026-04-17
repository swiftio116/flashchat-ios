import UIKit
import PhotosUI
import UniformTypeIdentifiers
import CoreLocation

final class ChatViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var attachButton: UIButton!
    
    private let viewModel = ChatViewModel()
    private let locationManager = CLLocationManager()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        messageTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(
            UINib(nibName: K.cellNibName, bundle: nil),
            forCellReuseIdentifier: K.cellIdentifier
        )
        
        setupKeyboardObservers()
        setupTapGesture()
        bindViewModel()
        
        viewModel.startListening()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        viewModel.stopListening()
    }
    
    @IBAction func attachPressed(_ sender: UIButton) {
        showAttachmentMenu()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendCurrentMessage()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        viewModel.logout()
    }
    
    private func bindViewModel() {
        viewModel.onMessagesUpdated = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollToBottom(animated: true)
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Error",
                    message: errorMessage,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.onLogoutSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrameValue.cgRectValue.height
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.scrollToBottom(animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func sendCurrentMessage() {
        let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }
        
        viewModel.sendMessage(text: text) { [weak self] in
            DispatchQueue.main.async {
                self?.messageTextField.text = ""
                self?.scrollToBottom(animated: true)
            }
        }
    }
    
    private func scrollToBottom(animated: Bool) {
        let count = viewModel.messagesCount
        guard count > 0 else { return }
        
        let lastRow = count - 1
        
        guard tableView.numberOfSections > 0,
              tableView.numberOfRows(inSection: 0) > lastRow else {
            return
        }
        
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    private func showAttachmentMenu() {
        let alert = UIAlertController(
            title: "Send Attachment",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "📷 Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "🖼 Gallery", style: .default) { [weak self] _ in
            self?.openGallery()
        })
        
        alert.addAction(UIAlertAction(title: "📄 File", style: .default) { [weak self] _ in
            self?.openFilePicker()
        })
        
        alert.addAction(UIAlertAction(title: "📍 Location", style: .default) { [weak self] _ in
            self?.sendLocation()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = attachButton
            popover.sourceRect = attachButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showSimpleAlert(title: "Camera Unavailable", message: "This device does not have a camera.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openFilePicker() {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                .pdf,
                .text,
                .plainText,
                .image,
                .data,
                .content
            ],
            asCopy: true
        )
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func sendLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            
        case .denied, .restricted:
            showSimpleAlert(
                title: "Location Access Denied",
                message: "Please allow location access in Settings."
            )
            
        @unknown default:
            break
        }
    }
    
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.cellIdentifier,
            for: indexPath
        ) as! MessageCell
        
        let message = viewModel.message(at: indexPath.row)
        
        cell.configure(
            with: message,
            isCurrentUser: viewModel.isCurrentUserMessage(message),
            formatter: timeFormatter
        )
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentMessage()
        return false
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ChatViewController {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showSimpleAlert(title: "Gallery Error", message: error.localizedDescription)
                }
                return
            }
            
            guard let image = object as? UIImage else { return }
            
            DispatchQueue.main.async {
                print("Selected gallery image: \(image)")
                // Upload image to Firebase Storage later
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ChatViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        DispatchQueue.main.async {
            print("Captured image: \(image)")
            // Upload image to Firebase Storage later
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension ChatViewController {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        DispatchQueue.main.async {
            print("Selected file: \(url.lastPathComponent)")
            // Upload file to Firebase Storage later
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension ChatViewController {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let locationText = "📍 Location: \(latitude), \(longitude)"
        
        viewModel.sendMessage(text: locationText) { [weak self] in
            DispatchQueue.main.async {
                self?.scrollToBottom(animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showSimpleAlert(title: "Location Error", message: error.localizedDescription)
    }
}
