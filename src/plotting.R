
library(ggplot2)
library(ggpubr)

plot_distribution = function(data, input){
  # plots distribution of a QC characteristic given data and user input
  
  ggplot(data, aes(x=eval(parse(text=input$metric)))) +
    geom_histogram(aes(y=..density..), colour="black", fill="white", bins = 50) +
    geom_density(alpha=.3, fill="lightblue") +
    geom_vline(aes(xintercept = tail(data[,input$metric], n=1) ),
               linetype = "dashed", size = 0.8, color = "#FC4E07") +
    labs(x = "Value", y = "Frequency") +
    ggtitle(input$metric) +
    theme(plot.title = element_text(hjust = 0.5))
}

plot_chronology = function(data, input){
  # plots chronological values of a QC characteristic given data and user input  
  ggplot(data, aes(x = acquisition_date, y = eval(parse(text=input$metric)))) +
    geom_point(size = 2) + geom_line(group = 1) +
    geom_point(data=data[nrow(data), c(input$metric, "acquisition_date")], aes(x = acquisition_date, y = eval(parse(text=input$metric))), color="red", size=2) +  # add red dot in the end
    theme(axis.text.x = element_text(angle = 90)) +
    labs(x = "Date & time", y = "Value") +
    ggtitle(input$metric) +
    theme(plot.title = element_text(hjust = 0.5))
}

plot_qc_summary = function(data){
  # plots distribution of QC characteristics of a run on a single figure
  plots_list = list()
  for (i in 3:ncol(data)){
    
    qc_name = colnames(data)[i]
    df = data.frame(values = data[,i], qc_metric = qc_name)
    
    plots_list[[i-2]] = ggplot(df, aes(qc_metric, values)) +
      geom_violin(alpha=.3, fill="lightblue") +
      geom_boxplot(width=0.075) +
      # geom_jitter(shape=1, size=3, position=position_jitter(0.15)) +
      labs(x= "", y = "") +
      geom_hline(aes(yintercept = tail(values, n=1)),
                 linetype = "dashed", size = 0.6, color = "#FC4E07")
    
  }
  ggarrange(plotlist=plots_list, ncol=4, nrow=4)
}


