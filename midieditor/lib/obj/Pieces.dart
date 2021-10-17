


class Pieces {
  int type; //0无子 1白子 2黑子 null 没有

  Pieces({this.type});
  
  void setType(int type){
    this.type = type;
  }

  int getType(){
    return type;
  }
}