//
//  RightPlayerInfoView.swift
//  OfficeHuntBeta
//
//  Created by Bintang Anandhiya on 17/05/24.
//

import SwiftUI

struct RightPlayerInfoView: View {
    var cwp: CGFloat
    var chp: CGFloat
    @EnvironmentObject var manager: GameManager
    
    var body: some View {
        VStack(spacing: 0){//PLAYER INFO GROUP
            HStack(spacing: 0){//PLAYER DATA

                HStack(){//PLAYER SCORE
                    Spacer()
                    
                    if manager.RPScoreGain != 0{
                        Text("+"+String(manager.RPScoreGain))
                        .font(.custom("LondrinaSolid-Light", fixedSize: cwp*3))
                        .tracking(cwp*0.3)
                        .foregroundStyle(Color(hex:"F0B828"))
                    }
                    
                    Text("$"+String(manager.RPScore))
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*3))
                    .tracking(cwp*0.3)
                    .foregroundStyle(Color(hex:"E16161"))
                }
                .frame(width: cwp*24)
                .padding(.trailing, cwp*2)
                
                UnevenRoundedRectangle(cornerRadii: .init( //PLAYER 1 NAME
                    topLeading: 1*cwp,
                    bottomLeading: 0.0,
                    bottomTrailing: 0.0,
                    topTrailing: 1*cwp))
                .foregroundColor(Color(hex:"#D9D9D9"))
                .overlay {
                    Text("P02")
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*3))
                    .tracking(cwp*0.3)

                }
            }
            .frame(width: cwp*35, height: chp*8)
            
            UnevenRoundedRectangle(cornerRadii: .init( //PLAYER PROMPT
                topLeading: cwp*2,
                bottomLeading: cwp*2,
                bottomTrailing: cwp*2,
                topTrailing: 0))
            .frame(width: cwp*35, height: chp*20)
            .foregroundColor(Color(hex:"#D9D9D9"))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: cwp*2)
                .foregroundColor(Color(hex:
                    manager.RPState == 1 ? "#4FC963" :
                    manager.RPState == 2 ? "#E16161" :
                    "#D9D9D9"))
            }
            .overlay(alignment: .center) { //PLAYER PROMPT MAIN OVERLAY
                RoundedRectangle(cornerRadius: cwp*1)
                .foregroundColor(.white)
                .padding(cwp*1)
                .overlay {
                    Text(manager.RPTargetText)
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*5))
                    .tracking(cwp*0.3)
                    .multilineTextAlignment(.center)
                    .scaleEffect(manager.RPTargetTextScale)
                }
            }
            .overlay(alignment: .trailing) { //PLAYER PROMPT ICON
                Image("GreenCheck")
                    .resizable()
                    .frame(width: cwp*8, height: cwp*8)
                    .padding([.trailing],-cwp*3.5)
                    .scaleEffect(x: manager.RPState == 1 ? 1 :
                                    0.0,
                                 y: manager.RPState == 1 ? 1 :
                                    0.0,
                                 anchor: .center)
                Image("RedCross")
                    .resizable()
                    .frame(width: cwp*8, height: cwp*8)
                    .padding([.trailing],-cwp*3.5)
                    .scaleEffect(x: manager.RPState == 2 ? 1 :
                                    0.0,
                                 y: manager.RPState == 2 ? 1 :
                                    0.0,
                                 anchor: .center)
            }
            
        }
    }
}

//#Preview {
//    LeftPlayerInfoView(cwp: 2, chp: 2, manager: GameManager())
//}
