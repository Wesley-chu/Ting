//
//  EncryptionRSA.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/14.
//

import Foundation

public final class EncryptionRSA {
    public static let shared = EncryptionRSA()
    public let tagForPrivateKey = "test1".data(using: .utf8)
    //暗号化に使用するアルゴリズムを定義
    let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
    
    //秘密鍵作成、keychainに保存
    private func createKey(){
        //秘密鍵のattributeを指定
        let attributes: [String:Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA, //暗号鍵のタイプ（RSAを指定）
            kSecAttrKeySizeInBits as String: 2048, //暗号鍵のbit数（2048-bitを指定）
            kSecPrivateKeyAttrs as String:[
                kSecAttrIsPermanent as String: true, //keychainに保存するか
                kSecAttrApplicationTag as String: tagForPrivateKey
            ]//タグを指定
        ]
        var error: Unmanaged<CFError>?
        //秘密鍵の作成
        guard let generatePrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("error1")
            return
        }
        print("privatekey: \(generatePrivateKey)")
    }
    
    private func getStatus(item:inout CFTypeRef?) -> OSStatus {
        //秘密鍵を検索するクエリを作成
        let getquery: [String:Any] = [
            kSecClass as String: kSecClassKey, //取得する情報の種類（暗号鍵、証明書、バスワードなど）
            kSecAttrApplicationTag as String: tagForPrivateKey, //秘密鍵についてるタグ
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA, //秘密鍵のタイプ
            kSecReturnRef as String: true //秘密鍵の参照情報を取得するか（この参照情報を使用して公開鍵の作成などを行う）
        ]
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        return status
    }
    
    //keychainから秘密鍵を取得する
    private func createOrTakePrivateKey() -> SecKey? {
        var item: CFTypeRef?
        var status = getStatus(item: &item)
        
        //秘密鍵が取得できたかどうか検証
        switch status {
        case errSecSuccess,errSecDuplicateItem: //成功、特定のアイテムが既にキーチェーンに存在する
            //取得した秘密鍵を変数retrievedPrivateKeyに代入
            let retrievedPrivateKey = item as! SecKey
            return retrievedPrivateKey
        //利用可能なキーチェーンが存在しない//特定のアイテムがキーチェーンの中に見つけられなかった
        case errSecNotAvailable,errSecItemNotFound:
            createKey()
            status = getStatus(item: &item)
            if status == errSecSuccess{
                let retrievedPrivateKey = item as! SecKey
                return retrievedPrivateKey
            }else{
                print("\(status),error2")
                return nil
            }
        default:
            print("\(status),error3")
            return nil
        }
    }
    
    //暗号化
    func encrypt(text: String?) -> String? {
        var error: Unmanaged<CFError>?
        guard let text = text else { print("error4"); return nil }
        guard let privateKey = createOrTakePrivateKey() else { print("error5"); return nil }
        
        //公開鍵の作成
        let generatedPublicKey = SecKeyCopyPublicKey(privateKey)
        
        //指定した公開鍵が上記のアルゴリズムをサーポーとしているか検証
        guard SecKeyIsAlgorithmSupported(generatedPublicKey!, .encrypt, algorithm) else { print("error6"); return nil }
        
        //平文と公開鍵のblock長を比較
        guard (text.count < (SecKeyGetBlockSize(generatedPublicKey!)-130)) else { print("error7"); return nil }
        
        //平文をData型に変換
        let textData = text.data(using: .utf8)!
        
        //平文の暗号化
        guard let cipherText = SecKeyCreateEncryptedData(
                generatedPublicKey!,
                algorithm,
                textData as CFData,
                &error) as Data? else { print("error8"); return nil }
        
        //暗号化した平文をbase64でデコードし、string型に変換
        let textString = cipherText.base64EncodedString()
        print("cipherTextString: \(textString)")
        return textString
    }
    
    //復号
    func decrypt(text: String?) -> String?{
        var error: Unmanaged<CFError>?
        guard let text = text else { print("error9"); return nil }
        guard let privateKey = createOrTakePrivateKey() else { print("error10"); return nil }
        //string型の暗号文をbase64でデコードしdata型に変換
        let decryptedCipherText = Data(base64Encoded: text, options: [])
        
        //指定した秘密鍵が上記のアルゴリズムをサポートしているか検証
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else { print("error11"); return nil }
        
        //暗号文と秘密鍵のblock長を比較
       // guard (text.count == SecKeyGetBlockSize(privateKey!) else { print("error10"); return nil }
        
        //data型に変換した暗号文を復号
        guard let clearText = SecKeyCreateDecryptedData(
                privateKey,
                algorithm,
                decryptedCipherText! as CFData,
                &error) as Data? else { print("error12"); return nil }
        
        //復号したデータをstring型に変換
        guard let clearTextString = String(data: clearText, encoding: .utf8) else { print("error13"); return nil }
        print("clearTextString:\(clearTextString)")
        return clearTextString
    }
    
}
