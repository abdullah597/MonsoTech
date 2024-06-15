//
//  HomeVC.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 14/06/2024.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sideMenuBtn: UIButton!
    
    private var sideMenuViewController: SideMenuVC!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    
    private var sideMenuShadowView: UIView!
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.setTopCorners(view: mainView, radius: 30)
        registerNibs()
        setSideMenu()
    }
    func setSideMenu() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    
    self.sideMenuShadowView = UIView(frame: self.view.bounds)
    self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.sideMenuShadowView.backgroundColor = .black
    self.sideMenuShadowView.alpha = 0.0
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.delegate = self
    view.addGestureRecognizer(tapGestureRecognizer)
    if self.revealSideMenuOnTop {
        view.insertSubview(self.sideMenuShadowView, at: 1)
    }
    
    let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC
    view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 4 : 0)
    addChild(self.sideMenuViewController!)
    self.sideMenuViewController!.didMove(toParent: self)
    
    self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    if self.revealSideMenuOnTop {
        self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
        self.sideMenuTrailingConstraint.isActive = true
    }
    NSLayoutConstraint.activate([
        self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
        self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
    ])
    }
    
    func registerNibs() {
        self.tableView.register(UINib(nibName: String(describing: HomeListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HomeListCell.self))
    }
    @IBAction func openMenu(_ sender: Any) {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    @IBAction func connectDevice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: Step1ConnectVC.self)) as? Step1ConnectVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    @IBAction func notifications(_ sender: Any) {
        
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListCell.self)) as? HomeListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        if indexPath.row % 2 == 0 {
            cell.viewButton.isHidden = false
            cell.profileButton.isHidden = true
        } else {
            cell.viewButton.isHidden = true
            cell.profileButton.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: DeviceDetailVC.self)) as? DeviceDetailVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
extension HomeVC {
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    
}
extension HomeVC: UIGestureRecognizerDelegate {
    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

        switch sender.state {
        case .began:

            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha

                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha

                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}

extension HomeVC: HomeListCellDelegate {
    func openProfilePage() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: DeviceProfileVC.self)) as? DeviceProfileVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
    func openViewPage() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: String(describing: DeviceViewVC.self)) as? DeviceViewVC {
            Utilities.shared.pushViewController(currentViewController: self, toViewController: secondViewController, animated: true)
        }
    }
}
