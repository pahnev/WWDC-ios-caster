//
//  MultiSelectActionSheet.swift
//  SheeeeeeeeetExample
//
//  Created by Jonas Ullström on 2018-03-16.
//  Copyright © 2018 Jonas Ullström. All rights reserved.
//

/*
 
 This example action sheet demonstrates how to create action
 sheets that use a set of `ActionSheetMultiSelectItem` items,
 which can be used to select one or many items in a section.
 
 The action sheet has two different item sections. Selecting
 an item has no effect on other items in any of the sections,
 since they are multiselect items. The action sheet also has
 an `ActionSheetMultiSelectToggleItem`, which can be used to
 select and deselect all items in both sections.
 
 */

import Sheeeeeeeeet

class MultiSelectActionSheet: ActionSheet {
    
    init(options: [FoodOption], preselected: [FoodOption], action: @escaping ([ActionSheetItem]) -> ()) {
        let items = MultiSelectActionSheet.items(for: options, preselected: preselected)
        super.init(items: items) { sheet, item in
            guard item.isOkButton else { return }
            let selectItems = sheet.items.compactMap { $0 as? ActionSheetSelectItem }
            let selectedItems = selectItems.filter { $0.isSelected }
            action(selectedItems)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension MultiSelectActionSheet {
    
    static func items(for options: [FoodOption], preselected: [FoodOption]) -> [ActionSheetItem] {
        var items = [ActionSheetItem]()
        items.append(titleItem(title: standardTitle))
        items.append(contentsOf: itemsGroup(for: options, preselected: .fast, group: "Appetizer"))
        items.append(ActionSheetSectionMargin())
        items.append(contentsOf: itemsGroup(for: options, preselected: .homeMade, group: "Main Dish"))
        items.append(okButton)
        items.append(cancelButton)
        return items
    }
    
    static func itemsGroup(for options: [FoodOption], preselected: FoodOption?, group: String) -> [ActionSheetItem] {
        var items = [ActionSheetItem]()
        let options = options.filter { $0 != .none && $0 != .fancy }
        let foodItems = options.map { $0.multiSelectItem(isSelected: $0 == preselected, group: group) }
        let toggler = ActionSheetMultiSelectToggleItem(title: group, state: .selectAll, group: group, selectAllTitle: "Select all", deselectAllTitle: "Deselect all")
        items.append(toggler)
        items.append(contentsOf: foodItems)
        return items
    }
}
