human_chloropleth <- function(tissue_df, difference=FALSE, col, scaling="none", clustering = NA){
  #waterworld <- colorRampPalette(c("lightblue", "gold", "darkorange"))
  require(NMF)
  KevinCostner <- colorRamp(c(col), bias = 1, space = "rgb", interpolate = "linear")
  body_parts <- c("bladder", "brain", "gallbladder", "heart", 'kidney', 'liver', 'lung', 'pancreas', 'skin', 'small intestine', 'spleen', 'stomach', 'skeletal muscle', 'bone marrow')
  row_names <- row.names(tissue_df)
  matched_tissues <- which(tolower(row_names) %in% body_parts)
  matched_names <- intersect(tolower(row_names), body_parts)
  matched_df <- data.frame(tissue_df[matched_tissues,], row.names = matched_names)

  if (difference==TRUE){
    if (ncol(matched_df) <= 1){
      stop('Difference cannot be taken with one column')
    }
    for (j in 2:ncol(matched_df)){
      for (i in 1:nrow(matched_df)){
        matched_df[i,j-1] <- matched_df[i,1]-matched_df[i,j]
      }
    }
    matched_df <- matched_df[-c(ncol(matched_df))]
    colnames(matched_df) <- colnames(tissue_df[,2:ncol(tissue_df)])
  }
  
  if ((ncol(matched_df) == 1) & (identical(scaling,'row') | identical(scaling,'r1') == TRUE)){
      stop('scaling by row or r1 is not possible with one column')
  } else if ((nrow(matched_df) == 1) & (identical(scaling,'column') | identical(scaling,'c1') == TRUE)){
      stop('scaling by column or c1 is not possible with one row')
  }  else if (length(matched_names) == 0){
      stop('No tissues in the dataframe match tissues on the diagram')
  } else
      aheatmap(matched_df, Rowv = clustering, Colv = clustering, color = col, scale = scaling)
  
  for (j in 1:ncol(matched_df)){
    filled_body_xml <- xmlParse("filled_body.ps.xml")
    for (i in 1:nrow(matched_df)){
      #color <- waterworld(range(matched_df[,j])[2])[ceiling(matched_df[i,j])]
      #rgbcolor <- col2rgb(color)
      if (scaling == "column"){
        if (nrow(matched_df) <= 1){
          stop('Cannot perform this scaling with one row')
        }  
        matched_df[,j] <- scale(matched_df[,j])
        if (min(matched_df[,j]) >= 0){
          rgbcolor <- KevinCostner(matched_df[i,j]/max(matched_df[,j]))
        }
        else {
          minimum <- min(matched_df[,j])
          interval <- range(matched_df[,j])[2] - range(matched_df[,j])[1]+1
          rgbcolor <- KevinCostner((matched_df[i,j]+abs(minimum))/interval)
        }
      }
      
      if (scaling == "row"){
        if (ncol(matched_df) <= 1){
          stop('Cannot perform this scaling with one column')
        }
        matched_df[i,] <- t(scale(t(matched_df[i,])))
        #if (min(matched_df[i,]) >= 0){
         # rgbcolor <- KevinCostner(matched_df[i,j]/max(matched_df[i,]))
        #}
        #else {
          minimum <- min(matched_df[i,])
          interval <- range(matched_df[i,])[2] - range(matched_df[i,])[1]+1
          rgbcolor <- KevinCostner((matched_df[i,j]+abs(minimum))/interval)
        #}
      }
      
      if (scaling == "r1"){
        if (ncol(matched_df) <= 1){
          stop('Cannot perform this scaling with one column')
        }
        rgbcolor <- KevinCostner(abs(matched_df[i,j])/(rowSums(abs(matched_df[i,]))))
      }
      
      if (scaling == "c1"){
        if (nrow(matched_df) <= 1){
          stop('Cannot perform this scaling with one row')
        }
        rgbcolor <- KevinCostner(abs(matched_df[i,j])/(sum(abs(matched_df[,j]))))
      }
      
      if (scaling == "none"){
        rgbcolor <- KevinCostner((matched_df[i,j]-min(matched_df))/(max(matched_df)-min(matched_df)))
      }
      
      xpathApply(filled_body_xml, paste("//path[@id='",row.names(matched_df)[i],"']/context/rgb", sep=''), 'xmlAttrs<-', value= c(r=rgbcolor[1]/255, g=rgbcolor[2]/255, b=rgbcolor[3]/255))
    }
    frame()
    chloropleth <- readPicture(saveXML(filled_body_xml))
    grid.picture(chloropleth)
    grid.picture(readPicture("labels.ps.xml"))
  }
  return(matched_df)
}