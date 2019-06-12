# (c) 2019 Thomas Gredig
# phyphox experiment for acceleration with toy car

library(ggplot2)
library(reshape2)

# directories
path.data = 'data'
path.graph = 'graphs'

# find all the data files
file.list = dir(path.data,pattern='csv$')

# convert the data files into graphs
for(filename in file.list) {
  # load data
  fname = file.path(path.data, filename)
  d=read.csv(fname)
  names(d)[1:5] = c('time','ax','ay','az','a')
  
  # melt data for ggplot2
  q = melt(d, id='time')
  names(q)[2] = 'dir'
  
  # make the graph
  ggplot(q, aes(time, value, col=dir)) + 
    geom_smooth(se=FALSE) + 
    scale_y_continuous(limits=c(-4,4)) +
    theme_bw(base_size = 12) + 
    xlab('time (s)') + 
    ylab(expression(paste('acceleration (m/s'^2,')')))
  
  # save the graph
  ggsave(file.path(path.graph,
                   gsub('.csv','.png',filename)),
         width=3, height=2)
  
  # make second graph with acceleration in direction
  # of cart motion ony
  av0 = round(nrow(d)/10)
  s = spline(d$time, d$ay, n=av0)
  d1 = data.frame(
    time = s$x,
    ay = s$y
  )
  # remove last few data points
  d1 = d1[-((nrow(d1)-5):nrow(d1)),]
  ggplot(d1, aes(time, ay)) +
    geom_point(size=4, col='blue') +
    geom_path() +
    theme_bw(base_size = 12) + 
    xlab('time(s)') +
    ylab(expression(paste('a'[y],' (m/s'^2,')')))
  # save the graph
  ggsave(file.path(path.graph,
                   gsub('.csv','-ay.png',filename)),
         width=3, height=2)
}