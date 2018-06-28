################################################
#
#writeMatrixXLConnect.R
#
#Writes a matrix to an Excel sheet using XLConnect
#
#INPUTS: - data: data as data frame - title: title for the data frame - wb:
#openxls workbook object specifying target workbook - sheetname: target sheet
#name - startingrow: number of the starting row - startingcol: number of the
#starting column
#
#OUTPUTS: - a matrix written in the specified Excel sheet
#
#SOURCES: http://www.milanor.net/blog/steps-connect-r-excel-xlconnect/
#
################################################

writeMatrixXLConnect <- function(data,title,wb,sheetname,startingrow,startingcol,
                                 writeRowNames = F) {
   
   # Modify row names into data frame if so desiced
   if (writeRowNames == T){
      rownames = rownames(data)
      data = cbind(rownames,data)
      colnames(data)[1] = ""
   }
   
   # Write data
   writeWorksheet(wb, data, sheet = sheetname, startRow = startingrow+1,
                  startCol = startingcol)
   
   # Write title
   writeWorksheet(wb, title, sheet = sheetname, startRow = startingrow,
				  startCol = startingcol,header = FALSE)
   
   #Set column widths   
   #setColumnWidth(wb,sheetname,startingcol:(startingcol+ncol(data)-1),width=-1)   

   # Create title cell style
   titleStyle = createCellStyle(wb)
   setFillForegroundColor(titleStyle, color = XLC$"COLOR.GOLD")
   setFillPattern(titleStyle, fill = XLC$"FILL.SOLID_FOREGROUND")
   
    # Apply title style
	#setCellStyle(wb, sheet = sheetname, row = startingrow, 
	#			 col = startingcol, cellstyle = titleStyle)  
   
   #Create styles to shade alternate rows
   lightStyle = createCellStyle(wb)
   setFillForegroundColor(lightStyle, XLC$"COLOR.GREY_25_PERCENT")
   setFillPattern(lightStyle, fill = XLC$"FILL.SOLID_FOREGROUND")   
   
   darkStyle = createCellStyle(wb)
   setFillForegroundColor(darkStyle, color = XLC$"COLOR.GREY_50_PERCENT")
   setFillPattern(darkStyle, fill = XLC$"FILL.SOLID_FOREGROUND")      
   
   # Rows to be colored
   colorRows <- startingrow+1:(nrow(data))+1
   
   # Apply light row shades
   rc = expand.grid(row = colorRows[which(colorRows %% 2 == 0)], col = startingcol:(startingcol+ncol(data)-1))   
   setCellStyle(wb, sheet = sheetname, row = rc$row, col = rc$col, cellstyle = lightStyle)
   
   # Apply dark row shades   
   rc = expand.grid(row = colorRows[which(colorRows %% 2 == 1)], col = startingcol:(startingcol+ncol(data)-1))   
   setCellStyle(wb, sheet = sheetname, row = rc$row, col = rc$col, cellstyle = darkStyle)
   
  
   # Create header cell style
   headerStyle = createCellStyle(wb)
   setFillForegroundColor(headerStyle, color = XLC$"COLOR.CORNFLOWER_BLUE")
   setFillPattern(headerStyle, fill = XLC$"FILL.SOLID_FOREGROUND")
   
   # Apply header style column names
   rc = expand.grid(row = startingrow+1, col = startingcol:(startingcol+ncol(data)-1))
   setCellStyle(wb, sheet = sheetname, row = rc$row, 
                col = rc$col, cellstyle = headerStyle) 
   
   if (writeRowNames == T){
      # Apply header style to row names   
      rc = expand.grid(row = (startingrow+1):(startingrow+1+dim(data)[1]), col = startingcol)
      setCellStyle(wb, sheet = sheetname, row = rc$row, 
                   col = rc$col, cellstyle = headerStyle)  
   }

   
}