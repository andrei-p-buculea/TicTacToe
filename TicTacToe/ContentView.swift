//
//  ContentView.swift
//  TicTacToe
//
//  Created by Andrei-Petrisor Buculea on 13.04.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    //moves
    @State var moves : [String] = Array(repeating: "", count: 9)
    //To identify the current Player
    @State var isPlaying = true
    @State var gameOver = false
    @State var message = ""
    
    var body: some View{
        
        //GridView for Paying...
        
        VStack{
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15) , count: 3) , spacing: 15){
                
                ForEach(0..<9,id: \.self){index in
                    
                    ZStack {
                        //flip animation
                        Color.blue
                        
                        Color.white
                            .opacity(moves[index] == "" ? 1:0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .opacity(moves[index] != "" ? 1 : 0)
                        
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: (x: 0.0 , y:1.0 , z:0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    
                    //whenever tapped adding move
                    .onTapGesture(perform: {
                        
                        withAnimation(Animation.easeIn(duration: 0.5)){
                            
                            if moves[index] == ""{
                                moves[index] = isPlaying ? "X" : "0"
                                //updating player
                                isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        //whenever moves updated it will check for winner ...
        .onChange(of: moves, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver,content: {
            
            Alert(title: Text("Winner"), message: Text(message) , dismissButton:
                    .destructive(Text("Play again"),action:{
                        //resetting all data
                        withAnimation(Animation.easeIn(duration: 0.5)){
                            moves.removeAll()
                            moves = Array(repeating: "" , count: 9)
                            isPlaying = true
                        }
                    } ))
        })
    }
    
    //calculating width
    func getWidth() -> CGFloat {
        //horizontal padding = 30
        //spacing 30
        let width = UIScreen.main.bounds.width -  (30 + 30)
        
        return width / 3
    }
    
    //checkng for winner
    
    func checkWinner(){
        
        if checkMoves(player: "X")
        {
            message = "Player X Won !!!"
            gameOver.toggle()
        }
        
        else  if checkMoves(player: "0"){
            
            message = "Player 0 Won !!!"
            gameOver.toggle()
        }
        else{
            
            //checking if no moves
            
            let status = moves.contains { (value) -> Bool in
                return value == ""
            }
            if !status{
                message = "Game over tied !!!"
                gameOver.toggle()
            }
        }
    }
    
    
    func checkMoves(player: String)->Bool{
        
        //Horizontal moves
        
        for i in stride(from:0 , to: 9, by : 3){
            
            if moves[i] == player && moves[i+1] == player && moves[i+2] ==
                player{
                
                return true
            }
        }
        
        //Vertical moves
        
        for i in 0...2{
            
            if moves[i] == player && moves[i+3] == player && moves[i+6] ==
                player{
                
                return true
            }
        }
        
        //Checking diagonal
        
        if moves[0] == player && moves[4] == player && moves[8] == player{
            return true
        }
        
        if moves[2] == player && moves[4] == player && moves[6] == player{
            return true
        }
        
        return false
    }
    
}
