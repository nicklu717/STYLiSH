//
//  FunctionDictionary.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

struct Service {
    let sections: [Section]
}

struct Section {
    let name: String
    let functions: [Function]
}

struct Function {
    let icon: UIImage?
    let name: String
}

private let awaitingPayment = Function(icon: UIImage(named: "Icons_24px_AwaitingPayment"),
                                       name: NSLocalizedString("AwaitingPayment", comment: ""))
private let awaitingShipment = Function(icon: UIImage(named: "Icons_24px_AwaitingShipment"),
                                        name: NSLocalizedString("AwaitingShipment", comment: ""))
private let shipped = Function(icon: UIImage(named: "Icons_24px_Shipped"),
                               name: NSLocalizedString("Shipped", comment: ""))
private let awaitingReview = Function(icon: UIImage(named: "Icons_24px_AwaitingReview"),
                                      name: NSLocalizedString("AwaitingReview", comment: ""))
private let exchange = Function(icon: UIImage(named: "Icons_24px_Exchange"),
                                name: NSLocalizedString("Exchange", comment: ""))

private let starred = Function(icon: UIImage(named: "Icons_24px_Starred"),
                               name: NSLocalizedString("Starred", comment: ""))
private let notification = Function(icon: UIImage(named: "Icons_24px_Notification"),
                                    name: NSLocalizedString("Notification", comment: ""))
private let refunded = Function(icon: UIImage(named: "Icons_24px_Refunded"),
                                name: NSLocalizedString("Refunded", comment: ""))
private let address = Function(icon: UIImage(named: "Icons_24px_Address"),
                               name: NSLocalizedString("Address", comment: ""))
private let customerService = Function(icon: UIImage(named: "Icons_24px_CustomerService"),
                                       name: NSLocalizedString("CustomerService", comment: ""))
private let systemFeedback = Function(icon: UIImage(named: "Icons_24px_SystemFeedback"),
                                      name: NSLocalizedString("SystemFeedback", comment: ""))
private let registerCellphone = Function(icon: UIImage(named: "Icons_24px_RegisterCellphone"),
                                         name: NSLocalizedString("RegisterCellphone", comment: ""))
private let settings = Function(icon: UIImage(named: "Icons_24px_Settings"),
                                name: NSLocalizedString("Settings", comment: ""))

private let myOrder = Section(name: NSLocalizedString("MyOrder", comment: ""),
                              functions: [awaitingPayment,
                                          awaitingShipment,
                                          shipped,
                                          awaitingReview,
                                          exchange])
private let moreSerivce = Section(name: NSLocalizedString("MoreService", comment: ""),
                                  functions: [starred,
                                              notification,
                                              refunded,
                                              address,
                                              customerService,
                                              systemFeedback,
                                              registerCellphone,
                                              settings])

let serviceList = Service(sections: [myOrder, moreSerivce])
