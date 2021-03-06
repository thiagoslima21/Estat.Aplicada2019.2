#Thiago Augusto - TRABALHO DATASUS

install.packages("read.dbc")
require(read.dbc)
dados<-read.dbc("DNPE2017.dbc")
require(dplyr)
dados$IDADEMAE=as.numeric(as.character(dados$IDADEMAE))
dados1<-filter(dados,IDADEMAE>=18, IDADEMAE<=40, LOCNASC==1, IDANOMAL==2)
summary(dados)
dados1<-select(dados1,NUMERODN,CONSPRENAT, IDADEMAE,ESTCIVMAE,ESCMAE2010,RACACORMAE,TPROBSON,PARIDADE,GRAVIDEZ,SEMAGESTAC,KOTELCHUCK,TPAPRESENT,PARTO,SEXO,PESO,RACACOR )
dados1$TPROBSON=as.numeric(as.character(dados1$TPROBSON))
dados1$CONSPRENAT=as.numeric(as.character(dados1$CONSPRENAT))
dados1$PESO=as.numeric(as.character(dados1$PESO))
dados1$SEMAGESTAC=as.numeric(as.character(dados1$SEMAGESTAC))
dados1<-filter(dados1,CONSPRENAT!=99,ESTCIVMAE!=9,ESCMAE2010!=9,KOTELCHUCK!=9,TPAPRESENT!=9)
dados1<-na.omit(dados1)
rm(dados)
dados1$ESTCIVMAE=factor(dados1$ESTCIVMAE,labels=c("Solteira","Casada","Vi�va","Separada judicialmente","Uni�o Consensual"))
dados1$ESCMAE2010=factor(dados1$ESCMAE2010,labels=c("Sem Escolaridade","Fundamental 1","Fundamental 2","M�dio","Superior Incompleto","Superior Completo"))
dados1$RACACORMAE=factor(dados1$RACACORMAE,levels=c("Branca","Negra","Amarela","Parda","Ind�gena"))
dados1$PARIDADE=factor(dados1$PARIDADE,labels=c("1�Gesta��o","N�o � a 1�Gesta��o"))
dados1$GRAVIDEZ=factor(dados1$GRAVIDEZ,labels=c("�nica","Dupla","Tripla ou mais"))
dados1$TPAPRESENT=factor(dados1$TPAPRESENT,labels=c("Cef�lica","P�lvica ou Pod�lica","Transversa"))
dados1$PARTO=factor(dados1$PARTO,labels=c("Vaginal","Ces�reo"))
dados1$RACACOR=factor(dados1$RACACOR,labels=c("Branca","Negra","Amarela","Parda","Ind�gena"))
dados1$SEXO=factor(dados1$SEXO,labels=c("Homem","Mulher"))
dados1$KOTELCHUCK=factor(dados1$KOTELCHUCK,labels=c("N�o fez Pr�-Natal","Inadequado","Intermedi�rio","Adequado","Mais que Adequado"))
summary(dados1)
attach(dados1)
#EXERC�CIOS
#1
install.packages("ggplot2")
require("ggplot2")
r=select(dados1,GRAVIDEZ2,PARTO)
x=table(ESTCIVMAE)
table(ESCMAE2010,ESTCIVMAE)
RACACORMAE=ordered(RACACORMAE,levels=c("Amarela","Ind�gena","Preta","Branca","Parda"))
barplot(prop.table(table(RACACORMAE)),main="Propor��o de M�es por Ra�a(ou Cor)",col=50)
#bebe
boxplot(PESO~RACACOR2,main="Peso dos Beb�s em Rela��o a Cor(Ou Ra�a)",ylab="Peso em gramas",col=4)
summary(IDADEMAE)
hist(IDADEMAE,breaks=c(17,20,23,26,29,32,35,38,41),col=3,main="Histograma Idade das M�es",ylab="Frequ�ncia",xlab="Idade das M�es")
table(GRAVIDEZ)
summary(SEMAGESTAC)
summary(CONSPRENAT)
hist(PESO)
table(PARTO,TPAPRESENT)
table(PARTO)
pie(prop.table(table(PARTO)),main="Tipos de Partos")

#2
require(DescTools)
#a)
VarTest(SEMAGESTAC~PARTO,alt="two.sided",conf.level=0.95)
t.test(SEMAGESTAC~PARTO,alt="two.sided",conf.level=0.95, var.equal=F)
sd(SEMAGESTAC[PARTO=="Vaginal"])
sd(SEMAGESTAC[PARTO=="Ces�rio"])
#b)
dados1$GRAVIDEZ2=GRAVIDEZ
dados1$GRAVIDEZ2=ifelse(GRAVIDEZ=="�nica",GRAVIDEZ,"Gemelar")
dados1$GRAVIDEZ2=factor(dados1$GRAVIDEZ2,levels=c(1,"Gemelar"),labels=c("�nica","Gemelar"))
attach(dados1)
chisq.test(GRAVIDEZ2,PARTO,correct = T)
barplot(prop.table(table(GRAVIDEZ2)),main="Tipos de Gravidez",ylab="Frequ�ncia",xlab="Tipos",col=mypalette[c(2,6)])
#c)
dados1$IDADECAT=cut(IDADEMAE,breaks=c(17,20,34,40))
attach(dados1)
ee=filter(dados1,PARTO=="Ces�rio")
hist(ee$IDADEMAE,breaks=c(17,20,34,40))
tabela =table(PARTO=="Ces�rio",IDADECAT)
tabela=tabela[2,]
tabela
chisq.test(tabela)
#d)


RACACOR3=as.character(dados1$RACACOR)
RACACOR4=NULL

for(i in 1:length(RACACOR3)){if(RACACOR3[i]!="Branca" && RACACOR3[i]!="Negra"){RACACOR4[i]="Outros"}else{RACACOR4[i]=RACACOR3[i]}}
dados1$RACACOR2=RACACOR4
dados1$RACACOR2=factor(RACACOR4,levels=c("Branca","Negra","Outros"))

LeveneTest(PESO~RACACOR2)
oneway.test(PESO~RACACOR2,dados1,var.equal=T)
x
x=aov(PESO~RACACOR2,dados1)
summary(x)
t=PostHocTest(x,method = "bonferroni",main="Intervalos")
plot(t)
x
summary(dados1)
sd(SEMAGESTAC)
sd(CONSPRENAT)

dados1
table(GRAVIDEZ2,PARTO)
mean(PESO[RACACOR2=="Branca"])
mean(PESO[RACACOR2=="Negra"])
mean(PESO[RACACOR2=="Outros"])
mean(SEMAGESTAC[PARTO=="Vaginal"])
mean(SEMAGESTAC[PARTO=="Ces�rio"])

hist(ee$IDADEMAE,breaks=c(17,20,34,40),xlim=c(15,40),freq=T,plot=T,main="N�mero de Gestantes por Faixa Et�ria", xlab="Idades",ylab="Frequ�ncia",col=c("cadetblue","blue2","blue4"))

barplot(prop.table(table(IDADECAT)))
hist(SEMAGESTAC)
hist(IDADEMAE,breaks=c(17,20,25,29,33,37,40),xlim=c(15,40),freq=T,plot=T,main="N�mero de Gestantes por Faixa Et�ria", xlab="Idades",ylab="Frequ�ncia",col=mypalette[8])
lines(density(IDADEMAE),col="yellow")
barplot(prop.table(table(GRAVIDEZ2)),main="Tipos de Gesta��o",xlab="Tipos",ylab="Frequ�ncia",col=c("Cyan","blue"))      
civ=ESTCIVMAE
civ=ifelse(ESTCIVMAE=="Solteira"|ESTCIVMAE=="Vi�va"|ESTCIVMAE=="Separada judicialmente","Com Companheiro","Sem Companheiro")
civ=as.character(civ)
civ=factor(civ,levels=c("Sem Companheiro","Com Companheiro"),labels=c("Sem Companheiro","Com Companheiro"))

barplot(prop.table(table(civ)),main="Estado Civil das Gestantes",ylim=c(0,0.6),col=c(mypalette[c(4,7)]),ylab = "Frequ�ncias")
summary(civ)
hist(PESO,main="Distribui��o do Peso dos Beb�s",col="blue",ylab="Frequ�ncia",xlab="Peso dos Beb�s")
plot(density(IDADEMAE))
#Teste Anova
curve(density(IDADEMAE),col="yellow")
lines(density(PESO[RACACOR2=="Branca"]),col="blue4")
lines(density(PESO[RACACOR2=="Negra"]),col="cyan")
lines(density(PESO[RACACOR2=="Outros"]),col="cadetblue")
hist(PESO[RACACOR2=="Branca"],main="Distribui��o do Peso dos Beb�s Brancos",col="blue4",ylab="Frequ�ncia",xlab="Peso dos Beb�s")
hist(PESO[RACACOR2=="Negra"],main="Distribui��o do Peso dos Beb�s Negros",col="cyan",ylab="Frequ�ncia",xlab="Peso dos Beb�s")
hist(PESO[RACACOR2=="Outros"],main="Distribui��o do Peso dos Beb�s Amarelos,Pardos ou Ind�genas",col="cadetblue",ylab="Frequ�ncia",xlab="Peso dos Beb�s")
par(mfrow=c(1,1))
install.packages("RColorBrewer")
require("RColorBrewer")

t=prop.table(table(civ,ESCMAE2010))
barplot(prop.table(table(civ,ESCMAE2010)),col=c("cyan","blue"))
legend(t,"topleft",legend=c("Sem Companheiro","Com Companheiro"),fill=c("cyan","blue"))
barplot(t, beside=TRUE, col=mypalette[c(2,9)],main="N�mero de Gestantes por Escolaridade e Estado Civil",ylab="Frequ�ncia")
legend(locator(1), xpd=TRUE, ncol=2, legend=c("Sem Companheiro", "Com Companheiro"),
       fill=mypalette[c(2,7)], bty="n")
mypalette<-brewer.pal(9,"Blues")
mypalette
rr=select(dados1,civ,IDADEMAE)

summary(civ)
summary(ESTCIVMAE)
ggplot(rr, aes(x=ESTCIVMAE,y=IDADEMAE,fill=)) + 
  geom_boxplot()+scale_fill_manual(values=c(mypalette[c(4,7)]))+ggtitle("Tipos de Partos em rela��o a Idade das Gestantes")+xlab("Tipos de Parto")+ylab("Idade")
tt=select(dados1,RACACOR2,PESO)
ggplot(tt, aes(x=RACACOR2,y=PESO,fill=RACACOR2)) + 
  geom_boxplot()+scale_fill_manual(values=c(mypalette[c(1,6,7)]))+ggtitle("Tipos de Partos em rela��o a Idade das Gestantes")+xlab("Parto")+ylab("Idade")
summary(dados1)
t=prop.table(table(PARIDADE,KOTELCHUCK))
barplot(t, beside=TRUE, col=mypalette[c(1,6)],main="Rela��o de Paridade e �ndice de Kotelchuck",xlab="�ndice de Kotelchuck",ylab="Frequ�ncia")
legend(locator(1), xpd=TRUE, ncol=2, legend=c("1�Gesta��o","N�o � 1�Gesta��o"),
       fill=mypalette[c(1,6)], bty="n")
tab=prop.table(table(PARIDADE,KOTELCHUCK=="Inadequado"))
barplot(tab[,2])
summary(civ)
sd(PESO)
pie(prop.table(table(SEXO)))
o=prop.table(table(civ,ESCMAE2010))
barplot(o,beside=T, col=mypalette[c(4,9)],main="N�mero de Gestantes por Escolaridade e Estado Civil",ylab="Frequ�ncia",xlab="Escolaridade")
legend(locator(1), xpd=TRUE, ncol=2, legend=c("Sem companheiro","Com companheiro"),
       fill=mypalette[c(4,9)], bty="n")
summary(SEXO)
table(PARTO,TPAPRESENT)
d=ifelse(RACACOR==RACACORMAE,1,0)
summary(dados1)
levels(RACACORMAE)
