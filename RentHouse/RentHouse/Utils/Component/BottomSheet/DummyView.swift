//
//  DummyHRowView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

struct DummyView: View {
    var direction: Edge.Set = .horizontal
    var body: some View {
        ZStack {
            if direction == .horizontal {
                HStack(alignment: .top, spacing: 12) {
                    DummyVRowView(title: "It is not uncommon achieved")
                    VStack {
                        DummyHRowView(title: "and prototyping processes")
                    }
                }
            }else if direction == .vertical {
                VStack(alignment: .leading, spacing: 12) {
                    DummyVRowView(title: "It is not uncommon achieved")
                    VStack {
                        DummyHRowView(title: "and prototyping processes")
                    }
                }
            }
        }
        .padding()
        .redacted(reason: [.placeholder])
    }
}

struct DummyHRowView: View {
    var title: String
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
            VStack(alignment: .leading) {
                HStack {
                    Label {
                        Text("Title String")
                    } icon: {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.blue)
                    }
                }
                Text("It is not uncommon for a website or digital product to launch and miss the mark.")
                    .font(.callout)
                    .foregroundColor(Color.teal)
                Divider()
                Text("It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark.")
                    .font(.callout)
                    .foregroundColor(Color.teal)
                Spacer()
            }
        }
    }
}

struct DummyVRowView: View {
    var title: String
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                }
                
                HStack {
                    Label {
                        Text("Title String")
                    } icon: {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.blue)
                    }
                }
                Text("It is not uncommon for a website or digital product to launch and miss the mark.")
                    .font(.callout)
                    .foregroundColor(Color.teal)
                Text("It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark. It is not uncommon for a website or digital product to launch and miss the mark.")
                    .font(.callout)
                    .foregroundColor(Color.teal)
                Spacer()
            }
        }
    }
}

