# 🗓 README
#### ✨ iyeah & 🍏 Jenna <br>
##### 2023년 1월 30일 → 2023년 2월 10일

　
 
# Step 1️⃣
## \# 트러블 슈팅
### 👿 트러블
> 기존 프로젝트 코드를 가져오면서, 프로젝트 및 폴더명을 바꿔야 할 지 고민

### 😈 해결 방법
> 타겟 `ContactManagerUI`을 새로 추가한다는 것은 프로젝트에 별도의 제품을 만든다는 것이므로,
오히려 이름을 같게 맞추려 할 필요가 없음을 깨달아 프로젝트 및 폴더명 유지

 
## \# 학습내용 요약
>`Target`
하나의 타겟은 하나의 프로덕트이며,
프로젝트 내에 여러 개의(= 별개의) 타겟(프로덕트)이 존재할 수 있다.



　
　　
<br>
# Step 2️⃣
## \# 트러블 슈팅
### 👿 트러블
> 더미 데이터를 Model인 `ContactManageSystem`에 넣을지, `ViewController`에 구현 해야할 지에 대한 고민

### 😈 해결 방법
<details>
<summary>리뷰어 의견 🐶</summary>
더미 데이터 자체를 상수처럼 만들어서 ViewController에서 처리하는게 저는 더 깔끔한 것 같아요! 상수처럼 쓰고 나중에 제거하면 되니까요!
</details>

→ `ViewController`에 `dummyData`를 상수로 선언하여 해결

　
### 👿 트러블
> MVC 폴더에 넣기 애매한 파일들 처리

### 😈 해결 방법
<details>
<summary>리뷰어 의견 🐶</summary>
이 부분은 정해져있는 답은 없으니, 팀 내에서 약속해서 폴더로 정리해도 괜찮습니다. <br>MVC 폴더 밖으로 빼두는 것도 좋습니다. <br>LaunchScreen을 따로 폴더로 만드는 경우도 있고, AppConfiguration과 같이 폴더를 만들어서 AppDelegate, SceneDelegate 파일을 넣기도합니다. <br>제가 말씀드린 부분은 참고만하시고 팀원과 같이 이야기해보면 좋을 것 같습니다:)
</details>

→ 아래와 같이 폴더링 진행

![](https://i.imgur.com/cUjN62R.png)


　
## \# 학습내용 요약
> 1. 더미데이터가 필요하다면 원하는 시점에 삭제가 편하도록 상수로 구현
> 2. 폴더링은 정해진 게 없기 때문에 팀원과 상의해서 정하기

 

<br>
 
# Step 3️⃣
## \# 트러블 슈팅
### 👿 트러블
> `.phonePad`는 -입력을 지원하지 않음
→ 아이폰 기본앱처럼, 텍스트필드에 값이 입력될 때마다 `-`가 적절한 위치에 삽입되게끔 자동변환 해주는 로직을 추가로 구현할 필요가 생김

### 😈 해결 방법
> `textField(_:shouldChangeCharactersIn:replacementString:)`메서드

- `AddProfileViewController가` `UITextFieldDelegate`프로토콜을 채택
- `textField(_:shouldChangeCharactersIn:replacementString:)`메서드로 새로운 입력의 종류에 따라 
   - 연락처 텍스트필드에서의 입력을 허용하거나, 
   - 또는 양식에 맞춘 변환값으로 대체하여 직접 할당(입력 거절)
- `PhoneNumberRegularExpressions`열거형으로 자릿수별 변환 방식을 정의

　
## \# 학습내용 요약
> Delegate의 정의는 `위임하다`, 
개인적으로 Delegate Pattern이란 `책임자-대리자 패턴` 이라고 이해
#### 프로젝트에 적용한 부분 ▼
- `AddProfileViewController`(이하 AddVC)는 **책임자**
- `ListProfileViewController`(이하 ListVC)는 `AddProfileViewControllerDelegate`(이하 AddVCDelegate) 자격증을 가짐
- `ListVC`는 새로운 뷰(`AddV`)를 올릴 때 본인(self)을 그 뷰컨트롤러(`AddVC`)의 **대리자**(Delegate)로 지정하여 함께 보내지고,
   ```Swift
   AddVC.delegate: AddVCDelegate = self    //self: ListVC(AddVCDelegate로서의 ListVC)
   ```
- 대리자는 책임자(AddVC) 내에 머물며(= .delegate변수에 할당된 채) 
대리자로서 요구받은 동작(프로토콜 필수구현 메서드)을 적절한 시점에 수행
   ```Swift
   // 그 동작은 AddProfileViewController에서 'Save버튼이 눌렀을 때' 호출되어,
   // (검증 완료된) 새로운 이름·나이·연락처 정보를 조합하여 프로필을 생성(= 요구받은 동작)
   delegate?.updateProfile(name: name, age: age, tel: tel)
   dismiss()
   ```
- `AddV`가 내려가면 대리자 역할을 마무리하고 돌아온 `ListVC`는 그 데이터(새 프로필)를 받아 필요한 작업(profiles에 새 프로필을 등록)을 이어서 수행



　
　
<br>

# Step 🅱🅾🅽🆄🆂
## \# 트러블 슈팅
### 👿 트러블
> 검색결과 화면에서도 올바른 셀이 삭제되도록 하기

### 😈 해결 방법
삼항연산자를 활용하여, `isSearching`에 따라 
index로 접근할 프로필 배열이 `profiles` / `filteredProfiles` 중 어느쪽인지 결정하는 로직을 추가
```Swift
let profile = isSearching ? profileSearchResults[indexPath.row] : profiles[indexPath.row]
```

　
### 👿 트러블
> 동명이인이 있어도 정확히 삭제되도록 하기

### 😈 해결 방법
1. 초반에 profiles에서 `name`이 일치하는 결과를 가져오려고 했지만, 동명이인이 대신 삭제되는 문제가 발생
2. Model인 `Profile`이 Hashable프로토콜(= 즉 Equatable도 채택함)을 채택했으므로 커스텀 이항연산자를 구현해보려다가 아래와 같은 발상이 떠올라 보류
3. `tableView(_:cellForRowAt:)`메서드에서 `indexPath.row`로 `profile`을 불러왔으므로, 역으로 해당 index의 profile을 꺼내어 삭제하면 해당 셀의 profile이 삭제될 거라고 생각하고 구현

　
### 👿 트러블
> 이름에 대소문자가 섞여 있을 때 오름차순으로 올바르게 정렬되지 않고 검색이 되지 않음

### 😈 해결 방법
오름차순 정렬 시 `lowercased()` 메서드를 적용하여 대소문자 구분없이 sort되도록 함

　
　
## \# 학습내용 요약
### searchBar 만들기
> **UISearchBar와 UISearchController의 차이**
> - VC.navigationItem.searchController: `UISearchController`
> - UISearchController().searchBar: `UISearchBar`
### 슬라이드하여 해당 셀 delete 하기
> `UITableViewDataSource` 프로토콜 내에 있는 `tableView(_:commit:forRowAt:)` 메서드 사용





　
 　
