#' @param model Model object created by r4ss::SS_output
#' @param width Width of the plot in inches
#' @param height Height of the plot in inches
plot_selex <- function(model, width = 7, height = 10) {
  # 1997 2002 2003 2010 2011 2022 fixed gear 
  # 1982 2002 2003 2010 2011 2022 trawl
  lens = 0:70
  ret = model$ageselex
  ret = ret[ret$Factor == "Asel", ]
  col.vec = viridis::viridis(6)
  
  fs::dir_create(fs::path(model[["inputs"]][["dir"]], "plots"))
  png(filename = fs::path(model[["inputs"]][["dir"]], "plots", "selectivity.png"), 
      width = width, 
      height = height, 
      units = 'in', res = 300, pointsize = 12)
  par(mfrow = c(3,2))
  plot(  lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1996,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "Fixed Gear", lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1996,  8:ncol(ret)], col = col.vec[1], pch = 1)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2002,  8:ncol(ret)], col = col.vec[2], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2002,  8:ncol(ret)], col = col.vec[2], pch = 2)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2010,  8:ncol(ret)], col = col.vec[3], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2010,  8:ncol(ret)], col = col.vec[3], pch = 3)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[4], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[4], pch = 4)
  #Males
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 1996,  8:ncol(ret)], lty = 2, col = col.vec[1], lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 1996,  8:ncol(ret)], lty = 2, col = col.vec[1], pch = 1)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2002,  8:ncol(ret)], lty = 2, col = col.vec[2], lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2002,  8:ncol(ret)], lty = 2, col = col.vec[2], pch = 2)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2010,  8:ncol(ret)], lty = 2, col = col.vec[3], lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2010,  8:ncol(ret)], lty = 2, col = col.vec[3], pch = 3)
  lines( lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2022,  8:ncol(ret)], lty = 2, col = col.vec[4], lwd = 2)
  points(lens, ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2022,  8:ncol(ret)], lty = 2, col = col.vec[4], pch = 4)
  legend ("topright", legend = c("1892-1996", "1997-2002", "2003-2010", "2011-2022"),
          col = col.vec[1:4], pch = 1:4,lty = 1, lwd = 2, bty = 'n', cex = 1.5)
  legend ("right", legend = c("Females", "Males"),
          col = col.vec[1], lty = c(1, 2), lwd = 2, bty = 'n', cex = 1.5)
  
  plot(  lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1981,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "Trawl", lwd = 2)
  points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1981,  8:ncol(ret)], col = col.vec[1], pch = 1)
  lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982,  8:ncol(ret)], col = col.vec[2], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982,  8:ncol(ret)], col = col.vec[2], pch = 2)
  lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2003,  8:ncol(ret)], col = col.vec[3], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2003,  8:ncol(ret)], col = col.vec[3], pch = 3)
  lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[4], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[4], pch = 4)
  legend ("topright", legend = c("1892-1981", "1982-2002", "2003-2010", "2011-2022"),
          col = col.vec[1:4], pch = 1:4,lty = 1, lwd = 2, bty = 'n', cex = 1.5)
  
  plot(  lens, ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1994,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "NWFSC/AFSC Triennial", lwd = 2)
  points(lens, ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1994,  8:ncol(ret)], col = col.vec[1], pch = 1)
  lines( lens, ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1995,  8:ncol(ret)], col = col.vec[2], lty = 1, lwd = 2)
  points(lens, ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1995,  8:ncol(ret)], col = col.vec[2], pch = 2)  
  lines( lens, ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1994,  8:ncol(ret)], col = col.vec[1], lty = 2, lwd = 2)
  points(lens, ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1994,  8:ncol(ret)], col = col.vec[1], pch = 2)
  lines( lens, ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1995,  8:ncol(ret)], col = col.vec[2], lty = 2, lwd = 2)
  points(lens, ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1995,  8:ncol(ret)], col = col.vec[2], pch = 2)
  legend ("right", legend = c("Females", "Males"),
          col = col.vec[1], lty = c(1, 2), lwd = 2, bty = 'n', cex = 1.5)
  legend ("topright", legend = c("1980-1994", "1995-2004"),
          col = col.vec[1:2], pch = 1:2,lty = 1, lwd = 2, bty = 'n', cex = 1.5)
  
  plot(  lens, ret[ret$Fleet == 5 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "AFSC Slope", lwd = 2)
  points(lens, ret[ret$Fleet == 5 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], pch = 1)
  
  plot(  lens, ret[ret$Fleet == 6 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "NWFSC Slope", lwd = 2)
  points(lens, ret[ret$Fleet == 6 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], pch = 1)
  
  plot(  lens, ret[ret$Fleet == 7 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], type = 'l', 
         ylim = c(0, 1.05), ylab = "Selectivity", xlab = "Age (yr)", main = "NWFSC WCGBT", lwd = 2)
  points(lens, ret[ret$Fleet == 7 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)], col = col.vec[1], pch = 1)
  
  
  dev.off()
}