//
//  ActionSheetStandardPresenter.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2017-11-27.
//  Copyright © 2017 Daniel Saidi. All rights reserved.
//

/*
 
 This presenter presents action sheets as regular iOS action
 sheets, which are presented with a slide-in from the bottom
 of the screen.
 
 The `presentationStyle` property will affect how the action
 sheet is presented. The default `keyWindow` option uses the
 entire application window and will present the action sheet
 in full screen. The `currentContext` option uses the source
 view controller's view bounds instead.
 
 */

import UIKit

open class ActionSheetStandardPresenter: ActionSheetPresenter {
    
    
    // MARK: - Initialization
    
    public init() {}
    
    
    // MARK: - Properties
    
    public var events = ActionSheetPresenterEvents()
    public var isDismissableWithTapOnBackground = true
    public var presentationStyle = PresentationStyle.currentContext
    
    var actionSheet: ActionSheet?
    var animationDelay: TimeInterval = 0
    var animationDuration: TimeInterval = 0.3
    
    
    // MARK: - Types
    
    public enum PresentationStyle {
        case keyWindow, currentContext
    }
    
    
    // MARK: - ActionSheetPresenter
    
    open func dismiss(completion: @escaping () -> ()) {
        completion()
        removeBackgroundView()
        removeActionSheet {
            self.actionSheet?.view.removeFromSuperview()
            self.actionSheet = nil
        }
    }
    
    open func present(sheet: ActionSheet, in vc: UIViewController, from view: UIView?, completion: @escaping () -> ()) {
        present(sheet: sheet, in: vc, completion: completion)
    }
    
    open func present(sheet: ActionSheet, in vc: UIViewController, from item: UIBarButtonItem, completion: @escaping () -> ()) {
        present(sheet: sheet, in: vc, completion: completion)
    }
    
    open func present(sheet: ActionSheet, in vc: UIViewController, completion: @escaping () -> ()) {
        actionSheet = sheet
        addActionSheet(sheet, to: vc)
        addBackgroundViewTapAction(to: sheet.backgroundView)
        presentBackgroundView()
        presentActionSheet(completion: completion)
    }
    
    open func refreshActionSheet() {
        guard let sheet = actionSheet else { return }
        sheet.topMargin?.constant = sheet.margin(at: .top)
        sheet.leftMargin?.constant = sheet.margin(at: .left)
        sheet.rightMargin?.constant = sheet.margin(at: .right)
        sheet.bottomMargin?.constant = sheet.margin(at: .bottom)
    }
    
    
    // MARK: - Protected Functions

    open func addBackgroundViewTapAction(to view: UIView?) {
        view?.isUserInteractionEnabled = true
        let action = #selector(backgroundViewTapAction)
        let tap = UITapGestureRecognizer(target: self, action: action)
        view?.addGestureRecognizer(tap)
    }
    
    open func animate(_ animation: @escaping () -> ()) {
        animate(animation, completion: nil)
    }
    
    open func animate(_ animation: @escaping () -> (), completion: (() -> ())?) {
        guard animationDuration >= 0 else { return }
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            options: [.curveEaseOut],
            animations: animation) { _ in completion?() }
    }
    
    open func presentActionSheet(completion: @escaping () -> ()) {
        guard let view = actionSheet?.stackView else { return }
        let frame = view.frame
        view.frame.origin.y += frame.height + 100
        let animation = { view.frame = frame }
        animate(animation, completion: completion)
    }
    
    open func presentBackgroundView() {
        guard let view = actionSheet?.backgroundView else { return }
        view.alpha = 0
        let animation = { view.alpha = 1 }
        animate(animation)
    }

    open func removeActionSheet(completion: @escaping () -> ()) {
        guard let view = actionSheet?.stackView else { return }
        let animation = { view.frame.origin.y += view.frame.height + 100 }
        animate(animation) { completion() }
    }

    open func removeBackgroundView() {
        guard let view = actionSheet?.backgroundView else { return }
        let animation = { view.alpha = 0 }
        animate(animation)
    }
}


// MARK: - Internal Functions

extension ActionSheetStandardPresenter {
    
    func addActionSheetToKeyWindow(_ sheet: ActionSheet) {
        let window = UIApplication.shared.keyWindow
        sheet.view.frame = window?.bounds ?? .zero
        window?.addSubview(sheet.view)
    }
    
    func addActionSheet(_ sheet: ActionSheet, to vc: UIViewController) {
        if presentationStyle == .keyWindow { return addActionSheetToKeyWindow(sheet) }
        let view = vc.view
        sheet.view.frame = view?.bounds ?? .zero
        view?.addSubview(sheet.view)
    }
}


// MARK: - Actions

@objc public extension ActionSheetStandardPresenter {
    
    func backgroundViewTapAction() {
        guard isDismissableWithTapOnBackground else { return }
        events.didDismissWithBackgroundTap?()
        dismiss {}
    }
}
