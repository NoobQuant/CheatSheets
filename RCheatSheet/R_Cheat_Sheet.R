

#####################################################
#     R CHEAT SHEET
#####################################################


#####################################################
# Housekeeping
#####################################################

# Clear variable space
rm(list=ls(all=TRUE)) 

# Clear console
clc <- function() cat(rep("\n",100))
clc()

# Set as working directory the folder where the script is 
# being run from
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)




#####################################################
# Operations on data frames
#####################################################

# Melt data frame from matrix to long
########################

library(reshape2)
df = as.data.frame(
      cbind(
            c(4,9,6)
           ,c(8,4,2)
           ,c(9,7,5)           
            ))
colnames(df) = c('Name1','Name2','Name3') 
rownames(df) = c('Name1','Name2','Name3') 

df
df = as.data.frame(melt(as.matrix(df)))
df















