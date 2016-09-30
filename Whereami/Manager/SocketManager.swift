//
//  SocketManager.swift
//  Whereami
//
//  Created by WuQifei on 16/2/2.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import AVFoundation
import SocketIOClientSwift


class SocketManager: NSObject {

    typealias BooleanCallback = (Bool) -> Void
    typealias ObjectCallback = (code:Int,[AnyObject]) ->Void

    private static var socketManager:SocketManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    var connectionQueue:dispatch_queue_t {
        return dispatch_queue_create("com.wqf.whereami",DISPATCH_QUEUE_CONCURRENT)
    }
    
    var connectionOptions: Set<SocketIOClientOption> {
        return [.Log(true),.Reconnects(true),.ReconnectAttempts(5),.ReconnectWait(30),.HandleQueue(connectionQueue)]
    }
    
    var socket:SocketIOClient? = nil;
    
    class var sharedInstance:SocketManager {
        dispatch_once(&onceToken) { () -> Void in
            socketManager = SocketManager()
        }
        
        return socketManager!
    }
    
    func connection(callback:BooleanCallback) {
        socket = SocketIOClient(socketURL: NSURL(string: ConfigManager.sharedInstance.ipAddress)!, options: connectionOptions)
        socket!.connect()
        socket!.on("connect") { (passedData:[AnyObject], socketEmitter:SocketAckEmitter) -> Void in
            print("data: \(passedData), socketEmitter: \(socketEmitter)")
            callback(true)
        }
    }
    
    func reconnection(){
        socket!.reconnect()
    }
    
    func disconnection(){
        socket!.disconnect()
    }
    
    func getMsg(onProto:String,callBack:ObjectCallback){
        socket!.on(onProto) { (socketData:[AnyObject], socketEmitter:SocketAckEmitter) in
            callBack(code: 200, socketData)
        }
    }
    
    
    func sendMsg(proto:String,data:AnyObject) {
        socket!.emit(proto,data)
    }
    
    func sendMsg(proto:String,data:AnyObject,onProto:String,callBack:ObjectCallback) {
        
        let onAckBack = socket!.emitWithAck(proto, data)
        onAckBack(timeoutAfter: 0){(passedData:[AnyObject]) ->Void in
            print("got ack: \(passedData)")
        }
        
        //只监听一次
        socket!.once(onProto) { (socketData:[AnyObject], socketEmitter:SocketAckEmitter) -> Void in
            var code:Int? = nil
            if onProto == "accountlisted" || onProto == "getUserDatasByUserNicknameOthered" || onProto == "getUserDatasByUserNicknameed" {
                code = 200
            }
            else{
                let dic = socketData[0] as! NSDictionary
                code = Int(dic["statusCode"] as! NSNumber)
            }
            callBack(code: code!, socketData)
        }
    }
}
