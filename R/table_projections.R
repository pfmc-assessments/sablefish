table_projection<- function(model_location, model){

# Yes I know this code will likely make your eye twitch... sorry
tab <- cbind(utils::read.csv(here::here("data-processed", "harvest_spex.csv")) |>
               dplyr::filter(AREA_NAME == "CW" & YEAR >= 2023 & PECIFICATION_TYPE == "OFL") |>
               dplyr::reframe(
                 Year = c(YEAR, 2025:2034),
                 `Adopted OFL` = c(round(VAL, 0), rep("-", 10))
               ),
             utils::read.csv(here::here("data-processed", "harvest_spex.csv")) |>
               dplyr::filter(AREA_NAME == "CW" & YEAR >= 2023 & PECIFICATION_TYPE == "ACL") |>
               dplyr::reframe(
                 `Adopted ACL` = c(round(VAL, 0), rep("-", 10))
               ))

x <- model[["timeseries"]] |>
  dplyr::reframe(
    Year = Yr,
    `Assumed Removals` = round(rowSums(dplyr::across(dplyr::starts_with("dead(B)"))), 0),
    ABC = round(rowSums(dplyr::across(dplyr::starts_with("dead(B)"))), 0),
    `Spawning Biomass` = round(SpawnBio, 1),
    `Fraction Unfished` = round(`Spawning Biomass`/`Spawning Biomass`[1],3)
  ) |>
  dplyr::filter(Year > model[["endyr"]])

x[x$Year > 2024, "Assumed Removals"] <- "-"
x[x$Year %in% 2023:2024, "ABC"] <- "-"
OFL <- round(model$derived_quants[model$derived_quants$Label %in% paste0("OFLCatch_", 2023:2034), "Value"], 0) 
OFL[1:2] <- "-"
out <- cbind(tab, x[, "Assumed Removals"], OFL, x[,c(-1, -2)])
colnames(out)[4] <- "Assumed Removals"

t <- sa4ss::table_format(
  x = out,
  caption = "The adopted OFL (mt), ACL (mt), and assumed removals (mt) in 2023-24 and the projected OFL (mt), ABC (mt), spawning biomass, and fraction unfished for 2025-2034. The projected ABCs are calculated using a P* of 0.45 and category 1 time-varying sigma.",
  label = "projectionES",
  align = "r",
  custom_width = TRUE,
  col_to_adjust = c(2:8),
  width = c("1.4cm", "1.4cm", rep("1.6cm", 5))
)

kableExtra::save_kable(t,
                       file = fs::path(model_location, "tables", "projections.tex"))
}                       