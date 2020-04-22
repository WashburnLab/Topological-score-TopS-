#author: Mihaela E. Sardiu and Michael P. Washburn
#Stowers Institute for Medical Research 
#2-1-2018

library(shiny)
#library(UsingR)
library(gplots)
library(stats)
library(gridExtra)


######################################### Create topological scores ####################
#File name can be change here: 
y<-read.csv("input_file.csv")
#y<-read.csv("DNArepair.csv")
#y<-read.csv("yeast_data.csv")
x<-data.frame((y[, 2:ncol(y)]))
r<-as.matrix(y[1])
z<-length(x);
#rownames(x)=1:nrow(x)
#q<-as.vector(rownames(x))
#print(q);
sink("output_file.txt")
#print(x[[0]]); #columns
m=0;
for (i in 1:z)
{
  m= m+sum(x[[i]]);  
}
#print(m); #total number of spectra in the table  

nr <- nrow(((y[, 2:ncol(y)])));
#print(nr); #number of columns
#output$oid3 <- renderPrint({nr})


#print(sum(x[5,])); #print the sum of the spectra in row5
#print(x[[1]][[2]]); # print the spectral count in column 1 and row2

#cat("\t")
#n<-names(x)
#cat(names(x),sep="\t")
#cat("\n")

cat("ROW_NAMES")
cat("\t")
for(j in 1:z)#number of col
{
  cat(colnames(x)[j])
  cat("\t")
}
cat("\n")

for(i in 1:nr) #number of prot 
{
 cat(r[i]) 
 cat("\t");
  for(j in 1:z)#number of col
  {
    
    t=sum(x[i,]); #sum over the rows
    q=sum(x[[j]]); #sum over the columns
    if(t==0 || q==0 || x[[j]][[i]]==0){score=0}
    else{
    score=x[[j]][[i]]*log((x[[j]][[i]])/((t*q)/m));}
    cat(score,sep=" ");
    cat("\t");
  }
  cat("\n");
  #print(score2)
}
sink()
#exit()

######################################### shiny server ###########################

shinyServer(function(input, output) {
  
  output$view <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    y<-read.csv(inFile$datapath,header=input$header, sep=input$sep, quote=input$quote)
    x<-data.frame((y[, 2:ncol(y)]))
    head(x)
    
  })
  
  
  output$view1 <- renderTable({
    inFile <- input$file2
    if (is.null(inFile))
      return(NULL) 
    y<- read.table(inFile$datapath,header=input$header)
    x<-data.frame((y[, 2:ncol(y)]))
    head(x)
    
  }) 
   
  output$newHist <- renderPlot({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    y<-read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    x<-data.frame((y[, 2:ncol(y)]))
    p<-x[[ncol(x)]]+0.00001
    col_n<-log2(p)
    hist(col_n, col = 'red', border = 'black')
    mu<-colMeans(x,na.rm = FALSE, dims = 1)
    s<-apply(x, 2, sd)
    output$oid1 <- renderPrint({"Mean:"})
    output$oid2 <- renderPrint({mu})
    output$oid3 <- renderPrint({"Standard deviation:"})
    output$oid4 <- renderPrint({s})
  }) 
  
  output$plot1 <- renderPlot({
    my_palette <- colorRampPalette(c("black", "grey"))(n = 299)
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    y<-read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    d<-cor(y[,2:ncol(y)])
    output$oid5 <- renderPrint({"Heatmap of correlations between baits using spectral counts:"})
    heatmap.2(d,dendrogram='none', margins=c(8,16),Rowv=FALSE, Colv=FALSE,trace='none',col=my_palette)
    dev.off()
    pdf("plot_heatmap.pdf")
    heatmap.2(d,dendrogram='none', margins=c(8,16),Rowv=FALSE, Colv=FALSE,trace='none',col=my_palette)
    #dev.off()
  })
  
  output$plot2 <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    y<-read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    x<-data.frame((y[, 2:ncol(y)]))
    trmtx <- t(x)
    d1<-dist(trmtx)
    output$oid6 <- renderPrint({"Hierarchical clustering using spectral counting:"})
    hc<-hclust(d1,method="ward.D",members=NULL)
    plot(hc)
    dev.off()
    pdf("plot_spectral_counts.pdf")
    plot(hc)
    #dev.off()
  })
  
  output$plot3 <- renderPlot({
    inFile <- input$file2
    
    if (is.null(inFile))
      return(NULL)
    y<-read.table(inFile$datapath, header=input$header)
    x<-data.frame((y[, 2:ncol(y)]))
    trmtx <- t(x)
    d1<-dist(trmtx)
    output$oid7 <- renderPrint({"Hierarchical clustering using topological scores:"})
    hc<-hclust(d1,method="ward.D",members=NULL)
    plot(hc)
    dev.off()
    #pdf("plot1.pdf", width=as.numeric(input$w), height=as.numeric(input$h))
    pdf("plot_TopS.pdf")
    plot(hc)
    #dev.off()
    
    
  })
             
})


