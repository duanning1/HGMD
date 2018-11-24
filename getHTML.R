library(xml2)
library(rvest)
library(magrittr)
library(stringr)
setwd("~/Desktop/Stat 302")
## crawl every webpage to get text information
genelist <- read_html('CM110959.html')
position1<-genelist %>% html_nodes("tr[class=odd]") %>% html_nodes("td") %>% html_text()
position1
temp1 <- c("HGMD accession","Reported disease/phenotype",
           "Variant class","Gene symbol","Codon change",
           "Amino acid change","Codon number")
temp2 <- c("Literature citation","Citation type","Support BETA","Comments/notes")
info1<-str_c(temp1,":",position1[1:7])
as.character(info1)
body > div.content > table:nth-child(3) > tbody > tr:nth-child(3) > td:nth-child(1)
body > div.content > table:nth-child(2) > tbody > tr:nth-child(2) > td:nth-child(1)
<td class="center">CM1510388</td>
  /html/body/div[3]/table[2]/tbody/tr[2]/td[1]
## info3<-str_c(position1[seq(14,33,by=2)],":",position1[seq(15,33,by=2)])
## summary<- c(info1,"###",info2,"###",info3,"###",info4)
## abc<-write.table(summary,file="abc",col.names = F,row.names = F)
## refcore<-geneweb %>% html_nodes("input[name=refcore]")%>% extract2(1)%>% html_attr("value")
## gene_id<-geneweb %>% html_nodes("input[name=gene_id]")%>% html_attr("value")
## position<-web %>% html_nodes("form") %>% html_nodes("input[name=acc]")%>% html_attr("value")
