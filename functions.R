

skill_dots <- function(skills, scores, text_size = 21){
  
  # example
  # skill_dots(skills <- c("German", "English", "French"),
  #           scores <- c(5, 4, 1))
  
  skills_v <- skills
  
  if(length(skills) != length(scores))
    stop("skills vector and scores vector have not the same length!")
  
  df <- expand.grid(skills = skills, scores = c(1:5)) |> 
    left_join(., tibble(skills, scores, binary = 1)) |> 
    mutate(skills = factor(skills, levels = rev(skills_v))) |> 
    arrange(skills) |> 
    group_by(skills) |> 
    fill(binary, .direction = "up") |> 
    ungroup() |> 
    mutate(binary = ifelse(!is.na(binary), 1, 0))
  
  plot <- df |>  
    #mutate(color_value = ifelse(binary == 1, scores / 5, NA)) |>  
    ggplot(aes(x=scores, y = skills, color = factor(binary))) +
    geom_point(size = 7.5, stroke = NA) +
    scale_color_manual(values = c("lightgrey", "#1E4A40CC"),
                       labels = c("0", "1")) +  
    # scale_color_gradient(low = "#23534766", high = "#235347", 
    #                      limits = c(0, 1.2),
    #                      breaks = c(0, 1), 
    #                      labels = c("0", "1"),
    #                      na.value = "lightgrey") +  # Set color for binary 0
    scale_x_continuous(expand = c(0.1,0)) +
    xlab('') + ylab('') + 
    theme_void() +
    theme(text = element_text(family = "sans"),
          axis.text.y = element_text(size = text_size,
                                     hjust = -0),
          axis.text.x = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),
          legend.position = "none")
  
  return(plot)
  
}

