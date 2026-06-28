---
name: create-dto
description: 이 프로젝트의 Swift 요청·응답 DTO를 생성하고 리뷰하는 스킬이다. 사용자가 스웨거 스키마를 붙여놓고 "응답 모델 만들어줘", "요청 모델 만들어줘", "요청/응답 DTO 만들어줘"처럼 말할 때 사용한다. API payload 모델 추가, 수정, 리팩터링, DTO 폴더 구조 정리, ReqDTO·ResDTO 네이밍 적용, Encodable·Decodable 분리, nested type 구성, CodingKeys 사용 여부 판단, Swagger 스키마 기반 필드 정의가 필요할 때 사용한다.
---

# Create DTO

DTO 파일을 생성하거나 리뷰하기 전에 `references/create-dto.md`를 먼저 읽어.

## 작업 순서

1. 요청 DTO가 필요한지, 응답 DTO가 필요한지, 둘 다 필요한지 먼저 판단해.
2. DTO 파일은 해당 feature의 `DTO` 폴더 아래에 둬. `DTO` 폴더가 없으면 먼저 만들어.
3. 파일명과 타입명은 `ReqDTO`, `ResDTO` 규칙으로 맞춰.
4. 요청 DTO는 `Encodable`, 응답 DTO는 `Decodable`만 사용해.
5. 필드명, `snake_case`, optional 여부, enum, example, 설명은 Swagger 스키마를 그대로 반영해.
6. DTO는 API payload 표현까지만 담당하게 유지해.
7. feature 위치를 끝내 찾지 못하면 파일을 임의 생성하지 말고, DTO 코드를 현재 컨텍스트에 바로 보여줘.
8. 마무리 전에 아래 체크리스트로 한 번 더 검토해.

## 출력 규칙

- 신규 DTO 파일에는 프로젝트 기본 파일 헤더를 포함해.
- 컨텍스트에 DTO 코드를 바로 보여줄 때는 파일 헤더를 포함하지 않아.
- 요청 DTO와 응답 DTO는 반드시 분리해.
- `Codable`은 사용하지 않아.
- `RequestDTO`, `ResponseDTO`, `Request`, `Response` 같은 새 타입명은 만들지 않아.
- feature의 `DTO` 폴더가 없으면 직접 생성해.
- feature 자체를 찾지 못하면 파일 생성 대신 DTO 코드를 컨텍스트에 출력해.
- 서버 필드를 `camelCase`로 바꾸지 않아.
- 필드명을 Swift에서 그대로 선언할 수 없거나 특수 디코딩이 필요한 경우가 아니면 `CodingKeys`를 쓰지 않아.
- 한 DTO 내부에서만 쓰는 구조는 nested type으로 선언해.
- nested type은 가능하면 parent DTO 타입 내부에 직접 선언해.
- nested type 이름에는 `DTO` suffix를 붙이지 않아.
- 공통 응답 래퍼가 있으면 feature DTO에서 다시 정의하지 않아.
- DTO 안에는 domain 변환, UI 포맷팅, 외부 의존성 접근, 네트워크 호출을 넣지 않아.

## 주석 규칙

- 각 DTO 타입 상단에 역할 주석을 한 줄 작성해.
- 필드와 enum case 주석은 Swagger 설명을 그대로 반영해.
- default, example 같은 부가 정보는 `/// - default: ...` 형식으로 작성해.
- 파일 헤더가 있는 경우 DTO 역할 주석보다 위에 유지해.
- 필드나 enum case 사이에는 불필요한 빈 줄을 넣지 않아.

## 최종 체크리스트

- 파일이 feature의 `DTO` 폴더 아래에 있는가?
- `DTO` 폴더가 없을 때 새로 만들었는가?
- 요청 DTO와 응답 DTO가 분리되어 있는가?
- 요청 DTO는 `Encodable`만 사용하는가?
- 응답 DTO는 `Decodable`만 사용하는가?
- `Codable`을 쓰지 않았는가?
- 파일명과 타입명이 `ReqDTO`, `ResDTO` 규칙을 따르는가?
- 신규 파일에 프로젝트 기본 파일 헤더가 포함되어 있는가?
- feature를 찾지 못해 컨텍스트에 DTO 코드를 보여준 경우 파일 헤더를 제외했는가?
- 서버 필드명과 `snake_case`를 그대로 유지했는가?
- DTO 내부 전용 구조를 nested type으로 만들고 `DTO` suffix를 붙이지 않았는가?
- nested type을 parent DTO 내부에 직접 선언했는가?
- `CodingKeys`를 꼭 필요한 예외에만 사용했는가?
- 빈 줄을 최소화했는가?
- 공통 래퍼 필드를 feature DTO에 중복 선언하지 않았는가?
- feature를 찾지 못한 경우 파일 생성 대신 컨텍스트에 DTO 코드를 보여줬는가?

## 참고 자료

전체 한글 지침, 템플릿, 상세 체크리스트는 `references/create-dto.md`를 참고해.
