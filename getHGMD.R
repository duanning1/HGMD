library(RCurl)
library(xml2)
library(rvest)
library(magrittr)
library(stringr)
myHttpheader<- c(
  "User-Agent"="Mozilla/5.0(Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6)",
  "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
  "Accept-Language"="en-us",
  "Connection"="keep-alive",
  "Accept-Charset"="GB2312,utf-8;q=0.7,*;q=0.7",
  "Referer"="https://portal.biobase-international.com/cgi-bin/portal/login.cgi"
)
temp<- getURL("https://portal.biobase-international.com/cgi-bin/portal/login.cgi",httpheader=myHttpheader)
d =debugGatherer()
temp<- getURL("https://portal.biobase-international.com/cgi-bin/portal/login.cgi",httpheader=myHttpheader,
              debugfunction=d$update,verbose= TRUE)
cat(d$value()[3])
cat(d$value()[2])
cHandle<- getCurlHandle(httpheader = myHttpheader)
d =debugGatherer()
temp <- getURL("https://portal.biobase-international.com/cgi-bin/portal/login.cgi", .opts = list(debugfunction=d$update,verbose = TRUE), curl=cHandle)

## direct login
params <- list(login='swgenetics',
               password='SWgenetics@)!&',
               signin='Sign in')
temp<- postForm("https://portal.biobase-international.com/cgi-bin/portal/login.cgi",.params=params,
                .opts=list(cookiefile=""),curl=cHandle,style="post")
cat(d$value()[2])
getCurlInfo(cHandle)[["cookielist"]]

## test
temp2 <- getURL("https://portal.biobase-international.com/hgmd/pro/search_gene.php",
                curl=cHandle,.encoding="gbk")



## function: search name

## example: GJB2
## setwd to same directory!!!
setwd("~/Desktop/Stat 302")
genelist <- read.csv(file = "HGMDgenelist.csv", header=T,sep=",")$Gene_Symbol
entry<-as.character(genelist)
temp3<-"https://portal.biobase-international.com/hgmd/pro/gene.php?gene="
temp5<-"https://portal.biobase-international.com/hgmd/pro/mut.php?acc="

## for loop!!!
for (i in 1:length(entry)){
temp4<-str_c(temp3,entry[i])
getGene <- getURL(temp4,curl=cHandle,.encoding="gbk")
## get parameters refcore & gene_id
geneweb<-read_html(getGene)
refcore<-geneweb %>% html_nodes("input[name=refcore]")%>% extract2(1)%>% html_attr("value")
gene_id<-geneweb %>% html_nodes("input[name=gene_id]")%>% html_attr("value")

## post function to get one page
## see Chrome-Inspect-Form data
params <- list('gene'=entry[i],
               'inclsnp'='N',
               'base'='Z',
               'refcore'=refcore,
               'sort'='location',
               'gene_id'=gene_id,
               'database'='Get all mutations')
## params
getList<- postForm("https://portal.biobase-international.com/hgmd/pro/all.php",.params=params,
                .opts=list(cookiefile=""),curl=cHandle,style="post")
## crawl getList to get HGMD accessions list of GJB2
web<-read_html(getList)
position<-web %>% html_nodes("form") %>% html_nodes("input[name=acc]")%>% html_attr("value")
## save as .csv??
## position
write.table(toString(position),file = "HGMDaccession",append = T,col.names = F,row.names = entry[i])

            ## traverse all webpage ending with list items in random time interval
            for (i in 1:length(position)){
            url<-str_c(temp5,position[i])
            getInfo <- getURL(url,curl=cHandle,.encoding="gbk")
            ## save as txt
            write.table(getInfo,file = position[i],col.names = F,row.names = F)
            Sys.sleep(runif(1,0,6))
            }
}





## crawl every webpage to get VCF
## web2<-read_html(getInfo)
## ...
                                                          