//
//  ContentView.swift
//  Combine App
//
//  Created by William Lopez on 9/14/20.
//  Copyright © 2020 William Lopez. All rights reserved.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var isChecked = false
    @Published var isChecked2 = false
    @Published var isChecked3 = false
    @Published var showMsg = false
    @Published var allChecked = false
    @Published var email = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isValid: AnyPublisher<Bool,Never> {
        isCheck.combineLatest(isValidTextandSwitched) {
            checkmarks, switchAndText in
            checkmarks && switchAndText
            
            
        }.eraseToAnyPublisher()
    }
    
    private var isCheck: AnyPublisher<Bool,Never> {
         Publishers.CombineLatest3($isChecked,$isChecked2,$isChecked3)
            .map {
                isChecked,isChecked2,isChecked3 in
                isChecked && isChecked2 && isChecked3
        }.eraseToAnyPublisher()
        
        
    }
    
    private var isValidTextandSwitched: AnyPublisher<Bool,Never> {
         Publishers.CombineLatest($showMsg,$email)
            .map{
                showMsg, email in
                showMsg && !email.trimmingCharacters(in: .whitespaces).isEmpty
        }.eraseToAnyPublisher()
    }
    
    init() {
        isValid
            .receive(on: RunLoop.main)
            .assign(to: \.allChecked, on: self)
            .store(in: &cancellableSet)
    }
    
}
struct ContentView: View {
    
    @ObservedObject  var userViewModel = UserViewModel()
    @State var showHiddenView: Bool = false
    var body: some View {
        ScrollView {
        VStack {
            Text("Check all and type your email in order to submit").minimumScaleFactor(0.5)
            
            VStack(alignment: .leading){
                
                Button(action: toggle1) {
                    HStack {
                        Image(systemName: userViewModel.isChecked ? "checkmark.square": "square")
                        Text("Are you ready?")
                    }
                    
                }
                Button(action: toggle2) {
                    HStack {
                        Image(systemName: userViewModel.isChecked2 ? "checkmark.square": "square")
                        
                        Text("Can you read?")
                    }
                }
                
                Button(action: toggle3) {
                    HStack {
                        Image(systemName: userViewModel.isChecked3 ? "checkmark.square": "square")
                        
                        Text("Check this :)")
                    }
                }
            }.padding()
            VStack{
                
                Toggle(isOn: $userViewModel.showMsg){
                    Text("Switch for surpise")
                        .bold()
                        .foregroundColor(Color.red)
                }
                
                if userViewModel.showMsg {
                    Text("Hello World!")
                        .font(.largeTitle)
                        .foregroundColor(Color.yellow)
                }
            } .padding(.horizontal)
                .padding()
            
            HStack{
                TextField("Enter email", text: $userViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: dummySubmit){
                    Text("Submit")
                        .padding(4)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2))
                    
                }.disabled(!userViewModel.allChecked)
            }
            .padding(.top, 100)
            .padding(.horizontal)
            Spacer()
        }
            
            if self.showHiddenView {
                Text("Yay!! You did it!")
                    .bold()
                    .padding(.bottom)
                
            } else {
                Text("Yay!! You did it!")
                    .bold()
                    .hidden()
                    .padding(.bottom)
                
            }
            
        }
        .padding(.top)
        
        
    }
    func dummySubmit(){
        self.showHiddenView = true
    }
    func toggle1() {
        userViewModel.isChecked = !userViewModel.isChecked
    }
    func toggle2() {
        userViewModel.isChecked2 = !userViewModel.isChecked2
    }
    func toggle3() {
        userViewModel.isChecked3 = !userViewModel.isChecked3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
