
# Layers ------------------------------------------------------------------

library(tidyverse)

# Aesthetic mappings ------------------------------------------------------

ggplot(mpg, aes(displ, hwy, color=class)) +
  geom_point()

mpg |> 
  ggplot(aes(displ, hwy, size=class)) +
  geom_point()

mpg |> 
  ggplot(aes(displ, hwy, alpha=class)) +
  geom_point()

# The advisement is because size and alpha give an impression of order
# or rank which doesn't exist here.


# Geometric Objects -------------------------------------------------------

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_smooth()

mpg |> 
  ggplot(aes(displ, hwy, linetype = drv)) +
  geom_smooth()

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_smooth(aes(color = drv))

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

# Higlighting specific data points

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "orange"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "blue"
  )

# Ridge plot
library(ggridges)

mpg |> 
  ggplot(aes(hwy, drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)
  

# Facets ------------------------------------------------------------------

# One variable
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~cyl)
  
# Two variables
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)

# Allow scales to adjust for ease of seeing points
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free_y")


# Statistical transformations ---------------------------------------------

ggplot(diamonds, aes(x = cut)) +
  geom_bar()

diamonds |> 
  count(cut) |> 
  ggplot(aes(cut, n)) +
  geom_bar(stat = "identity")

diamonds |> 
  ggplot(aes(cut, after_stat(prop), group = 1)) +
  geom_bar()

diamonds |> 
  ggplot() + 
  stat_summary(
    aes(cut, depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


# Position adjustments ----------------------------------------------------

ggplot(mpg, aes(drv, fill=drv)) +
  geom_bar()

ggplot(mpg, aes(drv, fill=class)) +
  geom_bar()

ggplot(mpg, aes(drv, fill=class)) +
  geom_bar(position = "fill")

ggplot(mpg, aes(drv, fill=class)) +
  geom_bar(position = "dodge")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(position = "jitter")

ggplot(mpg, aes(displ, hwy)) +
  geom_jitter()


# Coordinate systems ------------------------------------------------------

# Latitude and Longitude
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# Polar
bar <- ggplot(diamonds) +
  geom_bar(aes(clarity, fill = clarity), 
           show.legend = FALSE, width = 1) +
  theme(aspect.ratio = 1)
bar + coord_flip()
bar + coord_polar()



