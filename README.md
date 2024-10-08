메인
    투두 그룹핑
    정렬
    알림
세팅
    테마?
    보안 비밀번호
    버저닝
    언어
    폰트?
    데이터 백업
    데이터 내보내기

sqlite dbname: todolumi.db

date -> str iso
bool -> int (1 or 0)

table user 
    sn int pk auto
    name str?
    uuid str?
    is_deleted bool default false
    created_by int? 
    created_at date default now
    updated_by int? 
    updated_at date default now


talbe todo
    sn int pk auto
    todo_group_sn int?
    todo str
    is_clear bool default false
    progress int default 0
    order int?
    start_at date?
    end_at date?
    is_repeat bool default false
    repeat_type str? 
    is_alarm bool default false
    alarm_type str?
    is_deleted bool default false
    created_by int? 
    created_at date default now
    updated_by int? 
    updated_at date default now

table todo_group
    sn int pk auto
    name str
    is_deleted bool default false
    created_by int? 
    created_at date default now
    updated_by int? 
    updated_at date default now

table todo_tag
    sn
    name
    todo_sn
    is_deleted
    created_by
    created_at
    updated_by
    updated_at




기본 기능
할 일 목록 생성 및 관리

사용자는 새로운 할 일을 생성하고 편집할 수 있습니다.
할 일을 완료로 표시하거나 삭제할 수 있습니다.
할 일의 우선순위를 설정할 수 있습니다.
할 일 카테고리화 및 태깅

사용자는 할 일을 카테고리별로 분류하거나 태그를 추가할 수 있습니다.
할 일을 프로젝트나 목표에 연결할 수 있습니다.
기한 및 알림 설정

각 할 일에 마감일을 설정하고, 마감일이 다가올 때 알림을 받을 수 있습니다.
반복적인 할 일에 대한 주기적 알림을 설정할 수 있습니다.
필터 및 정렬

할 일을 기한, 우선순위, 상태(완료, 미완료 등) 등으로 필터링 및 정렬할 수 있습니다.
특정 태그나 카테고리별로 할 일을 볼 수 있습니다.
검색 기능

사용자는 키워드로 할 일을 검색할 수 있습니다.
완료된 할 일 기록

완료된 할 일을 아카이브하여 기록으로 남길 수 있습니다.
일정 기간이 지난 할 일은 자동으로 삭제되도록 설정할 수 있습니다.
고급 기능
협업 기능

다른 사용자와 할 일을 공유하고 협력할 수 있습니다.
팀 프로젝트를 관리하고 할 일을 할당할 수 있습니다.
댓글 기능을 통해 팀원과 소통할 수 있습니다.
통계 및 보고서

사용자의 할 일 완료 성과를 시각적으로 보여주는 통계 대시보드를 제공합니다.
특정 기간 동안의 생산성 보고서를 생성할 수 있습니다.
캘린더 통합

구글 캘린더나 아웃룩 캘린더와 통합하여 일정을 동기화할 수 있습니다.
캘린더 뷰로 할 일을 볼 수 있습니다.
위치 기반 알림

사용자의 위치에 따라 특정 할 일에 대한 알림을 받을 수 있습니다.
예를 들어, 특정 장소에 도착했을 때 할 일을 알림으로 받을 수 있습니다.
다양한 플랫폼 지원

웹, 모바일(Android/iOS), 데스크탑(Windows/Mac) 등 여러 플랫폼에서 사용할 수 있는 기능.
플랫폼 간 데이터 동기화 및 백업.
다크 모드 및 테마 설정

사용자 인터페이스(UI) 테마를 변경할 수 있는 기능.
다크 모드 지원으로 눈의 피로를 줄일 수 있습니다.
첨부 파일 및 노트 추가

할 일에 관련된 파일이나 이미지를 첨부할 수 있습니다.
할 일에 대한 추가 정보를 위한 노트를 추가할 수 있습니다.
음성 입력 및 AI 지원

음성 인식을 통해 할 일을 추가하고 관리할 수 있습니다.
AI 기반 추천 및 자동 분류 기능으로 할 일을 보다 효율적으로 관리할 수 있습니다.
위젯 및 알림 센터

홈 화면에 위젯으로 할 일을 빠르게 볼 수 있는 기능.
알림 센터를 통해 할 일의 진행 상황을 추적할 수 있습니다.
타임 블로킹

시간 관리 기술 중 하나로, 사용자가 할 일에 필요한 시간을 계획하고 블로킹할 수 있도록 도와줍니다.
정리 및 회고 기능

주간/월간 회고 기능을 통해 사용자 자신의 업무를 돌아보고 개선할 수 있는 기능.
보안 및 프라이버시

비밀번호 보호 및 데이터 암호화.
사용자 데이터를 안전하게 백업하고 복원할 수 있는 기능.
유저 경험 (UX) 고려 사항
직관적이고 간편한 사용자 인터페이스(UI)

사용자가 빠르게 학습하고 사용할 수 있도록 직관적인 UI를 제공해야 합니다.
모바일과 데스크탑에서 일관된 사용자 경험을 제공합니다.
사용자 맞춤 설정

사용자의 취향에 맞춰 테마, 알림, 카테고리 등을 설정할 수 있는 기능.
사용자 피드백을 바탕으로 지속적으로 개선.
오프라인 모드

인터넷 연결이 없을 때도 사용할 수 있는 기능.
오프라인에서 수행된 작업은 온라인 상태로 전환되면 자동으로 동기화됩니다.