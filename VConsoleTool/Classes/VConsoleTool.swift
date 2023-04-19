//
//  VConsoleTool.swift
//  VConsoleTool
//
//  Created by 吴添培 on 2023/4/18.
//

import UIKit
import WebKit

public class VConsoleTool: NSObject {
    
    public static let shared = VConsoleTool()
    
    let bundle: Bundle = {
        guard let path = Bundle(for: VConsoleTool.self).resourcePath,
              let bundle = Bundle(path: path)
               else {
            return Bundle.main
        }
        
        return bundle
        
    }()
    
    open func loadVConsoleScript() -> WKUserScript? {
        guard let path = bundle.path(forResource: "pass", ofType: "js"),
              let file = try? String.init(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }
        
        return WKUserScript.init(source: file, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }

}
