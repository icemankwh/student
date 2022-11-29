
####  변수다루기 ####
a <- 1 # a 에 1을 할당
a      # a 출력
print(a) # 마찬가지로 a  출력
b <- 2
b
c <- 10
print(c)

a+b
a+b+c
b/4
5*a

# 여러 값으로 구성된 변수 만들기

var1 <- c(1,2,5,8,10)
var1

var2 <- c(1:5) # 1부터 5까지 연속값으로 변수 생성
var2

var3<- seq(1,10) # 1부터 10까지 연속값으로 변수 생성
var3

var4 <- seq(1,10, by=2) # 1-10까지 2간격으로 변수 생성
var4

# 여러값의 변수로도 연산 가능

var1
var1+2

# 여러값의 변수간의 연산가능
var1
var2
var1+var2

#### 함수 다루기 ####
#함수를 이용하여 계산하기

x <- c(5,7,10)
x

mean(x)  # 평균값
max(x)   # 최대값
min(x)   # 최솟값

#### 패키지(package) ####

# 패키지 설치

install.packages("ggplot2") # 괄호안에 설치할 패키지 이름 입력, 앞 뒤에 따옴표를 넣어야함
library("ggplot2") # 패키지를 로드하기, 따옴표를 넣어도 되고 안 넣어도 됨

#함수 사용해보기
x <- c("a","a","b","c")
x
qplot(x)


#### R 데이터 프레임 다루기 ####

### 직접 입력으로 데이터 프레임 만들기
age <- c(6,8,6,3)
age

bw <- c (13,4,5,7)
bw

df_clinic <-data.frame(age,bw)
df_clinic

sex <-c(1,1,2,2)
sex

df_clinic <-data.frame(age,bw,sex)
df_clinic

# 분석하기
mean(df_clinic$age) # 병원방문견 나이 평균
mean(df_clinic$bw)  # 병원방문견 몸무게 평균균

# 데이터 프레임 한번에 만들기

df_clinic <- data.frame(age=c(5,8,6,3),
                        bw= c(13,4,5,6),
                        sex= c(1,1,2,2))
df_clinic

### 데이터를 csv로 저장
df_clinic

write.csv(df_clinic, file="df_clinic.csv")

### 외부데이터 이용하기
### csv 파일 불러오기
# csv란? 대부분 프로그램에서 사용하는 범용 데이터 파일 
# CSV : Comma-Seperated Values)

df_clinic_csv <-read.csv("csv_data.csv")
df_clinic_csv

## 데이터 설명 : 병원에 방문한 개들에게 영양제를 먹이기 전, 특정 균의 양을 측정하고 영양제를 먹인후 특정 균의 양을 측정하여 
## 영양제의 치료효과를 확인함
## id : 방문견 번호
## group: low- 저용양  mid- 중간용량  control- 먹이지 않음
## sex : 성별,  F=Female/암컷  M=Male/수컷 
## age : 나이, 단위는 년
## bw : 몸무게  body weight,  단위는 kg
## bcs : body condition score, 9단계
## normal : 영양제를 먹기전 균의 양
## treat : 영양제를 먹은후 균의 양


## 데이터 프레임 파악하기  
## 데이터가 주어질때 가장 먼저 하는일 : 데이터의 전반적인 구조 파악

dog <- read.csv("csv_data.csv")
dog

head(dog) # 앞에서 부터 6행까지 출력
tail(dog) # 데이터 뒷부분 확인
View(dog) # 뷰어창에서 직접 보여줌, V는 대문자
summary(dog) # 전체 요약

mean(dog$normal) #평균 mean
sd(dog$normal) # 표준편차, standard deviation

mean(dog$treat)
sd(dog$treat)

install.packages("data.table")
library("data.table")

# dog를 데이터 테이블화
dt<-data.table(dog)
# 그룹별 영양제 먹기 전 균량 평균 및 표준편차
dt[,list(mean=mean(normal),sd=sd(normal)),by=group]
# 그룹별 영양제 먹은 후 균량 평균 및 표준편차
dt[,list(mean=mean(treat),sd=sd(treat)),by=group]


#### 그래프 그려보기 ####

install.packages("tidyverse")
library("tidyverse")
library("dplyr")

## ggplot(데이터이름) +  geom_기능(aes(변수정보))

## scatter plot 점그래프
# dog 데이터에서  x 축은 age로 y 는 bw로
ggplot(dog)+
  geom_point(aes(x=age, y=bw))

# 사이즈 3, 색깔 파란색, 모양 X자
ggplot(dog)+
  geom_point(aes(x=age, y=bw),size=3,color="blue",shape=4)

## boxplot
ggplot(data=dog, aes(x=group, y=normal))+
  geom_boxplot()

# group별로 색깔 부여
ggplot(data=dog, aes(x=group, y=normal, color=group))+
  geom_boxplot()
# box 안에 group색깔 부여
ggplot(data=dog, aes(x=group, y=normal, fill= group))+
  geom_boxplot()
# boxplot과 점그래프를 한번에
ggplot(data=dog, aes(x=group, y=normal))+
  geom_boxplot()+
  geom_jitter(size=1.5, width=0.2,height=1.5)

#### 데이터 통계분석 ####

#### 1. anova test
## 3 개의 다른 군에서 각 데이터 간의 통계적으로 차이점이 있는지 파악하는 분석
## dog  데이터에서 group 별로 normal, 영양제 먹기 전 균량간의 통계적 차이를 분석
normal.aov <- aov(normal ~ group, data = dog)
summary(normal.aov)

## dog  데이터에서 group 별로 treat, 영양제 먹은 후 균량간의 통계적 차이를 분석
treat.aov <- aov(treat ~ group, data = dog)
summary(treat.aov)

## 결과 해석
## p value < 0.05
## 영양제 먹기 전에 균량에는 차이가 없었으나 먹은후 그룹간에 통계적으로 유의한 균량의 차이를 보였다.

#### 2. paired t test 
## 같은 군내에서 치료 전 후 간의 통계적인 차이가 있는지를 확인하는 분석
## 먼저 데이터프레임을 분해
# 저용량군 추출
low <- subset(dog,subset = group == 'low')
low

# low 에서 normal, low 에서 treat 간의 paired-t-test
t.test(low$normal, low$treat, paired = TRUE)

## 결과해석
## p value < 0.05
## 영양제 투입 전후로 통계적으로 유의한 균량의 차이를 보였다.
