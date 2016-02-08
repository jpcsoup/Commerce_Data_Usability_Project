##########################
#
# This R script looks at food products (SCTG code between 01 and 09)
# and compares the total miles and value of each category by season.
#
#
###########################

library(readr)
library(ggplot2)
library(dplyr)

#　download.file("http://www.census.gov/econ/cfs/2012/cfs_2012_pumf_csv.zip", destfile="csf.zip")
#　unzip("csf.zip")

commodityflow = read_csv("cfs_2012_pumf_csv.txt")
glimpse(commodityflow)

# how does agricultural product change over season
agri_byseason = commodityflow %>% filter(SCTG < 10 & SCTG != "0" & SCTG!="00" &
                                           SCTG!="01-05" & SCTG!="06-09") %>% 
                group_by(QUARTER, SCTG) %>%
                summarize(total_value = sum(SHIPMT_VALUE),
                          total_miles = sum(SHIPMT_DIST_ROUTED))

glimpse(agri_byseason)

seafood = agri_byseason[agri_byseason$SCTG=="01",]
qplot(data=seafood, x=QUARTER, y = total_value)

ggplot(agri_byseason, aes(x=QUARTER, y=total_value, group=SCTG, color=SCTG))+
  geom_line()

description = c("Animals and Fish (live)",
                "Cereal Grains (includes seed)",
                "Agricultural Products (excludes Animal Feed, Cereal Grains, and Forage Products)",
                "Animal Feed, Eggs, Honey, and Other Products of Animal Origin",
                "Meat, Poultry, Fish, Seafood, and Their Preparations",
                "Milled Grain Products and Preparations, and Bakery Products",
                "Other Prepared Foodstuffs, and Fats and Oils",
                "Alcoholic Beverages and Denatured Alcohol",
                "Tobacco Products"
)

SCTG = c("01","02","03","04","05","06","07","08","09"  )
map = data.frame(description, SCTG)

agri_byseason = agri_byseason %>% left_join(map)
head(agri_byseason)

pdf("Food products by season.pdf")
ggplot(agri_byseason, aes(x=QUARTER, y=total_value))+
  geom_line()+
  facet_wrap(~description)+
  labs(title="Food Products", labeller = label_wrap_gen(width=20))
dev.off()


pdf("Food products by season - miles.pdf")
ggplot(agri_byseason, aes(x=QUARTER, y=total_miles))+
  geom_line()+
  facet_wrap(~description)+
  labs(title="How long has your food travelled?", labeller = label_wrap_gen(width=20))
dev.off()


