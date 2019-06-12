library(ggplot2)
library(reshape2)

path.data = 'data'
path.graph = 'graphs'

file.list = dir(path.data)

filename = file.list[5]
for(filename in file.list) {
  fname = file.path(path.data, filename)
  d=read.csv(fname)
  head(d)
  str(d)
  names(d)
  names(d)[1:5] = c('time','ax','ay','az','a')
  
  
  q = melt(d, id='time')
  head(q)
  print(fname)
  names(q)[2] = 'dir'
  ggplot(q, aes(time, value, col=dir)) + 
    geom_smooth(se=FALSE) + 
    scale_y_continuous(limits=c(-4,4)) +
    theme_bw(base_size = 12) + 
    xlab('time (s)') + 
    ylab(expression(paste('acceleration (m/s'^2,')')))
  ggsave(file.path(path.graph,
                   gsub('.csv','.png',filename)),
         width=3, height=2)
}