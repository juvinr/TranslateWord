//
//  ContentView.swift
//  TranslateWord
//
//  Created by Juvin Rodrigues on 1/1/25.
//

import SwiftUI
import Translation

struct ContentView: View {
    
    @State private var sourceText: String = ""
    @State private var configuration: TranslationSession.Configuration?
    @State private var translatedMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    TextField("Enter a word", text: $sourceText)
                        .padding()
                        .border(Color.indigo.opacity(0.9), width: 2)
                        .padding()
                    
                    Text(" \(translatedMessage) ")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Button {
                        triggerTranslation()
                    } label: {
                        Text("Translate to German")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.indigo.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                    
                }
                Spacer()
            }
            .navigationTitle("Translate")
            .translationTask(configuration) { session in
                do {
                    let response = try await session.translate(sourceText)
                    translatedMessage = response.targetText
                } catch {
                    print(error)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error!"),
                    message: Text("Please enter a word."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func triggerTranslation() {
        if sourceText == "" {
            showAlert.toggle()
        }
        guard configuration == nil else {
            configuration?.invalidate()
            return
        }
        configuration = .init(target: .init(identifier: "de"))
    }
    
}

#Preview {
    ContentView()
}
