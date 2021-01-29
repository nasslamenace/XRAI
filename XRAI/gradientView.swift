//
//  gradientView.swift
//  XRAI
//
//  Created by Nassim Guettat on 12/12/2020.
//

import UIKit
import SwiftUI

struct gradientView: View {
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(RadialGradient(
                        gradient: Gradient(stops: [
                    .init(color: Color(#colorLiteral(red: 0, green: 0.43921568989753723, blue: 0.729411780834198, alpha: 1)), location: 0),
                    .init(color: Color(#colorLiteral(red: 0.021929806098341942, green: 0.39535608887672424, blue: 0.7022606134414673, alpha: 1)), location: 0.26629048585891724),
                    .init(color: Color(#colorLiteral(red: 0.04488985612988472, green: 0.3494359850883484, blue: 0.6738339066505432, alpha: 1)), location: 0.5450910925865173),
                    .init(color: Color(#colorLiteral(red: 0.08235294371843338, green: 0.27450981736183167, blue: 0.6274510025978088, alpha: 1)), location: 0.6822916865348816),
                    .init(color: Color(#colorLiteral(red: 0.08235294371843338, green: 0.27450981736183167, blue: 0.6274510025978088, alpha: 1)), location: 0.9270833134651184)]),
                    center: UnitPoint(x: -0.22266668145676066, y: -0.2738096075194387),
                        startRadius: 4.554735921463932,
                        endRadius: 330.11802338781814
                      ))
            .frame(width: 261, height: 49)
        }
        
    }
    
    

}


