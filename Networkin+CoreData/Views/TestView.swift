//
//  TestView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI

struct TestView: View {
    var should = true
    var body: some View {
        GeometryReader { geometry in
            if(should) {
                ProgressView()
                    .frame(minHeight: geometry.size.height)
                    .frame(width: geometry.size.width, alignment: .center)
                    .navigationTitle("Title")
            }else {
                ScrollView(.vertical) {
                    ForEach(0..<3, content: { i in
                        Text("Hello")
                    })
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TestView()
        }
    }
}
