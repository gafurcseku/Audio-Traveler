//
//  CreateAccountUIView.swift
//  DhamakaShopping
//
//  Created by Invariant on 24/2/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI


struct CreateAccountUIView: View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State private var name:String = ""
    @State private var userEemail:String = ""
    @State private var userPassword = ""
        
    @StateObject var viewModel = AccountViewModel()
    @State private var isError:Bool = false
    @State private var isSuccess:Bool = false
   
    @State private var isPasswordShow: Bool = false
    
    @State var message:String = ""
    
   
    var body: some View {
        NavigationView{
            LoadingView(isShowing: .constant(viewModel.isLoading)){
            
            VStack(alignment:.leading) {
                VStack(alignment:.leading) {
                    Text("Create personal Account").foregroundColor(.black)
                }.padding(.leading, 30).padding(.trailing, 30).padding(.top,60)
                
                VStack {
                    FloatingLabelTextField($name, placeholder: "Name")
                        .isShowError(true)
                        .addValidations([.init(condition: name.isValid(.name), errorMessage: "Invalid Name")])
                        .floatingStyle(ThemeTextFieldStyle())
                        .frame(height: 70)
                    
                    FloatingLabelTextField($userEemail, placeholder: "E-Mail")
                        .isShowError(true)
                        .addValidations([.init(condition: userEemail.isValid(.email), errorMessage: "Invalid Email Address")])
                        .floatingStyle(ThemeTextFieldStyle())
                        .frame(height: 70)
                    FloatingLabelTextField($userPassword, placeholder: "Password")
                        .isSecureTextEntry(!self.isPasswordShow)
                        .rightView({
                            Button(action: {
                                withAnimation {
                                    self.isPasswordShow.toggle()
                                }
                            }, label: {
                                Image(systemName: self.isPasswordShow ? "eye.slash.fill" : "eye.fill").foregroundColor(.white)
                            })
                        })
                        .floatingStyle(ThemeTextFieldStyle())
                        .frame(height: 70)
                }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 40)
                

                VStack {
                    Button(action: {
                        self.isError = false
                        self.isSuccess = false
                        viewModel.createAccount(name: name, email: userEemail, password: userPassword) { isSuccess in
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Create").foregroundColor(.black)
                    }).frame(width: 204).padding(12).background(Color("F2A35A")).cornerRadius(200).padding(.top, 40)
                    .alert(isPresented:self.$isError, title: "Alert", message: self.message)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        
                        HStack(spacing:2) {
                            Text("Already have an account?-").foregroundColor(.white)
                            Text("Login").foregroundColor(.red)
                            
                        }
                        
                    }).padding(.top, 30)
                    
                }.frame(width: UIScreen.main.bounds.width).padding(.bottom, 60)
            }
            .background(Color.black)
            .ignoresSafeArea()
           
        }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct CreateAccountUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountUIView()
    }
}
