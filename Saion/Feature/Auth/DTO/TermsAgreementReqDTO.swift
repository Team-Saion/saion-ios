//
//  TermsAgreementReqDTO.swift
//  Saion
//
//  Created by 신정욱 on 7/3/26.
//

struct TermsAgreementReqDTO: Encodable {
    // FIXME: 추후 API에서 조회한 약관 ID를 사용해야 함.
    //  현재는 모든 필수 약관 동의가 전제되는 화면 흐름이라 임시로 하드코딩.
    
    /// 동의한 약관 ID 목록
    let termIds: [Int] = [1, 2, 3]
}
