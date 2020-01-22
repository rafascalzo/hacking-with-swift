//
//  CollectionViewController.swift
//  Project_25_ Multipeer_Connectivity
//
//  Created by FulltrackMobile on 20/01/20.
//  Copyright © 2020 Rafael Scalzo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// Multipeer connectivity requires four new classes:

// MCSession is the manager class that handles all multipeer connectivity for us.
// MCPeerID identifies each user uniquely in a session.
// MCAdvertiserAssistant is used when creating a session, telling others that we exist and handling invitations.
// MCBrowserViewController is used when looking for sessions, showing users who is nearby and letting them join.

// Before I show you the code to get multipeer connectivity up and running, I want to go over what they will do. Most important of all is that all multipeer services on iOS must declare a service type, which is a 15-digit string that uniquely identify your service. Those 15 digits can contain only the letters A-Z, numbers and hyphens, and it's usually preferred to include your company in there somehow.

// Apple's example is, "a text chat app made by ABC company could use the service type abc-txtchat"; for this project I'll be using hws-project25.

// This service type is used by both MCAdvertiserAssistant and MCBrowserViewController to make sure your users only see other users of the same app. They both also want a reference to your MCSession instance so they can take care of connections for you.

private let reuseIdentifier = "ImageView"

class CollectionViewController: UICollectionViewController {
    
    var images = [UIImage]()
    
    // these 3 need to be properies
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let nib = UINib(nibName: "ImageViewCell", bundle: .main)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        navigationController?.isToolbarHidden = false
        let sendText = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleAddNewMessage))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let show = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectedDevices))
        let itens: [UIBarButtonItem] = [sendText, flexible, show]
        setToolbarItems(itens, animated: false)
        
        
        
        // Our peer ID is used to create the session, along with the encryption option of .required to ensure that any data transferred is kept safe.
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func showConnectedDevices() {
        guard let session = mcSession else { return }
        
        if !session.connectedPeers.isEmpty {
            var devices = ""
            session.connectedPeers.forEach { (peerId) in
                devices += "\(peerID.displayName)\n"
            }
            let ac = UIAlertController(title: "Connected devices", message: devices, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func handleAddNewMessage() {
        let ac = UIAlertController(title: "Write message", message: nil, preferredStyle: .alert)
        ac.addTextField { (tf) in
            tf.textColor = .red
        }
        let send = UIAlertAction(title: "send", style: .default) { [weak self] (_) in
            guard let textField = ac.textFields?.first else { return }
            guard textField.text != nil, textField.text != "", let text = textField.text else { return }
            guard let mcSession = self?.mcSession else { return }
            if mcSession.connectedPeers.count > 0 {
                if let dataText = text.data(using: .utf8) {
                    do {
                        try mcSession.send(dataText, toPeers: mcSession.connectedPeers, with: .reliable)
                    } catch {
                        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
            
        }
        ac.addAction(send)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction! = nil) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction! = nil) {
        guard let session = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: session)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageViewCell
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // Check if we have an active session we can use.
        
        guard let mcSession = mcSession else { return }
        // Check if there are any peers to send to.
        if mcSession.connectedPeers.count > 0 {
            // Convert the new image to a Data object.
            if let imageData = image.pngData() {
                // Send it to all peers, ensuring it gets delivered.
                do {
                    //Unreliable networking is usually better for live streaming, where getting the latest data there quickly is more important than ensuring old data arrives.
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // Show an error message if there's a problem.
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
}

extension CollectionViewController: MCSessionDelegate {
    
    // When a user connects or disconnects from our session,
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            let ac = UIAlertController(title: "\(peerID.displayName) has disconnected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async { [weak self] in
                self?.present(ac, animated: true)
            }
            
            
            print("Not connected: \(peerID.displayName)")
            //There’s one final case in there to handle any unknown cases that crop up in the future. While we could have made one of the other cases handle that using a regular default case, in this project none of them really make sense for whatever might occur in the future so implement a dedicated @unknown default case to handle future cases.
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    // Once the data arrives at each peer, the method session(_:didReceive:fromPeer:) will get called with that data, at which point we can create a UIImage from it and add it to our images array. There is one catch: when you receive data it might not be on the main thread, and you never manipulate user interfaces anywhere but the main thread
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else if let text = String(data: data, encoding: .utf8) {
                let ac = UIAlertController(title: text, message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // not today
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // not today
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // not today
    }
}

extension CollectionViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
