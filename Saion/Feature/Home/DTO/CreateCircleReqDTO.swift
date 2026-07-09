//
//  CreateCircleReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/8/26.
//

/// 서클 생성 요청 DTO
struct CreateCircleReqDTO: Encodable {
    /// 서클 이름
    /// - example: 유니콘 스터디
    let name: String
    
    init?(name: String?) {
        guard let name else { return nil }
        self.name = name
    }
}
