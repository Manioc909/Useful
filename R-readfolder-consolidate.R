# Read all files and combine into a single output

rm(list=ls())

setwd("")

library(readxl)
library(plyr)
library(sqldf)

# List of files
input<-as.vector(rbind(list.files(all.files = F, full.names= F)))

# Create reference table
conversion.table<- matrix(ncol = 2, nrow = length(input))
colnames(conversion.table)<-c('input','output')

i<-1

# Populate the reference table, not used in this process to the full extent as the output tables 
#   are appended to each other. However, if wanted to be different with a rename this is the mapping.
for ( i in 1:length(input)) {
  conversion.table[i,1]<-input[i]
  conversion.table[i,2]<-substr(conversion.table[i,1],start = 30, nchar(conversion.table[i,1]))
  conversion.table[i,2]<-substr(conversion.table[i,2],start = 1, stop = regexpr(' ', conversion.table[i,2]))
}

# Set up loop
i<-1
audit.result<-data.frame()

# Read in each audit report and append to the result
for (i in 1:length(input)) {
  audit.current<-read_xlsx(paste(conversion.table[i,1]), sheet = 'Primary', col_names = T, guess_max = 1000, na="")
  audit.result<-rbind.fill(audit.result, audit.current)
}

# Output the audit result.
write.csv(audit.result, file="")

