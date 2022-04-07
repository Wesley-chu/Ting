//
//  MenuViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    static func instantiate() -> MenuViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        return vc
    }
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    
    func initView(){
        self.navigationController?.navigationBar.barTintColor = .white
        menuView.layer.shadowOpacity = 0.2
        menuView.layer.shadowRadius = 3
        menuView.layer.shadowOffset = CGSize(width: -1.0, height: 3.0)
        
        let inquiry = menuView.subviews[0].subviews[0]
        let evaluation = menuView.subviews[0].subviews[1]
        //let twitter = menuView.subviews[0].subviews[2]
        
        let tapEvaluation = UITapGestureRecognizer(target: self, action: #selector(tapEvaluation(tap:)))
        let tapInquiry = UITapGestureRecognizer(target: self, action: #selector(tapInquiry(tap:)))
        evaluation.addGestureRecognizer(tapEvaluation)
        inquiry.addGestureRecognizer(tapInquiry)
    }
    
    @objc func tapEvaluation(tap: UITapGestureRecognizer){
        SKStoreReviewController.requestReview()
    }

    @objc func tapInquiry(tap: UITapGestureRecognizer){
        // メールを送信できるかどうかの確認
          if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
          }

          // インスタンスの作成とデリゲートの委託
          let mailViewController = MFMailComposeViewController()
              mailViewController.mailComposeDelegate = self

          // 宛先の設定（開発者側のアドレス）
          let toRecipients = ["own236@icloud.com"]

          // 件名と宛先の表示
          mailViewController.setSubject("問い合わせ")
          mailViewController.setToRecipients(toRecipients)
          mailViewController.setMessageBody("", isHTML: false)

          // mailViewControllerの反映（メール内容の反映）
          self.present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // メールの結果で条件分岐
         switch result {
         // キャンセルの場合
         case .cancelled:
           print("Email Send Cancelled")
           break
         // 下書き保存の場合
         case .saved:
           print("Email Saved as a Draft")
           break
         // 送信成功の場合
         case .sent:
            print("Email Sent Successfully")
            //メールを閉じる
            controller.dismiss(animated: true) {
                AlertView.shared.normalAlert(title: "", message: "送信成功", okTitle: "確認", cancel: false, contro: self) { _ in }
            }
           break
         // 送信失敗の場合
         case .failed:
            print("Email Send Failed")
            AlertView.shared.normalAlert(title: "", message: "送信失敗", okTitle: "確認", cancel: false, contro: controller) { _ in }
           break
         default:
           break
         }

    }

    
    


}
