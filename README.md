## CANVAS 다운로드
<p float"left>
  <a href="https://apps.apple.com/kr/app/id1596669616">
    <img src="https://user-images.githubusercontent.com/20364535/147945401-1a372903-becb-4cd8-af0c-15ebf9ce4858.png" width="250" height="250" style="border-radius:50%">
  </a>
</p>

> **"순간 순간의 감정을 그림으로 기록하세요"** <br/><br/>
> **개발 기간 :  21.08.27 ~ 21.12.01** <br/><br/>
> **팀 소개 : [박준홍](https://github.com/feldblume5263), [이재영](https://github.com/ejei0g)**
<br/>

## 프로젝트 소개

**프로젝트 사례 발표**
<p float"left>
  <a href="https://youtu.be/zNynKuK6wUE?t=15881">
    <img src="https://user-images.githubusercontent.com/53016167/148317435-db297ca1-7f4a-40d5-a12d-40a62989e46c.png" width="400">
  </a>
  <a href="https://youtu.be/zNynKuK6wUE?t=15881">
      유튜브 영상으로 바로가기
  </a>
</p>
<br/><br/>
<p float"left>
  <p>
    <img width="400" src="https://user-images.githubusercontent.com/20364535/148074891-b98b2ae9-0ebc-4cc0-8118-b7eb75a2e856.jpeg">
    <img width="400" src="https://user-images.githubusercontent.com/20364535/148074914-416d5853-139c-4f05-af22-d6d96774e9dd.jpeg">
  </p>
  <p>
    <img width="400" src="https://user-images.githubusercontent.com/20364535/148074922-95d41586-6873-4185-b1a3-42cc3e642973.jpeg">
    <img width="400" src="https://user-images.githubusercontent.com/20364535/148074938-2ad4dbe0-4bea-4e0b-884d-a4485c17e465.jpeg">
  </p>
</p>

</p>
<br/>

## 개발환경 및 라이브러리
![swift](https://img.shields.io/badge/swift-5.0-orange)
![xcode](https://img.shields.io/badge/Xcode-13.2-blue)
![firebase](https://img.shields.io/badge/Firebase-8.9.0-red)
![snapkit](https://img.shields.io/badge/SnapKit-5.0.1-yellow)

<br/>

## 프로젝트 Feature

#### DB
- CoreData : CoreData프레임워크를 사용하여 SQLite 파일을 관리<br/>
#### Canvas 화면
- 사용자의 하루 단위(혹은 최근 10개 기록단위)를 모은 그림을 카드 형식으로 한장씩 넘겨가면서 보여주는 Custom CollectionView<br/>
- Animation 처리된 도형 (평상시/Shake 기능을 통해 흔들었을 때)<br/>
- 현재 그림의 기록을 최신순으로 넘겨볼 수 있는 Info모듈<br/>
#### 기록 화면
- 게이지 조작부터 기록 작성 완료까지 물 흐르듯이 간편한 사용자 경험 Flow<br/>
- 현재 사용자의 감정을 UIPangesutre와 Animation을 통해 입력하는 GaugeView<br/>
- 출시 이후 사용자 피드백을 반영하여 날짜, 시간 수정 모듈을 추가<br/>
#### 일기장 화면
- 쌓인 기록들을 날짜순, 시간순으로 보여주는 Custom TableView<br/>
- 기록으로 바로가기 기능을 지원하는 Calandar 모듈<br/>
- 안전하고 간편한 삭제가 가능한 Cell<br/>
<br/>

## 아키텍쳐
- MVC Design Pattern
- Delegate Pattern
<br/>

## 기술적 도전 및 개선 사례
#### UI / 사용자경험 측면
- Canvas라는, 전체적으로 통일감 있는 사용자 경험을 느낄 수 있도록 모든 View에서 테마의 느낌과 글시체의 통일성을 고려하였음<br/>
- 비율을 사용하여 View frame를 구성했을 떄, 8과 SE를 비롯한 예전 디바이스의 디스플레이 비율이 달라 발생하는 문제를 오토레이아웃을 통해서 해결<br/>
- 유저가 Gesture을 통해 화면간 이동을 조작할 수 있도록 필요한 위치에 UIGestureRecognizer을 사용하여 적용<br/>
#### DB
- 출시 직전, 기존의 단일 Entity에서 Entity를 추가하여 Relationship을 통해 기록과 테마를 Date별로 관리하여 빠르게 접근 가능하고, 독립적으로 테마 구성이 가능하도록 하였음<br/>
날짜별, 시간별 분류 작업을 최악의 경우 O(기록의 개수^2 * sorting시간복잡도)에서 O(Date개수 * sorting시간복잡도)로 단축하였음</br>
-> 현재는 3년 동안 매일 10개씩 기록을 작성했을 때, 딜레이 체감 없이 사용 가능하지만 추후 당장 필요한 DB를 제한해서 분류하는 리팩토링이 필요</br>
- DB seeder를 통한 무작위 DB 생성을 통해 테스트에 활용<br/>
context: [🔗](https://hasensprung.tistory.com/69) EX1: [🔗](https://hasensprung.tistory.com/70) EX2: [🔗](https://hasensprung.tistory.com/71) EX3: [🔗](https://hasensprung.tistory.com/72) EX4: [🔗](https://hasensprung.tistory.com/73)<br/>
#### Canvas 화면
- Canvas가 스와이프가 절반 이상 진행되었을떄 한장씩만 넘어가도록 UIScrollViewDelegate에서 scrollViewWillEndDragging을 구현함.
- 기존에 사용했던 애니메이션 라이브러리를 애플에서 제공하는 기본 클래스(UIViewPropertyAnimator)를 사용해서 리펙토링<br/>
CPU 사용량을 70%에서 10%로 개선 [🔗](https://jaeylee.notion.site/UIViewPropertyAnimator-43fa9b329a174650b59cd14e4d9e84f7)<br/>
- 최신 기록을 보여주는 Info모듈의 경우, UITapGestureRecognizer를 사용하여 상황에 따라 다른 Taptic을 적용하여 유저가 착오없이 사용할 수 있도록 업데이트함.
#### 기록 화면
- 사용자 UX 개선을 위해 게이지와 애니메이션을 활용해서 Gauge Custom View 개발 [🔗](https://github.com/hasen-sprung/iOS_Canvas/wiki/gauge-view-prototype)<br/>
- 키보드 중첩 문제를 Notification과 오토레이아웃 Constraints를 사용해서 해결 [🔗](https://jaeylee.notion.site/SnapKit-and-Keyboard-10f5520be1e642a98e875a7cec304b1d)<br/>
#### 일기장 화면 
- UITalbeView를 Custom할 때, text 길이에 따라 자동적으로 Cell의 높이를 조절해주기 위해 autoDemesion 사용 [🔗](https://hasensprung.tistory.com/79)<br/>
- UIGestureRecognizer을 사용할 때, UITalbeView와 UITableViewCell의 Swipe action이 작동하지 않는 문제를 addGestureRecognizer을 통해 해결[🔗](https://hasensprung.tistory.com/96)
- Cell 삭제시 안전한 삭제를 위해서 Alert를 통한 유저 확인 절차 추가 [🔗](https://hasensprung.tistory.com/95)<br/>
#### 설정 화면
- 개발자에게 메일 보내기 구현
- 외부 앱 (앱스토어)으로 사용자 이동시키기
#### 위젯
- UIKit 기반 앱에서 WidgetKit을 사용해서 위젯 개발 [🔗](https://jaeylee.notion.site/Set-Widget-in-UIkit-based-App-351d26d3fc38455093a8864581d79e41)<br/>
- CoreData, UserDefault 데이터 공유를 위해 AppGroup 사용 [🔗](https://jaeylee.notion.site/Get-Data-in-CoreData-2ab732209eaf4fb496d71211625b53fd)<br/>
#### 의존성 도구
- 코코아팟에서 SPM으로 변경시 발생했던 에러 처리 [🔗](https://jaeylee.notion.site/SPM-Delete-CocoaPods-06bb2700857843cea9c29ac384ab0107)<br/>
<br/>
<br/>

## How We Develop (문서화, 회의록, 개발 일지)
[wiki 바로가기](https://github.com/hasen-sprung/iOS-EmoRec/wiki)
