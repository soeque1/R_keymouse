rm(list = ls())

library(stringr)
library(rJava)  

key.map <- read.csv('c:/repo/keymouse/keymap.txt', sep = '\t', header=F, stringsAsFactors = F)
colnames(key.map) <- c('type', 'field', 'value')
key.map$field <- str_trim(key.map$field)
key.map$value <- as.numeric(str_trim(key.map$value))

StartKeyMouse <- function(){
  # this starts the JVM
  jRobot <- .jinit()             
  assign("jRobot", .jnew("java/awt/Robot"), envir = .GlobalEnv)
  assign("getMouse", .jnew("java/awt/MouseInfo"), envir = .GlobalEnv)
}

MouseMove <- function(x,y){
  .jcall(jRobot,, "mouseMove", as.integer(x), as.integer(y))  
}

MouseLeftPress <- function(x){
  .jcall(jRobot,, "mousePress", as.integer(16))  
}

MouseLeftRelease <- function(x){
  .jcall(jRobot,, "mouseRelease", as.integer(16))  
}

GetMovePoistion <- function(){
  res <- .jstrVal(.jrcall(.jrcall(getMouse, "getPointerInfo"), "getLocation"))
  x <- as.numeric(str_match(res, 'x=([0-9]+)')[,2])
  y <- as.numeric(str_match(res, 'y=([0-9]+)')[,2])
  out <- c(x,y)
  return(out)
}

KeyEvent <- function(key, key.map){
  value <- key.map[key.map[, 'field'] == key, 'value']
  return(value)
}

KeyPress <- function(key = 'VK_ENTER'){
  
  ## https://docs.oracle.com/javase/7/docs/api/constant-values.html#java.awt.event.KeyEvent.VK_7
  ## Key Mapping
  
  value <- KeyEvent(key, key.map)
  
  if(length(value) == 0)
  {
    print ('Missing Key')
  } else {
    .jcall(jRobot,, "keyPress", as.integer(value))    
  }

}

keyRelease <- function(key = 'VK_ENTER'){
  
  ## https://docs.oracle.com/javase/7/docs/api/constant-values.html#java.awt.event.KeyEvent.VK_7
  ## Key Mapping
  
  value <- KeyEvent(key, key.map)
  
  if(length(value) == 0)
  {
    print ('Missing Key')
  } else {
    .jcall(jRobot,, "keyRelease", as.integer(value))    
  }
  
}


.jmethods(jRobot)
key.map

StartKeyMouse()
GetMovePoistion()

MouseMove(500, 500)
MouseLeftPress()
MouseLeftRelease()
KeyPress('VK_ENTER')
keyRelease('VK_ENTER')

KeyPress('VK_CONTROL')
KeyPress('VK_L')

keyRelease('VK_CONTROL')
keyRelease('VK_L')

