//
//  UIProject.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct UIProject: View {
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 35) {
                NavigationLink(destination: UICanvas()) {
                    HStack (spacing: 35) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 130))
                                        .foregroundStyle(Color(hex: 0x326EEB))
                                        .fontWeight(.thin)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project1")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project2")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project3")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project4")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        
                    }
                }
                NavigationLink(destination: UICanvas()) {
                    HStack (spacing: 35) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project5")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project6")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project7")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("project8")
                                        .frame(width: 200, height: 200)
                                        .shadow(radius: 10)
                                        .cornerRadius(16)
                                )
                        }
                    }
                }
            }
            .navigationTitle("All Projects")
        }
    }
}



struct UIProject_Previews: PreviewProvider {
    static var previews: some View {
        UIProject()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
