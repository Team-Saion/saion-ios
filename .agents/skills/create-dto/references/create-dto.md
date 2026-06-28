# DTO 생성 지침서

모든 프로젝트에서 공통으로 사용할 DTO 생성 기준이다.

## 1. 기본 규칙

- DTO는 요청/응답을 반드시 분리한다.
- 요청 모델은 `Encodable`만 사용한다.
- 응답 모델은 `Decodable`만 사용한다.
- `Codable`은 사용하지 않는다.
- DTO는 API payload 표현까지만 담당한다.

## 2. 위치와 이름

- DTO는 기능 단위 `DTO` 폴더 아래에 둔다.
- `DTO` 폴더가 없으면 먼저 생성한다.
- feature 위치를 찾지 못하면 파일을 임의 생성하지 않고 DTO 코드를 컨텍스트에 바로 제시한다.
- 신규 DTO 파일은 프로젝트 기본 파일 헤더를 포함한다.
- 컨텍스트에 DTO 코드를 바로 제시할 때는 파일 헤더를 포함하지 않는다.
- 요청 DTO 이름은 `기능명 + ReqDTO`
- 응답 DTO 이름은 `기능명 + ResDTO`
- `RequestDTO`, `ResponseDTO`, `Request`, `Response` 같은 이름은 새로 만들지 않는다.

예시:

```text
Feature/SomeFeature/DTO/
├── SomeFeatureReqDTO.swift
└── SomeFeatureResDTO.swift
```

## 3. 스웨거 반영 규칙

- 스웨거 스키마 기준으로 타입을 그대로 만든다.
- 서버 필드명은 그대로 사용한다.
- 서버가 `snake_case`를 주면 `snake_case` 그대로 선언한다.
- optional 여부도 스웨거 기준으로 맞춘다.
- 스웨거의 설명, example, enum 정보는 그대로 반영한다.

## 4. 구조 규칙

- 특정 DTO 안에서만 쓰는 구조는 nested type으로 선언한다.
- nested type은 가능하면 parent DTO 타입 내부에 직접 선언한다.
- 중첩 타입 이름에는 `DTO` suffix를 붙이지 않는다.
- 서버 raw value가 고정된 값은 DTO 내부 enum으로 선언한다.
- 공통 응답 래퍼가 있으면 feature DTO에서 중복 정의하지 않는다.

## 5. `CodingKeys` 규칙

- 기본적으로 `CodingKeys`는 사용하지 않는다.
- 서버 키 이름을 camelCase로 바꿔서 매핑하지 않는다.
- 정말 키 이름을 그대로 선언할 수 없는 경우에만 예외적으로 사용한다.

허용 예외:

- Swift 예약어 충돌
- 일반적인 선언만으로 처리할 수 없는 특수 디코딩

## 6. 주석과 공백 규칙

- 파일 최상단에는 프로젝트 기본 파일 헤더를 유지한다.
- 타입 상단에는 DTO 역할을 1줄로 적는다.
- 필드 주석은 스웨거 설명과 example을 그대로 붙인다.
- example, default 같은 부가 정보는 `/// - default: 1`처럼 bullet 형태로 붙인다.
- enum 자체에는 역할만 짧게 적고, 각 case에는 스웨거 설명을 그대로 붙인다.
- 필드 사이 기본 개행 없음
- enum case 사이도 개행 없음
- 정말 성격이 다른 큰 묶음만 한 줄 띄움
- 스웨거 주석은 붙이되, 줄 간격은 늘리지 않음

예시:

```swift
/// 사용자 권한
enum Role: String, Decodable {
    /// 소셜 게스트
    case socialGuest = "SOCIAL_GUEST"
    /// 일반 사용자
    case user = "USER"
}
```

## 7. 금지 규칙

- `Codable` 사용
- 요청/응답 모델 통합
- DTO 안에 domain 변환 메서드 작성
- DTO 안에 화면 모델 변환 메서드 작성
- DTO 안에 UI 포맷팅 작성
- DTO 안에 외부 의존성 접근
- DTO 안에 네트워크 호출 작성

## 8. 최소 템플릿

```swift
//
//  LoginResDTO.swift
//  BoraScaffold
//
//  Created by 신정욱 on 11/14/25.
//

import Foundation

/// 로그인 요청 DTO
struct LoginReqDTO: Encodable {
    /// 이메일
    let email: String
    /// 비밀번호
    let password: String
}

/// 로그인 응답 DTO
struct LoginResDTO: Decodable {
    /// 액세스 토큰
    /// - default: access-token
    let accessToken: String
    /// 리프레시 토큰
    /// - default: refresh-token
    let refreshToken: String

    /// 사용자 정보 DTO
    struct User: Decodable {
        /// 사용자 아이디
        let id: Int
    }
}
```

## 9. 체크리스트

- `DTO` 폴더 아래에 만들었는가?
- `DTO` 폴더가 없을 때 새로 만들었는가?
- 요청/응답을 분리했는가?
- 요청은 `Encodable`인가?
- 응답은 `Decodable`인가?
- `Codable`을 쓰지 않았는가?
- 파일명이 `ReqDTO` / `ResDTO` 규칙을 따르는가?
- 신규 파일에 프로젝트 기본 파일 헤더가 들어갔는가?
- feature를 찾지 못해 컨텍스트에 DTO 코드를 보여준 경우 파일 헤더를 제외했는가?
- 서버 필드명을 그대로 썼는가?
- `snake_case`를 그대로 유지했는가?
- 중첩 타입 이름에 `DTO` suffix를 붙이지 않았는가?
- nested type을 parent DTO 내부에 직접 선언했는가?
- `CodingKeys` 없이 그대로 선언할 수 있는데 굳이 쓰지 않았는가?
- 필드/enum case 사이에 불필요한 개행을 넣지 않았는가?
- 공통 래퍼 필드를 feature DTO에 중복 선언하지 않았는가?
- feature를 찾지 못한 경우 파일 생성 대신 컨텍스트에 DTO 코드를 보여줬는가?
