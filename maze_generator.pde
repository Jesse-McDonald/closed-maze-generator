//Author Jamcdonald120
// generates a 2D closed maze
int xSize=45+2;//blocks in width with 1 wide border
int ySize=45+2;//blocks in height with 1 wide border
int blockSize=10;//number of pixles accross each square block
int ideration=xSize*ySize*2;//number of times randomize will be ran again this should be large compaired to number of blocks
int smoothing=0;//number of times smoothing will be ran again
//both randomization and smoothing will run atleat once

abstract class State{//state machine base
  public abstract void update(); 
  
  public void invertSquare(int x,int y){//turns black squares white and white squares black
  color c=get(x,y);//-16777216 returns if black, -1 if white
  c=(c+16777216)*-1; //-16777216+16777216=0 which will round to -1 later, -1+16777216=16777217 *-1 is black code
  fill(c);
  rect(x,y,blockSize,blockSize); 
  }
}//close of State

class done extends State{//empty function for program to park in at end
 
  public void update(){
  }
}//close of done
//this state generates a random pattern of black and white squares
//this should be ran multiple times, about 7-10 times the number of blocks
class noiseMap extends State{
  int i=0;//class wide counter named i becase I was lazy
  
  public void update(){
  int xCoord=floor(random(xSize-2)+1)*blockSize;
  int yCoord=floor(random(ySize-2)+1)*blockSize;
  invertSquare(xCoord,yCoord);
  if (ideration<i){//what with exit checking, above will always run once atleast.
    state=new Maze();//start smoothing
  }
  i++;
  }
}//close of noiseMap
//this state smoothes the random noise map in to a maze
//after a few iterations this function will have no noticably effect as it has already 
//smoothed everything to the max
class Maze extends State{
  int oldX=0;//not realy old x, but I hade to name it something and just x would not cut it
  int oldY=0;
  int repetitions=0;//internal counter, why is this one not named i?  because I am consistanly inconsistant
 public void update(){
   oldX++;
   if(oldX>xSize-1){
   oldX=1;
   oldY++;
   }//above section handles x and y position, I did not want to have to
  //fidle with the border and mod so it is like this
   if(oldY>ySize-1){//more y handling to check if I need to start again, if I can.
     oldY=1;
     repetitions++;
     if (repetitions>smoothing){
       print("Done");
       state=new done();//program essencialy done here
     }
   }
   int x=oldX*blockSize+blockSize/2;
   int y=oldY*blockSize+blockSize/2;
   if(detectCorners(x,y)>2){//this condion is fun to expiriment with, 2 makes the best result
   //0 inverts maze repeatedly, 1 tends to streight lines in 1 direction, 3 does very little, 4 causes no change at all
     invertSquare(oldX*blockSize,oldY*blockSize);
   }
   //   if(detectNeigbors(x,y)>3){//this condion is fun to expiriment with, 2 makes the best result
   //0 inverts maze repeatedly, 1 tends to streight lines in 1 direction, 3 does very little, 4 causes no change at all
    // invertSquare(oldX*blockSize,oldY*blockSize);
   //}
 }

 
 public int detectCorners(int x, int y){
   
   color c=get(x,y);
   int count = 0;
   /*
   if(c==get(x+blockSize,y)){
     count+=1;
   }
   if(c==get(x-blockSize,y)){
     count+=1;
   }
   if(c==get(x,y-blockSize)){
     count+=1;
   }
   if(c==get(x,y-blockSize)){
     count+=1;
   }//detects adjacent pieces, cause cheker board patttern
   */
   if(c==get(x+blockSize,y+blockSize)){
     count+=1;
   }
   if(c==get(x-blockSize,y+blockSize)){
     count+=1;
   }
   if(c==get(x-blockSize,y-blockSize)){
     count+=1;
   }
   if(c==get(x+blockSize,y-blockSize)){
     count+=1;
   }//detects adjacent corners, this works for some reason.  Dont ask why. its magic
   
   return count;
 }
 public int detectNeigbors(int x, int y){
     color c=get(x,y);
   int count = 0;
   
   if(c==get(x+blockSize,y)){
     count+=1;
   }
   if(c==get(x-blockSize,y)){
     count+=1;
   }
   if(c==get(x,y-blockSize)){
     count+=1;
   }
   if(c==get(x,y-blockSize)){
     count+=1;
   }//detects adjacent pieces, cause cheker board patttern
    return count;
}
 } //close of Maze
State state=new noiseMap();// initilize state machine
void setup(){
  
 size(xSize*blockSize,ySize*blockSize);
 background(0);//black background
 fill(255);
 noStroke();//block edges kept getting in the way later
 rect(blockSize,blockSize,(xSize-2)*(blockSize),(ySize-2)*(blockSize));//make a 1 wide border by making all other area white
 }
void draw(){
  for (int i=0;i<10;i++){//draw runs 30 or 60 times per second, not sure which,
  //either is too slow, this essencialy makes it run 300 to 600 times per second, 
  //much better and still nice to look at
  state.update();}//only line needed, the rest is in the classes and initilize :)
  
}
void mouseClicked(){//click the mouse for an extra smoothing run, can be usefull.
 state=new Maze();
}
