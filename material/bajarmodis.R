#iniciamos
setwd('D:/Julian/52_variables_robin/modis/NPP')
source('D:/Julian/52_variables_robin/modis/NPP/ModisDownload.R')

# paquetes
library("lubridate")
library("raster")
library("MODIS")
library("sp")
library("rgdal")
library("rgeos")
library("mail")

Sys.getenv(c("MRT_DATA_DIR"))


# ver los productos disponibles
modisProducts()

# set output paths
MODISoptions(localArcPath="D:/Julian/52_variables_robin/modis/arc", outDirPath="D:/Julian/52_variables_robin/modis/mrt")

# MRT available
MODIS:::checkTools('MRT')

# Por ejemplo elegimos el producto MOD17A3   (62).
# 62  MOD17A3    Terra            Gross Primary Productivity  Tile      1000m   Yearly

# Rango de años
intro<-c(2000,2000)
print(paste("Range of years ::  ",intro[1],"to",intro[2]))
year   <- as.character(intro[1]:intro[2])
print(paste("All data = ", length(year)," year == ",length(year)*12," months"))
month  <- c('01','02','03','04','05','06','07','08','09','10','11','12')
end   <- c('28','29','30','31')
leap<-leap_year(2001:2014)


#comodin para el if
k=1:12 

# MOD17A3
x<- 1

# Informacion de los tiles correspondientes a Mexico
Mexico <- getTile(extent="Mexico")
h<-Mexico$tileH
v<-Mexico$tileV

# Path del MRT 
mrtpath<-"C:/Modis/bin"

# Path del output (cambiar al propio)
mainDir = "D:/Julian/52_variables_robin/modis/NPP"

for(i in 1:length(year)){
  
  for(j in 1:12){
    if(leap[i]==FALSE && j==2){
      endM<-end[1]
    }else{
      if(leap[i]==TRUE && j==2){
        endM<-end[2]
      }else{
        if(k[j]==1||k[j]==3||k[j]==5||k[j]==7||k[j]==8||k[j]==10||k[j]==12){ 
          endM<-end[4]
        }else{
          if(k[j]==4||k[j]==6||k[j]==9||k[j]==11){ 
            endM<-end[3]
          }      
        }           
      }
    }
    start  <-paste(year[i],".",month[j],".","01",sep='')
    finish <-paste(year[i],".",month[j],".",endM,sep='')
    date <- c(start,finish)
    print(date)
    print(paste("Processing",year[i],month[j]))
    
    #sendmail("julian.equihua@gmail.com","Descarga va en", #esto ayuda para ir viendo como va la descarga por correo
    #         paste("Procesando ",year[i],month[j]))
    
    try(ModisDownload(x=x,h=h,v=v,date=date,MRTpath=mrtpath,
                  
                  mosaic=TRUE,
                  
                  proj=TRUE,
                  
                  delete=TRUE,
                  
                  proj_type="LCC",              
                  
                  proj_params="0 0 17.5 29.5 -102 12 2500000 0 0 0 0 0 0 0 0",
                  
                  UL=c(850000,2410000),
                  
                  LR=c(4150000,250000),
                  
                  #bands_subset="1 0 0 0 0 0 0 0 0 0 0",
                  
                  datum='WGS84',
                  
                  resample_type="NEAREST_NEIGHBOR",
                  
                  pixel_size=1000
                  )
        ) 
  }
}


