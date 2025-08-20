# Crop Yield Analysis (2015-2024)
# Author: Anjana Poudel

library(tidyverse)
library(ggthemes)
library(readxl)

data <- read_csv("C:/Users/Dell/Desktop/CropYieldAnalysis/data/sample_crop_yield.csv")

data_clean <- data %>%
  select(Year, Country, Crop, Yield) %>%
  filter(!is.na(Yield))

plots_path <- "C:/Users/Dell/Desktop/CropYieldAnalysis/plots"
if(!dir.exists(plots_path)) dir.create(plots_path)

# Potato Yield Trend
potato_data <- data_clean %>% filter(Crop == "Potato")
potato_plot <- ggplot(potato_data, aes(x = Year, y = Yield, color = Country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(title = "Potato Yield Trend (2015-2024)",
       x = "Year",
       y = "Yield (tons/ha)")
potato_plot
ggsave(file.path(plots_path, "potato_trend.png"), potato_plot, width = 8, height = 5)

# Average Yield by Crop
avg_yield <- data_clean %>%
  group_by(Crop) %>%
  summarise(mean_yield = mean(Yield, na.rm = TRUE))

avg_plot <- ggplot(avg_yield, aes(x = reorder(Crop, -mean_yield), y = mean_yield, fill = Crop)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Average Crop Yield (2015-2024)",
       x = "Crop",
       y = "Average Yield (tons/ha)") +
  theme(legend.position = "none")
avg_plot
ggsave(file.path(plots_path, "avg_crop_yield.png"), avg_plot, width = 8, height = 5)

# Yield Distribution by Country
country_plot <- ggplot(data_clean, aes(x = Crop, y = Yield, fill = Country)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Crop Yield Distribution by Country (2015-2024)",
       x = "Crop",
       y = "Yield (tons/ha)")
country_plot
ggsave(file.path(plots_path, "yield_by_country.png"), country_plot, width = 8, height = 5)
