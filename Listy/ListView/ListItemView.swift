//
//  ListItemView.swift
//  ListTest
//
//  Created by Cristian Palage on 3/23/26.
//

import SwiftUI
import SwiftData


enum ListStyle {
    static let fontSize: CGFloat = 18
    static let titleFontSize: CGFloat = 20
    static let rowHeight: CGFloat = 44
    static let horizontalPadding: CGFloat = 20
}

struct ListItemView: View {

    static let height = ListStyle.rowHeight

    let item: ListItem

    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: ListStyle.fontSize))
                .strikethrough(item.crossedOut)
                .frame(height: Self.height)
                .padding(.horizontal, ListStyle.horizontalPadding)
                .foregroundStyle(item.crossedOut ? .secondary : .primary)
            Spacer()
            if !item.items.isEmpty {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.trailing, ListStyle.horizontalPadding)
            }
        }
    }
}
