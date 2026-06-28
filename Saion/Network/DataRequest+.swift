//
//  DataRequest+.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

extension DataRequest {
    /// 리스폰스 파싱
    func decodeResponse<ResponseDTO: Decodable>(
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO?) -> Void,
        errorHandler: ((APIError) -> Void)? = nil
    ) {
        // validate없이는 Authenticator.didRequest 호출 안 됨
        self.validate().responseDecodable(
            of: APIResDTO<ResponseDTO>.self
        ) { response in
            switch response.result {
            case .success(let commomRes):
                completion(commomRes.data)
                
            case .failure(_):
                let apiError = response.data.map {
                    (try? JSONDecoder().decode(APIError.self, from: $0))
                    ?? APIError(message: "에러 메시지 디코딩에 실패했습니다.")
                } ?? APIError(message: "응답 데이터가 없습니다.")
                
                errorHandler?(apiError)
            }
        }
    }
    
    /// 도메인 API 외 리스폰스 파싱
    func decodeAnyResponse<ResponseDTO: Decodable>(
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO) -> Void,
        errorHandler: ((APIError) -> Void)? = nil
    ) {
        // validate없이는 Authenticator.didRequest 호출 안 됨
        self.validate().responseDecodable(
            of: ResponseDTO.self
        ) { response in
            switch response.result {
            case .success(let res):
                completion(res)
                
            case .failure(_):
                let apiError = response.data.map {
                    (try? JSONDecoder().decode(APIError.self, from: $0))
                    ?? APIError(message: "에러 메시지 디코딩에 실패했습니다.")
                } ?? APIError(message: "응답 데이터가 없습니다.")
                
                errorHandler?(apiError)
            }
        }
    }
}
