

import SwiftUI

struct ContentView: View {
    
    @State var questionInput = ""
    @State var sentimentResult = 0.0
    @State var sentimentReceived = false
    
    var body: some View {
        VStack {
            Text("Sentiment Analyzer")
                .font(.largeTitle)
            
            TextField("Enter Question", text: $questionInput)
                .font(.system(size: 16, weight: .semibold))
                .multilineTextAlignment(.leading)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                fetchSentiment(question: questionInput, res: $sentimentResult, received: $sentimentReceived)
            }, label: {
                Text("Get Sentiment")
            })
            .buttonStyle(.borderedProminent)
            .padding(.top, 40)
            
            Spacer()
            HStack {
                Text("Overall Sentiment:")
                    .font(.title)
                if sentimentReceived {
                    if sentimentResult >= 0 {
                        Text("👍")
                            .font(.largeTitle)
                    } else {
                        Text("👎")
                            .font(.largeTitle)
                    }
                } else {
                    Text("🧐")
                        .font(.largeTitle)
                    
                }
            }
            .padding(.bottom, 20)
            
            if sentimentReceived {
                Text("Sentiment Value:")
                    .font(.title)
                Text(String(sentimentResult))
                if sentimentResult >= 0 {
                    Text("This seems like a good idea...")
                        .foregroundStyle(.green)
                } else {
                    Text("This seems like a bad idea...")
                        .foregroundStyle(.red)
                }
            } else {
                Text("Click the button to get the sentiment value!")
                    
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

func fetchSentiment(question: String, res: Binding<Double>, received: Binding<Bool>) {
    var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/getSentiment?question=\(question)")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        
        guard let answer = String(data: data, encoding: .utf8) else {
            print(String(describing: error))
            return
        }
        
        guard let sentres = Double(answer) else {
            print(String(describing: error))
            return
        }
        
        res.wrappedValue = sentres
        received.wrappedValue = true
    }

    task.resume()
}
