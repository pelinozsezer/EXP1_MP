# this code is to create motion quartet stimuli
# in which the aspect ratio changes

# do!!!
# set working directory to source file location

library(colorRamps)
library(colorspace)
library(beepr)

unlink("plots/*")

nr_of_quartets = 4
n= nr_of_quartets * 2 # number of dots 
cex=2 # size of dots
background_color='black'
dot_color= 'red'
maxAR=1.5 # max Aspect ration in hystersis loop (=1/minAR)
fps = 4 # frames per second in gif
shiftii=.01 # shift in x (set to 0 to e it effect)
shiftjj=.01 # shift in y (set to 0 to e it effect)
m=matrix(0,n^2,2) # matrix with coordinates of equidiatant dots
shift=matrix(0,n^2,2) # shift in x and y coordiantes to make them seperate quartets
counter=1:n^2
  for(i in 1:n)
    for(j in 1:n)
    {
      shifti=ifelse(i%%2==1,-shiftii,shiftii)
      shiftj=ifelse(j%%2==1,-shiftjj,shiftjj)
      shift[n*(i-1)+j,]=c(shifti,shiftj) # make the shift matrix
      m[n*(i-1)+j,]=c(i/(n+1),j/(n+1)) # make the m matrix
    }

on=matrix(c(T,F),n+1,n)[-(n+1),]
on=as.vector(on) # to seperate then on and off dots

# check configiguration
plot(m[on,]+shift[on,],col='blue',cex=cex,xlim=0:1,ylim=0:1,pch=19,axes=F,bty='n')
points(m[!on,]+shift[!on,],col='red',cex=cex,pch=19,bty='n')

plot(m+shift,col='lightgrey',cex=cex,xlim=0:1,ylim=0:1,pch=19,axes=F,bty='n')
text((m+shift)[,1], (m+shift)[,2], counter)

height=(m[2,2]+shift[2,2])-(m[1,2]+shift[1,2])
width=(m[n+1,1]+shift[n+1,1])-(m[n,1]+shift[n,1])
height
width
AR=height/width


ii=10 # number of steps in change of AR (aspect ratio)
iii=seq(1:(.5*ii)) # AR increase
iii=c(iii,rev(iii)) # AR decrease




base_shift = 0.1 # to make base square somewhat bigger
iteration=0
for(i in 1:ii)
  {
  shiftii=base_shift+(iii[i]-.25*ii)/1000 # AR change x-coordinate
  shiftjj=base_shift-(iii[i]-.25*ii)/1000 # AR change y-coordinate
  
  # put in shift matrix
  shift=cbind(rep(c(shiftii,-shiftii),each=n,times=.5*n),rep(c(shiftjj,-shiftjj),each=1,times=n^2/2))
  
  height=(m[2,2]+shift[2,2])-(m[1,2]+shift[1,2])
  width=(m[n+1,1]+shift[n+1,1])-(m[n,1]+shift[n,1])
  height
  width
  AR=height/width
  print(c(i,AR,1/AR))
  
  iteration=iteration+1 # odd figure
  png(paste0("plots/pngplots_",1000+iteration,".png"),width=9,height=9,units="in",res=200) # open png
  par(bg=background_color) # background color
  # plot odd plot
  plot(m[!on,]+shift[!on,],col=dot_color,cex=cex,xlim=0:1,ylim=0:1,pch=19,axes=F,bty='n',xlab='',ylab='')
  dev.off() # close png
  
  iteration=iteration+1 # even figure
  png(paste0("plots/pngplots_",1000+iteration,".png"),width=9,height=9,units="in",res=200)
  par(bg=background_color)
  # plot even plot
  plot(m[on,]+shift[on,],col=dot_color,cex=cex,xlim=0:1,ylim=0:1,pch=19,axes=F,bty='n',xlab='',ylab='')
  dev.off()
  
  }

# make a gif, off all the individual plots
Sys.sleep(1)
library(magick)

list.files(path=paste0("plots/"), pattern = '*.png', full.names = TRUE) %>%
  image_read() %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=fps,loop=0) %>% # animates, can opt for number of loops
  image_write(paste0("plots/Anim.gif")) # write to current dir

beep(2) # when ready (takes a while)
