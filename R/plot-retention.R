#' @param model Model object created by r4ss::SS_output
#' @param width Width of the plot in inches
#' @param height Height of the plot in inches
plot_retention <- function(model, width = 7, height = 10) {

lens = 4.5:90.5
ret = model$sizeselex[model$sizeselex$Fleet %in% c(1,2), ]
ret = ret[ret$Factor == "Ret", ]
col.vec = viridis::viridis(6)

png(filename = fs::path(here::here(),figure_dir, "retention.png"), 
    width = width, 
    height = height, 
    units = 'in', res = 300, pointsize = 12)
par(mfrow = c(2,1))
plot(  lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1941,  6:ncol(ret)], col = col.vec[1], type = 'l', 
       ylim = c(0, 1.05), ylab = "Retention", xlab = "Length (cm)", main = "Fixed Gear", lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1941,  6:ncol(ret)], col = col.vec[1], pch = 1)
lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1942,  6:ncol(ret)], col = col.vec[2], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1942,  6:ncol(ret)], col = col.vec[2], pch = 2)
lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1947,  6:ncol(ret)], col = col.vec[3], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1947,  6:ncol(ret)], col = col.vec[3], pch = 3)
lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1997,  6:ncol(ret)], col = col.vec[4], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1997,  6:ncol(ret)], col = col.vec[4], pch = 4)
lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2011,  6:ncol(ret)], col = col.vec[5], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2011,  6:ncol(ret)], col = col.vec[5], pch = 5)
lines( lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2019,  6:ncol(ret)], col = col.vec[6], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2019,  6:ncol(ret)], col = col.vec[6], pch = 6)
legend ("bottomright", legend = c("1892-1941", "1942-1946", "1947-1996", "1997-2010", "2011-2018", "2019-2022"),
        col = col.vec[1:6], pch = 1:6,lty = 1, lwd = 2, bty = 'n', cex = 1.5)

plot(  lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1941,  6:ncol(ret)], col = col.vec[1], type = 'l', 
       ylim = c(0, 1.05), ylab = "Retention", xlab = "Length (cm)", main = "Trawl", lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1941,  6:ncol(ret)], col = col.vec[1], pch = 1)
lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1942,  6:ncol(ret)], col = col.vec[2], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1942,  6:ncol(ret)], col = col.vec[2], pch = 2)
lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1947,  6:ncol(ret)], col = col.vec[3], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1947,  6:ncol(ret)], col = col.vec[3], pch = 3)
lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982,  6:ncol(ret)], col = col.vec[4], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982,  6:ncol(ret)], col = col.vec[4], pch = 4)
lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2011,  6:ncol(ret)], col = col.vec[5], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2011,  6:ncol(ret)], col = col.vec[5], pch = 5)
lines( lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2019,  6:ncol(ret)], col = col.vec[6], lty = 1, lwd = 2)
points(lens, ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2019,  6:ncol(ret)], col = col.vec[6], pch = 6)
legend ("bottomright", legend = c("1892-1941", "1942-1946", "1947-1981", "1982-2010", "2011-2018", "2019-2022"),
        col = col.vec[1:6], pch = 1:6,lty = 1, lwd = 2, bty = 'n', cex = 1.5)
dev.off()
}