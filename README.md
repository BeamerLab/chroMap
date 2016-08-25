# chroMap
[![DOI](https://zenodo.org/badge/24072/BeamerLab/chroMap.svg)](https://zenodo.org/badge/latestdoi/24072/BeamerLab/chroMap)

R Package that maps a matrix of data, with associated tissue names, to a human anatomical model using colors - effectively an anatomical heatmap.

Please  use the above DOI to reference our work in any publication, poster, or other work. For support or to request features please email kmskvf@mail.missouri.edu.

chroMap expects a dataframe (n columns, m rows) matched with tissue-specific data, you can input a single column or multiple - _especially useful when comparing levels of homologous proteins_ -. Here's an example: 

Tissue | Protein_1 | Protein 2 
-------|-----------|-----------
Heart | 13 | 37 
Lungs | 4  | 20 
Brain | 6  | 1 


And here is an example output using 5 different proteins
![Example ChroMap](https://github.com/BeamerLab/chroMap/blob/master/example_output.PNG)

- [x] Implement scaling options similar to heatmaps (row, column, z-scale)
- [ ] Create full R package for installation through developer tools in R studio
- [ ] Create difference chroMap vignette
- [ ] Implement on shiny webserver https://beamerlab.shinyapps.io/software/
