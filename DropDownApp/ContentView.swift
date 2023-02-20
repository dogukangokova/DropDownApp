//
//  ContentView.swift
//  DropDownApp
//
//  Created by Devinely on 20.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String = "Kolay"
    @Environment(\.colorScheme) var scheme
    var body: some View {
        VStack{
            DropDown(content: ["Kolay","Normal", "Zor"], selection: $selection, activeTint: .primary.opacity(0.1), inActiveTint: .primary.opacity(0.05), dynamic: false
            )
            .frame(width: 130)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
//        .environment(\.colorScheme, .dark)
        .background{
            if scheme == .dark {
                Color("BG")
                    .ignoresSafeArea()
            }
            
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct DropDown: View{
    
    var content: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    var dynamic: Bool = true
    @State private var expandView: Bool = false
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 0){
                if !dynamic{
                    RowView(selection, size)
                }
                
                ForEach(content.filter{
                    dynamic ? true : $0 != selection
                }, id: \.self){title in
                    RowView(title, size)
                }
            }.background{
                Rectangle()
                    .fill(inActiveTint)
            }
            .offset(y: dynamic ?  (CGFloat(content.firstIndex(of: selection) ?? 5) * -65) : 0)
        }
        .frame(height: 65)
        .overlay(alignment: .trailing){
            Image(systemName: "chevron.up.chevron.down")
                .padding(.trailing, 10)
        }
        .mask{
            Rectangle()
                .frame(height: expandView ? CGFloat(content.count) * 100 : 55)
                .offset(y: dynamic && expandView ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -65) : 0)
        }
    }
    
    
    @ViewBuilder
    func RowView(_ title: String,_ size: CGSize)->some View{
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background{
                if selection == title{
                    Rectangle()
                        .fill(activeTint)
                        .transition(.identity)
                    
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    if expandView{
                        expandView = false
                        if dynamic {
                            selection = title
                        }else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                                selection = title
                            }
                        }
                    }else {
                        if selection == title {
                            expandView = true
                        }
                      
                    }
                }
            }
        }
    
}
