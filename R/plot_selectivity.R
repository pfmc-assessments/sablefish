#' Plot selectivity for all fleets/surveys in one figure
#' @param model Model object created by [r4ss::SS_output()].
#' @param width Width of the plot in inches.
#' @param height Height of the plot in inches.
plot_selex <- function(model, width = 7, height = 10) {
  # 1997 2002 2003 2010 2011 2022 fixed gear
  # 1982 2002 2003 2010 2011 2022 trawl
  lens <- seq(0, tail(colnames(model[["ageselex"]]), 1))
  ret <- model[["ageselex"]]
  ret <- ret[ret[["Factor"]] == "Asel", ]
  col.vec <- viridis::viridis(model[["nfleets"]] - 1)

  dir_plots <- fs::path(model[["inputs"]][["dir"]], "plots")
  fs::dir_create(dir_plots)
  png(
    filename = fs::path(dir_plots, "selectivity.png"),
    width = width,
    height = height,
    units = "in",
    res = 300,
    pointsize = 12
  )
  on.exit(dev.off(), add = TRUE)
  par(
    mfrow = c(3, 2),
    mar = c(3, 2, 1, 1) + 0.1,
    oma = c(0.5, 1.9, 0, 0),
    xpd = TRUE
  )
  plot(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1996,  8:ncol(ret)],
    col = col.vec[1],
    type = "l", 
    ylim = c(0, 1.05),
    ylab = "Selectivity",
    xlab = "Age (yr)",
    main = recode_fleet_figure(1),
    lwd = 2
  )
  # Females
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 1996,  8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2002,  8:ncol(ret)],
    col = col.vec[2],
    lty = 1, lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2002,  8:ncol(ret)],
    col = col.vec[2],
    pch = 2
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2010,  8:ncol(ret)],
    col = col.vec[3],
    lty = 1, lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2010,  8:ncol(ret)],
    col = col.vec[3],
    pch = 3
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)],
    col = col.vec[4],
    lty = 1, lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)],
    col = col.vec[4],
    pch = 4
  )
  #Males
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 1996,  8:ncol(ret)],
    lty = 2, col =
    col.vec[1], lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 1996,  8:ncol(ret)],
    lty = 2, col =
    col.vec[1], pch = 1
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2002,  8:ncol(ret)],
    lty = 2, col =
    col.vec[2], lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2002,  8:ncol(ret)],
    lty = 2, col =
    col.vec[2], pch = 2
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2010,  8:ncol(ret)],
    lty = 2, col =
    col.vec[3], lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2010,  8:ncol(ret)],
    lty = 2, col =
    col.vec[3], pch = 3
  )
  lines(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2022,  8:ncol(ret)],
    lty = 2, col =
    col.vec[4], lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 1 & ret$Sex == 2 & ret$Yr == 2022,  8:ncol(ret)],
    lty = 2, col =
    col.vec[4], pch = 4
  )
  legend(
    "topright",
    legend = c("1892-1996", "1997-2002", "2003-2010", "2011-2022"),
    col = col.vec[1:4],
    pch = 1:4,
    lty = 1,
    lwd = 2,
    bty = "n",
    cex = 1.5
  )
  legend(
    "right",
    legend = c("Females", "Males"),
    col = col.vec[1],
    lty = c(1, 2),
    lwd = 2,
    bty = "n",
    cex = 1.5
  )

  plot(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1981,  8:ncol(ret)],
    col = col.vec[1],
    type = "l",
    ylim = c(0, 1.05),
    ylab = "",
    xlab = "Age (yr)",
    main = recode_fleet_figure(2),
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1981, 8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )
  lines(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982, 8:ncol(ret)],
    col = col.vec[2],
    lty = 1,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 1982, 8:ncol(ret)],
    col = col.vec[2],
    pch = 2
  )
  lines(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2003, 8:ncol(ret)],
    col = col.vec[3],
    lty = 1,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2003, 8:ncol(ret)],
    col = col.vec[3],
    pch = 3
  )
  lines(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[4],
    lty = 1,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 2 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[4],
    pch = 4
  )
  legend(
    "topright",
    legend = c("1892-1981", "1982-2002", "2003-2010", "2011-2022"),
    col = col.vec[1:4],
    pch = 1:4,
    lty = 1,
    lwd = 2,
    bty = "n",
    cex = 1.5
  )

  plot(
    lens, ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1994, 8:ncol(ret)],
    col = col.vec[1],
    type = "l",
    ylim = c(0, 1.05),
    ylab = "",
    xlab = "",
    main = recode_fleet_figure(4),
    lwd = 2,
    xpd = NA
  )
  title(ylab = "Selectivity", mgp = c(1.9, 1, 0), xpd = NA)
  points(lens,
    ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1994, 8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )
  lines(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1995, 8:ncol(ret)],
    col = col.vec[2],
    lty = 1,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 1 & ret$Yr == 1995, 8:ncol(ret)],
    col = col.vec[2],
    pch = 2
  )
  lines(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1994, 8:ncol(ret)],
    col = col.vec[1],
    lty = 2,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1994, 8:ncol(ret)],
    col = col.vec[1],
    pch = 2
  )
  lines(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1995, 8:ncol(ret)],
    col = col.vec[2],
    lty = 2,
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 4 & ret$Sex == 2 & ret$Yr == 1995, 8:ncol(ret)],
    col = col.vec[2],
    pch = 2
  )
  legend(
    "right",
    legend = c("Females", "Males"),
    col = col.vec[1],
    lty = c(1, 2),
    lwd = 2,
    bty = "n",
    cex = 1.5
  )
  legend(
    "topright",
    legend = c("1980-1994", "1995-2004"),
    col = col.vec[1:2],
    pch = 1:2,
    lty = 1,
    lwd = 2,
    bty = "n",
    cex = 1.5
  )

  plot(
    lens,
    ret[ret$Fleet == 5 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[1],
    type = "l",
    ylim = c(0, 1.05),
    ylab = "",
    xlab = "Age (yr)",
    main = recode_fleet_figure(5),
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 5 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )

  plot(
    lens,
    ret[ret$Fleet == 6 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[1],
    type = "l",
    ylim = c(0, 1.05),
    ylab = "Selectivity",
    xlab = "Age (yr)",
    main = recode_fleet_figure(6),
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 6 & ret$Sex == 1 & ret$Yr == 2022, 8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )
  title(xlab = "Age (years)", mgp = c(1.9, 1, 0), xpd = NA)

  plot(
    lens,
    ret[ret$Fleet == 7 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)],
    col = col.vec[1],
    type = "l",
    ylim = c(0, 1.05),
    ylab = "",
    xlab = "Age (yr)",
    main = recode_fleet_figure(7),
    lwd = 2
  )
  points(
    lens,
    ret[ret$Fleet == 7 & ret$Sex == 1 & ret$Yr == 2022,  8:ncol(ret)],
    col = col.vec[1],
    pch = 1
  )
  title(xlab = "Age (years)", mgp = c(1.9, 1, 0), xpd = NA)
}
