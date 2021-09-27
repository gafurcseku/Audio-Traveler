//
//  LoginAccountUIView.swift
//  DhamakaShopping
//
//  Created by Invariant on 25/2/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct LoginAccountUIView: View {
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    @StateObject var viewModel = AccountViewModel()
    
    @State private var userEmail:String = ""
    @State private var password:String = ""
    
    @State var RegistrationState = false
    @State var userLogin = false
    
    @State private var isError:Bool = false
    @State var message:String = ""
    
    @State private var isPasswordShow: Bool = false
    
    var body: some View {
        NavigationView{
            LoadingView(isShowing: .constant(viewModel.isLoading)){
                VStack(alignment:.leading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("back_white_icon").resizable().frame(width: 24, height: 24)
                    }).padding(5).background(Color("black").opacity(0.3)).clipShape(Circle()).padding(.top,10).padding(.leading, 15)
                    VStack {
                        FloatingLabelTextField($userEmail, placeholder: "E-Mail")
                            .isShowError(true)
                            .addValidations([.init(condition: userEmail.isValid(.email), errorMessage: "Invalid E-Mail")])
                            .floatingStyle(ThemeTextFieldStyle())
                            .frame(height: 70)
                            .keyboardType(.phonePad)
                        
                        FloatingLabelTextField($password, placeholder: "Password")
                            .isSecureTextEntry(!self.isPasswordShow)
                            .rightView({
                                Button(action: {
                                    withAnimation {
                                        self.isPasswordShow.toggle()
                                    }
                                }, label: {
                                    Image(systemName: self.isPasswordShow ? "eye.slash.fill" : "eye.fill") .foregroundColor(.white)
                                })
                            })
                            .floatingStyle(ThemeTextFieldStyle())
                            .frame(height: 70)
                    }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 40)
                    
                    
                    VStack(spacing:5) {
                        
                        Button(action: {
                            self.isError = false
                            self.userLogin = false
                           // self.userLogin = true
                            viewModel.userLogin(email: userEmail, password: password){ isSuccess in
                                if(isSuccess){
                                    self.userLogin = true
                                }else{
                                    self.message = "Email or Password Wrong."
                                    self.isError = true
                                }
                            }
                        }, label: {
                            Text("LOGIN").foregroundColor(.white).frame(maxWidth: .infinity)
                            
                        }).frame(width:204).padding(12).background(Color("F2A35A")).cornerRadius(200).padding(.top, 40)
                        .alert(isPresented:self.$isError, title: "Alert", message: self.message)
                        .overlay(
                            NavigationLink(
                                destination: MainView(),
                                isActive: self.$userLogin){}
                        )
                        Spacer()
                        Button(action: {
                            self.RegistrationState.toggle()
                        }, label: {
                            HStack(spacing:2) {
                                Text("Don’t have an account, yet? - ").foregroundColor(.white)
                                Text("create a account").foregroundColor(.red)
                            }
                            
                        }).padding(.top, 30).fullScreenCover(isPresented: $RegistrationState, content: {
                              CreateAccountUIView()
                        })
                        
                    }.frame(width: UIScreen.main.bounds.width).padding(.bottom, 60)
                }
                .onAppear(perform: {
                    #if DEBUG
                    self.userEmail = "Test@gmail.com"
                    self.password = "123456"
                    #endif
                   
                })
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct LoginAccountUIView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAccountUIView()
    }
}
