//
//  CustomActionSheet.swift
//  GridList
//
//  Created by Obada on 1/23/21.
//

import UIKit



class CustomActionSheet: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView! 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    // MARK: Properties
    var delegate: ActionSheetDelegate?
    // MARK: Controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPanGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareBackgroundView()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 350
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: Controller's customization
    
    func prepareBackgroundView() {
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds

        view.insertSubview(bluredView, at: 0)
    }
    
    func addPanGestureRecognizer() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
            view.addGestureRecognizer(gesture)
    }
    
    // Call this method to customize the action sheet
    func customizeWith(_ title: String, _ firstButtonTitle: String, _ secondButtonTitle: String) {
        containerView.layer.cornerRadius = 32
        
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.text = title
        
        firstButton.appStyle(title: firstButtonTitle, backgroundColor: .white, titleColor: .black)
        secondButton.appStyle(title: secondButtonTitle)
    }
    
    // MARK: Actions
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        // dismiss the screen if it's panned all the way down
        switch recognizer.state {
        case .ended:
            if recognizer.location(in: self.view).y > 20 {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @IBAction func onTapFirstButton(_ sender: Any) {
        // close and call delegate
        self.dismiss(animated: true) {
            self.delegate?.firstButtonPressed()
        }
    }
    
    @IBAction func onTapSecondButton(_ sender: Any) {
        // close and call delegate
        if !self.isBeingDismissed  {
            self.dismiss(animated: true) {
                self.delegate?.secondButtonPressed()
            }
        }
        
    }
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
