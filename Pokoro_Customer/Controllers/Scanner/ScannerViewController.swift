//
//  ScannerViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerViewControllerDelegate: class {
    func scannerViewController(_ controller: ScannerViewController, didScan code: String)
    func scannerViewControllerBackButtonDidTapped(_ controller: ScannerViewController)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let blurView: UIVisualEffectView! = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 10
        return view
    }()
    
    private let caption: LargeSB = {
        let label = LargeSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Point your camera at a POKORO code."
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let placeholder: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "scan_placeholder")
        return view
    }()
    
    private var navBar: UINavigationBar = {
        let view = UINavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.zPosition = 5
        return view
    }()
    
    weak var delegate: ScannerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        setupViews()
        
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBlurViewHole()
    }
    
    private func setupViews() {
        let navItem = UINavigationItem(title: "Scan")
        let navBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissButtonDidTap(_:)))
        navItem.leftBarButtonItem = navBarButton
        navBar.items = [navItem]
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.zPosition = 0
        view.layer.addSublayer(previewLayer)
        
        view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        blurView.contentView.addSubview(caption)
        caption.bottomAnchor.constraint(equalTo: blurView.contentView.safeBottomAnchor, constant: -45).isActive = true
        caption.leadingAnchor.constraint(equalTo: blurView.contentView.safeLeadingAnchor, constant: 24).isActive = true
        caption.trailingAnchor.constraint(equalTo: blurView.contentView.safeTrailingAnchor, constant: -24).isActive = true
        
//        blurView.contentView.addSubview(placeholder)
//        placeholder.bottomAnchor.constraint(equalTo: caption.topAnchor, constant: -10).isActive = true
//        placeholder.centerXAnchor.constraint(equalTo: blurView.contentView.safeCenterXAnchor, constant: 0).isActive = true
    }
    
    func updateBlurViewHole() {
        
        let maskView = UIView(frame: blurView.bounds)
        maskView.clipsToBounds = true
        maskView.backgroundColor = .clear
        
        let outerbezierPath = UIBezierPath.init(roundedRect: blurView.bounds, cornerRadius: 0)
        let rect = CGRect(x: view.center.x - 125, y: view.center.y - 175, width: 250, height: 250)
        let innerCirclepath = UIBezierPath.init(roundedRect:rect, cornerRadius:15)
        outerbezierPath.append(innerCirclepath)
        outerbezierPath.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.green.cgColor
        fillLayer.path = outerbezierPath.cgPath
        maskView.layer.addSublayer(fillLayer)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = innerCirclepath.cgPath
        borderLayer.lineWidth = 5
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = blurView.bounds
        blurView.layer.addSublayer(borderLayer)
        
        blurView.mask = maskView
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        delegate?.scannerViewController(self, didScan: code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc
    private func dismissButtonDidTap(_ sender: UIBarButtonItem) {
        delegate?.scannerViewControllerBackButtonDidTapped(self)
    }
    
}
