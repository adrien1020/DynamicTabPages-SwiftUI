//
//  ContentView.swift
//  DynamicTabPages
//
//  Created by Adrien Surugue on 02/04/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabs = tabPages
    @State private var currentTab = tabPages.first!
    @State private var offset = 0.0
    @State private var index = 0
    @State private var indicatorWidth: CGFloat = 0
    @State private var indicatorPosition: CGFloat = 0
    @State private var scrollTarget: Int?
    
    var body: some View {
        ZStack{
            GeometryReader{geometry in
                let screenSize = geometry.size
                VStack(spacing:5){
                    
                    TabButtons(screenSize: screenSize)
                    
                    //MARK: - TabView
                    TabView(selection:$currentTab){
                        
                        //MARK: - View 1
                        Color.red
                            .ignoresSafeArea()
                            .overlay(
                                GeometryReader{ proxy in
                                    Color.clear
                                        .onChange(of: proxy.frame(in: .global), perform: { value in
                                            if currentTab.name == tabs[0].name{
                                                index = 0
                                                offset = value.minX - (screenSize.width * CGFloat(index))
                                                //print("DEBUG: Global Offset=\(offset)")
                                            }
                                            scrollTarget = index
                                            updateTabFrame(value.width)
                                        })
                                })
                            .tag(tabs[0])
                        
                        //MARK: - View 2
                        Color.blue
                            .ignoresSafeArea()
                            .overlay(
                                GeometryReader{ proxy in
                                    Color.clear
                                        .onChange(of: proxy.frame(in: .global), perform: { value in
                                            if currentTab.name == tabs[1].name{
                                                index = 1
                                                offset = value.minX - (screenSize.width * CGFloat(index))
                                                //print("DEBUG: Global Offset=\(offset)")
                                            }
                                            scrollTarget = index
                                            updateTabFrame(value.width)
                                        })
                                })
                            .tag(tabs[1])
                        
                        //MARK: - View 3
                        Color.yellow
                            .ignoresSafeArea()
                            .overlay(
                                GeometryReader{ proxy in
                                    Color.clear
                                        .onChange(of: proxy.frame(in: .global), perform: { value in
                                            if currentTab.name == tabs[2].name{
                                                index = 2
                                                offset = value.minX - (screenSize.width * CGFloat(index))
                                                //print("DEBUG: Global Offset=\(offset)")
                                            }
                                            scrollTarget = index
                                            updateTabFrame(value.width)
                                        })
                                }
                            )
                            .tag(tabs[2])
                        
                        //MARK: - View 4
                        Color.green
                            .ignoresSafeArea()
                            .overlay(
                                GeometryReader{ proxy in
                                    Color.clear
                                        .onChange(of: proxy.frame(in: .global), perform: { value in
                                            if currentTab.name == tabs[3].name{
                                                index = 3
                                                offset = value.minX - (screenSize.width * CGFloat(index))
                                                //print("DEBUG: Global Offset=\(offset)")
                                            }
                                            scrollTarget = index
                                            updateTabFrame(value.width)
                                        })
                                })
                            .tag(tabs[3])
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea()
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(width: screenSize.width, height: screenSize.height)
            }
            VStack{
                Text("Index = \(index)")
                Text(String(offset))
            }
        }
    }
    
    //MARK: - TabButtons
    @ViewBuilder
    func TabButtons(screenSize: CGSize) -> some View{
        ScrollViewReader{ scrollView in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20){
                    ForEach($tabs){ $tab in
                        HStack(spacing: 4){
                            Image(systemName: tab.icon)
                            Text(tab.name)
                        }
                        .id(tab.id)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                currentTab = tab
                                if currentTab.name == tabs[0].name{
                                    index = 0
                                } else if currentTab.name == tabs[1].name{
                                    index = 1
                                } else if currentTab.name == tabs[2].name{
                                    index = 2
                                } else if currentTab.name == tabs[3].name{
                                    index = 3
                                }
                                updateTabFrame(screenSize.width)
                            }
                        }
                        .overlay(
                            GeometryReader{ proxy in
                                Color.clear
                                    .onAppear(){
                                        tab.width = proxy.frame(in: .global).width
                                        tab.minX = proxy.frame(in: .global).minX
                                        updateTabFrame(screenSize.width)
                                    }
                            }
                        )
                        .id(tab.id)
                    }
                }
                .padding(.horizontal)
                .overlay(alignment: .bottomLeading, content: {
                    Capsule()
                        .frame(width:indicatorWidth  ,height: 4)
                        .offset(x:indicatorPosition,y: 10)
                })
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            .onChange(of: scrollTarget, perform: { _ in
                withAnimation(.linear){
                    if let index = scrollTarget{
                        scrollView.scrollTo(tabs[index].id, anchor: .center)
                    }
                }
            })
        }
    }
    
    //Calculate Tab indicator position & width
    func updateTabFrame(_ tabViewWidth: CGFloat) {
        
        //Make an array with all minX offset
        let inputRange = tabs.indices.compactMap { index -> CGFloat? in
            
            return CGFloat(index) * tabViewWidth
        }
        
        //Make an array with all tab buttons width
        let outputRangeForWidth = tabs.compactMap { tab -> CGFloat? in
            return tab.width
        }
        
        //Make an array with all tab buttons minX position
        let outputRangeForPosition = tabs.compactMap { tab -> CGFloat? in
            return tab.minX
        }
        
        let widthInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForWidth)
        let positionInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForPosition)
        
        indicatorWidth = widthInterpolation.calculate(for: -offset)
        indicatorPosition = positionInterpolation.calculate(for: -offset)
        //print("Indicator Width = \(indicatorWidth)")
        //print("Indicator Position = \(indicatorPosition)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
