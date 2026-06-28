//
//  APIEventMonitor.swift
//  Saion
//
//  Created by 신정욱 on 6/28/26.
//

import Foundation

import Alamofire

/// 네트워크 이벤트 모니터
final class APIEventMonitor: EventMonitor {
    
    /// 로그를 출력할 큐 (시리얼 큐)
    let queue = DispatchQueue(label: "APIEventMonitor")
    
    /// 요청 전송 직후 호출
    /// 어댑터/인터셉터 적용까지 끝난 상태
    func request(_ request: Request, didResumeTask task: URLSessionTask) {
        let url = request.request?.url?.absoluteString ?? "(알 수 없는 URL)"
        let method = request.request?.httpMethod ?? "(알 수 없는 메서드)"
        
        request.cURLDescription { curl in
            print("""
            [🚀REQUEST] \(method) \(url)
            cURL: \(curl)
            
            
            """)
        }
    }
    
    /// 서버에서 보낸 데이터를 전부 다 받은 직후 호출
    /// responseDecodable 클로저 진입 전 단계
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        let url = request.request?.url?.absoluteString ?? "(알 수 없는 URL)"
        let statusCode = response.response?.statusCode ?? -1
        let statusEmoji = (200..<300).contains(statusCode) ? "✅" : "⚠️"
        
        let data = response.data ?? Data()
        let body = String(data: data, encoding: .utf8) ?? ""
        
        // AFError 상세 로깅
        if case .failure(let afError) = response.result {
            print("""
            [❌RESPONSE] \(statusCode) \(url)
            RAW: \(body) (\(data.count) bytes)
            AFError: \(afError)
            
            
            """)
            
        } else {
            print("""
            [\(statusEmoji)RESPONSE] \(statusCode) \(url)
            RAW: \(body) (\(data.count) bytes)
            
            
            """)
        }
    }
}
