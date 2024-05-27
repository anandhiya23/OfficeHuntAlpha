/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Vision
import SwiftySound
import AppKit

enum GameStates {
    case initial
    case starting
    case searching
    case done
    case finished
    case wait
}

final class GameManager: ObservableObject {
    
    let targets: [(String,[String],Float)] = [
        ("PLASTIC\nBOTTLE", ["bottle"], 0.7),
        ("EYEGLASSES",["eyeglasses"], 0.8),
        ("ELECTRONICS",["consumer_electronics"], 0.8),
        ("PENs",["pen"], 1.0),
        ("CHILD",["child"], 1.0),
        ("MUG",["mug", "cup"], 1.0),
        ("SCISSORS",["scissors"], 1.0),
        ("CLOTHING",["clothing"], 1.0),
        ("SHOES",["shoes","sneaker","footwear"], 1.0),
        ("CHESS",["chess"], 1.0),
        ("PAPER\nDOCUMENT",["document"], 0.7),
        ("HANDWRITING",["handwriting"], 0.8),
        ("BACKPACK",["backpack"], 1.0),
        ("ANALOG\nWATCH", ["dial", "watch", "clock"], 0.7),
        ("EXTINGUISHER",["extinguisher"], 0.75),
        ("COMPUTER",["computer"], 1.0)
    ]
    
    @Published var countSound: Sound?
    
    @Published var round = 1
    
    @Published var LPScore = 0
    @Published var RPScore = 0
    
    @Published var LPScoreGain = 0
    @Published var RPScoreGain = 0
    
    @Published var RPState = 0
    @Published var LPState = 0 //testt
    
    @Published var LPTargetText: String = ">>>"
    @Published var RPTargetText: String = "<<<"
    
    @Published var LPTargetTextScale: CGFloat = 1.0
    @Published var RPTargetTextScale: CGFloat = 1.0
    
    @Published var LPTargetKeys: [String] = []
    @Published var RPTargetKeys: [String] = []
    
    
    @Published var ReceivedKeys: [String] = []
    
    @Published var refereeText = "START"
    @Published var refereeSubtext = "(SPACEBAR)"
    @Published var gameState: GameStates = .initial
    @Published var mainCountDown = 4
    
    
    
    //TRIGGERS
    @Published var buttonTriggered = false
    @Published var buttonTintOpacity = 0.0
    @Published var buttonColorOut = "#CF5959"
    @Published var buttonColorIn = "#E16161"
    
    private var gameTimer: Timer?
    
    func buttonTrigger(){
        switch gameState {
        case .initial:
            buttonTriggered = true
        case .done:
            buttonTriggered = true
        case .finished:
            buttonTriggered = true
        default:
            return
        }
    }
    
    func initiateGameLoop(){
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[self] timer in
            if gameState == .initial{
                if buttonTriggered {
                    buttonTriggered = false
                    gameState = .starting
                    
                    Sound.play(file: "initialCountdown.wav")
                    buttonColorOut = "#DDA925"
                    buttonColorIn = "#F0B828"
                    mainCountDown = 3
                    refereeText = String(mainCountDown)
                    refereeSubtext = ""
                    
                    LPTargetText = "???"
                    RPTargetText = "???"
                }
            }else if gameState == .starting{
                mainCountDown -= 1
                refereeText = String(mainCountDown)
                countSound?.prepare()
                
                if mainCountDown == 0 {
                    gameState = .searching
                    mainCountDown = 21 //16
                    
                    refereeText = "GO!"
                    buttonColorOut = "#49B95B"
                    buttonColorIn = "#4FC963"
                    
                    let randomNumber1 = Int.random(in: (0...targets.count-1))
                    let randomNumber2 = (randomNumber1 + Int.random(in: (1...targets.count-1))) % targets.count
                    
                    LPTargetText = targets[randomNumber1].0
                    RPTargetText = targets[randomNumber2].0
                    
                    LPTargetKeys = targets[randomNumber1].1
                    RPTargetKeys = targets[randomNumber2].1
                    
                    LPTargetTextScale = CGFloat(targets[randomNumber1].2)
                    RPTargetTextScale = CGFloat(targets[randomNumber2].2)
                }
            }else if gameState == .searching{
                mainCountDown -= 1
                refereeText = String(mainCountDown)
                refereeSubtext = "SECONDS"
                if mainCountDown <= 1 { refereeSubtext = "SECOND"}

                if LPState == 1 && RPState == 1{
                    Sound.stop(file: "femaleCountdown.wav")
                    
                    if round < 5{
                        round += 1
                        gameState = .done
                    }else{
                        gameState = .finished
                        Sound.play(file: "victory.mp3")
                    }
                    
                    refereeSubtext = ""
                    refereeText = "STOP"
                    buttonColorOut = "#CF5959"
                    buttonColorIn = "#E16161"
                    Sound.play(file: "airhorn.mp3")
                }else{
                    if LPState == 0 {
                        for targetKey in LPTargetKeys{
                            if ReceivedKeys.contains(targetKey){
                                LPState = 1
                                LPScoreGain = 100 + Int((Float(mainCountDown)/21.0) * 100)
                                Sound.play(file: "dingOnce.mp3")
                            }
                        }
                    }
                    
                    if RPState == 0 {
                        for targetKey in RPTargetKeys{
                            if ReceivedKeys.contains(targetKey){
                                RPState = 1
                                RPScoreGain = 100 + Int((Float(mainCountDown)/21.0) * 100)
                                Sound.play(file: "dingOnce.mp3")
                            }
                        }
                    }
                    
                    print(ReceivedKeys)
                    
                    if mainCountDown == 10{
                        Sound.play(file: "femaleCountdown.wav")
                    }
                    
                    if mainCountDown == -1 {
                        if round < 5{
                            round += 1
                            gameState = .done
                        }else{
                            gameState = .finished
                            Sound.play(file: "victory.mp3")
                        }
                        
                        refereeSubtext = ""
                        refereeText = "STOP"
                        buttonColorOut = "#CF5959"
                        buttonColorIn = "#E16161"
                        Sound.play(file: "airhorn.mp3")
                        
                        if RPState == 0 {
                            RPState = 2
                        }
                        
                        if LPState == 0 {
                            LPState = 2
                        }
                    }
                }
            }else if gameState == .done{
                
                refereeText = "START"
                refereeSubtext = "ROUND \(round)/5"
                
                LPState = 0
                RPState = 0
                
                LPScore += LPScoreGain
                RPScore += RPScoreGain
                
                LPScoreGain = 0
                RPScoreGain = 0
                
                LPTargetTextScale = 1.0
                RPTargetTextScale = 1.0
                
                LPTargetText = ">>>"
                RPTargetText = "<<<"
                
                if buttonTriggered {
                    buttonTriggered = false
                    gameState = .starting
                    
                    LPTargetText = "???"
                    RPTargetText = "???"
                    refereeSubtext = ""
                    
                    Sound.play(file: "initialCountdown.wav")
                    buttonColorOut = "#DDA925"
                    buttonColorIn = "#F0B828"
                    mainCountDown = 3
                    refereeText = String(mainCountDown)
                }
            }else if gameState == .finished{
                refereeText = "PLAY"
                refereeSubtext = "NEW GAME"
                
                LPScore += LPScoreGain
                RPScore += RPScoreGain
                
                LPScoreGain = 0
                RPScoreGain = 0
                
                LPTargetTextScale = 1.0
                RPTargetTextScale = 1.0
                
                if LPScore > RPScore{
                    LPState = 1
                    RPState = 0
                    LPTargetText = "WINNER"
                    RPTargetText = "LOSER"
                }else if LPScore < RPScore{
                    LPState = 0
                    RPState = 1
                    LPTargetText = "LOSER"
                    RPTargetText = "WINNER"
                }else{
                    LPState = 0
                    RPState = 0
                    LPTargetText = "DRAW"
                    RPTargetText = "DRAW"
                }
                
                if buttonTriggered {
                    buttonTriggered = false
                    gameState = .initial
                    
                    refereeText = "START"
                    LPTargetText = ">>>"
                    RPTargetText = "<<<"
                    refereeSubtext = "(SPACEBAR)"
                    
                    LPState = 0
                    RPState = 0
                    LPScore = 0
                    RPScore = 0
                    round = 0
                }
            }
        }
    }
}


extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

struct CameraView: View {
    @StateObject private var manager = GameManager()
    @StateObject private var model = DataModel()
    @State private var currentDate = Date.now
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var backgroundSound: Sound?
    private static let barHeightFactor = 0.15
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                
                let ratioWidth = 1.5
                let ratioHeight = 1.0
                
                
                
                let cwp = min(geo.size.width, geo.size.height * ratioWidth/ratioHeight)/100
                let chp = min(geo.size.height, geo.size.width * ratioHeight/ratioWidth)/100
                    
                VStack(spacing: 0){
                    Button("Start"){
                        manager.buttonTrigger()
                    }.keyboardShortcut(.space, modifiers: [])
                        .frame(width: 0,height: 0)
                        .opacity(0)
                    HStack{//INFO BAR
                        LeftPlayerInfoView(cwp:cwp,chp:chp)
                        .frame(width: cwp*35, height: chp*28)
                        
                        Spacer() //==================================================
                        
                        VStack(spacing: 0){ //GAME INFO (COUNTDOWN TIMER)
                            Image("OfficeHuntLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cwp*20)
                            
                            Spacer()
                            
                            UnevenRoundedRectangle(cornerRadii: .init( //PLAYER 1 PROMPT
                                topLeading: cwp*2,
                                bottomLeading: cwp*2,
                                bottomTrailing: cwp*2,
                                topTrailing: cwp*2))
                            .frame(width: cwp*20, height: chp*20)
                            .foregroundStyle(Color(hex:manager.buttonColorOut))
                            .overlay(alignment: .center) {
                                RoundedRectangle(cornerRadius: cwp*1)
                                .foregroundStyle(Color(hex:manager.buttonColorIn))
                                .padding(cwp*1)
                                .overlay{
                                    RoundedRectangle(cornerRadius: cwp*2)
                                        .foregroundStyle(.black)
                                    .opacity(manager.buttonTintOpacity)
                                }
                                .overlay {
                                    VStack(spacing: -cwp*0.8){
                                        Text(manager.refereeText)
                                        .font(.custom("LondrinaSolid-Black", fixedSize: cwp*5))
                                        .tracking(cwp*0.3)
                                        .foregroundStyle(Color.white)
                                        if manager.refereeSubtext != ""{
                                            Text(manager.refereeSubtext)
                                                .font(.custom("LondrinaSolid-Black", fixedSize: cwp*1.8))
                                            .tracking(cwp*0.2)
                                            .foregroundStyle(Color.white)
                                            .opacity(0.7)
                                        }
                                    }
                                    
                                    
                                }
                            }
                            
                            .onHover(perform: { inside in
                                if inside{
                                    withAnimation {
                                        manager.buttonTintOpacity = 0.15
                                    }
                                    
                                }else{
                                    withAnimation {
                                        manager.buttonTintOpacity = 0.0
                                    }
                                }
                            })
                            .gesture(TapGesture().onEnded {
                                manager.buttonTrigger()
                            })
                        }
                        .frame(width: cwp*20, height: chp*28)
                        
                        Spacer() //=============================================================
                        
                        RightPlayerInfoView(cwp: cwp, chp: chp)
                        .frame(width: cwp*35, height: chp*28)
                        
                    }
                    .frame(width: cwp*100,height: chp*28)
                    
                    Spacer()
                    
                    ViewfinderView(image:  $model.viewfinderImage, cornerRadius: cwp*2)
                    .frame(width: cwp*100,height: chp*67)
//                    .overlay(alignment: .bottom) {
//                        buttonsView()
//                            .frame(height: geo.size.height * Self.barHeightFactor)
//                            .background(.black.opacity(0.75))
//                    }
//                    .overlay(alignment: .top){
//                        HStack{
//                        ForEach(Array(model.confidentObservations ?? [String: VNConfidence]()).sorted(by: { lhsd, rhsd  in
//                                return lhsd.0 < rhsd.0
//                            }), id: \.key) { key, value in
//                                Text("**\(key)**: \(value)")
//                            }
//                        }
//                        .frame(height: calculatedHeight/6)
//                        .background(.gray)
//                        .font(.custom("SFPro", fixedSize: 11))
//                    }
                    .task {
                        await model.camera.start()
                    }
                }
                .frame(width: cwp*100, height: chp*100)
                .frame (width: geo.size.width, height: geo.size.height) //FOR CENTERING
                
            }
            .navigationTitle("Camera")
            .ignoresSafeArea()
            
        }
        .padding(90)
        .background(.white)
        .onReceive(timer) { input in
            currentDate = input
            model.camera.takePhoto()
            manager.ReceivedKeys = model.confidentObservationKeys ?? []
        }.onAppear{
            
            manager.initiateGameLoop()
            
            manager.LPScore = 0
            manager.RPScore = 0
            
            if let pianoUrl = Bundle.main.url(forResource: "runamok", withExtension: "mp3") {
                backgroundSound = Sound(url: pianoUrl)
                backgroundSound?.volume = 0.8
                backgroundSound?.prepare()
            }
            
            backgroundSound?.play(numberOfLoops: -1) { completed in
                print("completed: \(completed)")
            }
        }
        .environmentObject(manager)
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            Button {
                //model.camera.takePhoto()
                
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
