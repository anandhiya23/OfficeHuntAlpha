//
//  LeftPlayerInfoView.swift
//  OfficeHuntBeta
//
//  Created by Bintang Anandhiya on 17/05/24.
//

import SwiftUI

struct LeftPlayerInfoView: View {
    var cwp: CGFloat
    var chp: CGFloat
    @EnvironmentObject var manager: GameManager
    
    var body: some View {
        VStack(spacing: 0){//PLAYER INFO GROUP
            HStack(spacing: 0){//PLAYER DATA
                UnevenRoundedRectangle(cornerRadii: .init( //PLAYER 1 NAME
                    topLeading: 1*cwp,
                    bottomLeading: 0.0,
                    bottomTrailing: 0.0,
                    topTrailing: 1*cwp))
                .foregroundColor(Color(hex:"#D9D9D9"))
                .overlay {
                    Text("P01")
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*3))
                    .tracking(cwp*0.3)
                    
                }
                
                HStack{//PLAYER SCORE
                    Text("$"+String(manager.LPScore))
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*3))
                    .tracking(cwp*0.3)
                    .foregroundStyle(Color(hex:"E16161"))
                    
                    if manager.LPScoreGain != 0{
                        Text("+"+String(manager.LPScoreGain))
                            .font(.custom("LondrinaSolid-Light", fixedSize: cwp*3))
                            .tracking(cwp*0.3)
                            .foregroundStyle(Color(hex:"F0B828"))
                    }
                    
                    Spacer()
                }
                .frame(width: cwp*24)
                .padding(.leading, cwp*2)
                
            }
            .frame(width: cwp*35, height: chp*8)
            
            UnevenRoundedRectangle(cornerRadii: .init( //PLAYER PROMPT
                topLeading: 0,
                bottomLeading: cwp*2,
                bottomTrailing: cwp*2,
                topTrailing: cwp*2))
            .frame(width: cwp*35, height: chp*20)
            .foregroundColor(Color(hex:"#D9D9D9"))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: cwp*2)
                .foregroundColor(Color(hex:
                    manager.LPState == 1 ? "#4FC963" :
                    manager.LPState == 2 ? "#E16161" :
                    "#D9D9D9"))
            }
            .overlay(alignment: .center) { //PLAYER PROMPT MAIN OVERLAY
                RoundedRectangle(cornerRadius: cwp*1)
                .foregroundColor(.white)
                .padding(cwp*1)
                .overlay {
                    Text(manager.LPTargetText)
                    .font(.custom("LondrinaSolid-Black", fixedSize: cwp*5).leading(.tight))
                    .tracking(cwp*0.3)
                    .multilineTextAlignment(.center)
                    .scaleEffect(manager.LPTargetTextScale)
                }
            }
            .overlay(alignment: .leading) { //PLAYER PROMPT ICON
                Image("GreenCheck")
                    .resizable()
                    .frame(width: cwp*8, height: cwp*8)
                    .padding([.leading],-cwp*3.5)
                    .scaleEffect(x: manager.LPState == 1 ? 1 :
                                    0.0,
                                 y: manager.LPState == 1 ? 1 :
                                    0.0,
                                 anchor: .center)
                Image("RedCross")
                    .resizable()
                    .frame(width: cwp*8, height: cwp*8)
                    .padding([.leading],-cwp*3.5)
                    .scaleEffect(x: manager.LPState == 2 ? 1 :
                                    0.0,
                                 y: manager.LPState == 2 ? 1 :
                                    0.0,
                                 anchor: .center)
            }
            
        }
    }
}

//#Preview {
//    LeftPlayerInfoView(cwp: 2, chp: 2, manager: GameManager())
//}
