void main(){
  String name = 'Hello Ayush';
  String binaryCode = '';
  String wordsStore = '';
  int i=0;
  for(int binary in name.codeUnits){
   // print('${name[i]} = $binary');
    i=i+1;
    binaryCode = binary.toRadixString(2).padLeft(8,'0');
    wordsStore +=binaryCode;
  }
  print('$name = $wordsStore');
}